import 'package:flutter/material.dart';

import 'data/local/database.dart';
import 'data/local/database_seeder.dart';
import 'data/preview_state.dart';
import 'data/remote/fault_config.dart';
import 'data/remote/simulated_remote_service.dart';
import 'data/repository/proptech_repository_impl.dart';
import 'observability/measure_observability_service.dart';
import 'observability/noop_observability_service.dart';
import 'observability/observability_service.dart';
import 'ui/app_shell.dart';
import 'ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Environment-based observability enablement:
  // Can be controlled via --dart-define=ENABLE_MEASURE=true / false
  const enableMeasure = bool.fromEnvironment(
    'ENABLE_MEASURE',
    defaultValue: true,
  );
  final ObservabilityService observabilityService = enableMeasure
      ? MeasureObservabilityService()
      : NoOpObservabilityService();

  // Initialize observability safely (fails gracefully without throwing or blocking)
  await observabilityService.initialize();

  // Track initial application startup span
  final startupSpan = observabilityService.startSpan('app_startup');
  startupSpan.setAttribute('layer', 'initialization');

  // Initialize durable local-first Drift/SQLite database
  final db = AppDatabase();
  final faultConfig = FaultConfig();
  final remoteService = SimulatedRemoteService(config: faultConfig);
  final repository = ProptechRepositoryImpl(
    db: db,
    remoteService: remoteService,
  );

  // Idempotently seed initial 10 fixtures & L5 active request
  await DatabaseSeeder(db).seed();

  // Execute startup recovery scan for any leftover PENDING_SYNC requests
  final recoverySpan = observabilityService.startSpan('startup_recovery_scan');
  await repository.runStartupRecovery();
  recoverySpan.setStatusOk();
  recoverySpan.end();

  final appState = GharHoldPreviewState(
    repository: repository,
    faultConfig: faultConfig,
    observability: observabilityService,
  );
  await appState.initialize();

  observabilityService.trackCustomEvent(
    'app_started',
    attributes: {'persistence': 'drift_sqlite', 'remote': 'simulated'},
  );

  startupSpan.setStatusOk();
  startupSpan.end();

  final appWidget = GharHoldApp(
    previewState: appState,
    observabilityService: observabilityService,
  );

  runApp(observabilityService.wrapRootWidget(appWidget));
}

class GharHoldApp extends StatelessWidget {
  final GharHoldPreviewState previewState;
  final ObservabilityService? observabilityService;

  const GharHoldApp({
    super.key,
    required this.previewState,
    this.observabilityService,
  });

  @override
  Widget build(BuildContext context) {
    final observer = observabilityService?.navigatorObserver;
    return MaterialApp(
      title: 'GharHold',
      debugShowCheckedModeBanner: false,
      theme: GharHoldTheme.lightTheme,
      navigatorObservers: observer != null ? [observer] : const [],
      home: GharHoldAppShell(state: previewState),
    );
  }
}
