/// No-op implementation of ObservabilityService.
///
/// Used in tests, offline environments, or when Measure telemetry is disabled.
/// Guarantees zero overhead, zero network calls, and deterministic behavior.
library;

import 'package:flutter/widgets.dart';
import 'observability_service.dart';

class NoOpObservabilityService implements ObservabilityService {
  final List<Map<String, dynamic>> recordedEvents = [];
  final List<String> recordedScreens = [];
  final List<String> recordedSpans = [];

  @override
  bool get isEnabled => false;

  @override
  Future<void> initialize() async {}

  @override
  ObservabilitySpan startSpan(String name) {
    recordedSpans.add(name);
    return const NoOpSpan();
  }

  @override
  void trackCustomEvent(
    String name, {
    Map<String, Object> attributes = const {},
  }) {
    recordedEvents.add({
      'name': name,
      'attributes': Map<String, Object>.from(attributes),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  void trackScreenView(String screenName) {
    recordedScreens.add(screenName);
  }

  @override
  void trackHandledError(
    Object error,
    StackTrace stack, {
    Map<String, Object> context = const {},
  }) {}

  @override
  NavigatorObserver? get navigatorObserver => null;

  @override
  Widget wrapRootWidget(Widget child) => child;

  @override
  Future<void> stop() async {}
}
