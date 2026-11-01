import 'package:flutter/material.dart';

import 'data/local/database.dart';
import 'data/local/database_seeder.dart';
import 'data/preview_state.dart';
import 'data/remote/fault_config.dart';
import 'data/remote/simulated_remote_service.dart';
import 'data/repository/proptech_repository_impl.dart';
import 'ui/app_shell.dart';
import 'ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  await repository.runStartupRecovery();

  final appState = GharHoldPreviewState(
    repository: repository,
    faultConfig: faultConfig,
  );
  await appState.initialize();

  runApp(GharHoldApp(previewState: appState));
}

class GharHoldApp extends StatelessWidget {
  final GharHoldPreviewState previewState;

  const GharHoldApp({super.key, required this.previewState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GharHold',
      debugShowCheckedModeBanner: false,
      theme: GharHoldTheme.lightTheme,
      home: GharHoldAppShell(state: previewState),
    );
  }
}
