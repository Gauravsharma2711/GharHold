/// Application Observability Service interface for GharHold.
///
/// Provides a clean abstraction separating GharHold business/diagnostic audit
/// (DiagnosticSink / AuditEvent) from technical mobile observability
/// (Measure.sh crash reporting, performance traces, navigation tracking, ANRs).
library;

import 'dart:async';
import 'package:flutter/widgets.dart';

/// Supported observability tracing span abstraction.
abstract class ObservabilitySpan {
  void setAttribute(String key, Object value);
  void setStatusOk();
  void setStatusError(String description);
  void end();
}

/// No-op trace span for testing and disabled observability.
class NoOpSpan implements ObservabilitySpan {
  const NoOpSpan();

  @override
  void setAttribute(String key, Object value) {}

  @override
  void setStatusOk() {}

  @override
  void setStatusError(String description) {}

  @override
  void end() {}
}

/// Abstract contract for mobile application observability.
abstract class ObservabilityService {
  /// Whether the service is actively initialized and telemetry is enabled.
  bool get isEnabled;

  /// Initializes the service safely without throwing or blocking app startup.
  Future<void> initialize();

  /// Starts a performance trace span for a critical operation.
  ObservabilitySpan startSpan(String name);

  /// Tracks a safe, non-sensitive custom telemetry event.
  ///
  /// Invariant: Attributes MUST NEVER contain PII, phone numbers, exact addresses,
  /// coordinates, or raw customer notes.
  void trackCustomEvent(
    String name, {
    Map<String, Object> attributes = const {},
  });

  /// Tracks screen view transitions with navigation context.
  void trackScreenView(String screenName);

  /// Captures a handled non-fatal error with optional context.
  void trackHandledError(
    Object error,
    StackTrace stack, {
    Map<String, Object> context = const {},
  });

  /// Attaches navigator observer if supported by the provider.
  NavigatorObserver? get navigatorObserver;

  /// Wraps root application widget with provider's telemetry/gesture boundary.
  Widget wrapRootWidget(Widget child);

  /// Safely stops data collection.
  Future<void> stop();
}
