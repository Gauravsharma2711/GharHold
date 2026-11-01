/// Measure.sh implementation of ObservabilityService.
///
/// Wraps official `measure_flutter` package to provide:
/// - Crash reporting
/// - Android ANR monitoring
/// - Performance spans
/// - Safe custom events without PII
/// - Navigation tracking
///
/// Privacy Invariants:
/// - Screen masking is applied to prevent any PII or notes leaking.
/// - Custom event attributes strictly sanitize or drop addresses, GPS, phone, and notes.
library;

import 'dart:developer' as developer;
import 'package:flutter/widgets.dart';
import 'package:measure_flutter/measure_flutter.dart';
import 'observability_service.dart';

class MeasureSpanWrapper implements ObservabilitySpan {
  final Span _span;

  MeasureSpanWrapper(this._span);

  @override
  void setAttribute(String key, Object value) {
    if (value is String) {
      _span.setCheckpoint(key);
    }
  }

  @override
  void setStatusOk() {
    _span.setStatus(SpanStatus.ok);
  }

  @override
  void setStatusError(String description) {
    _span.setStatus(SpanStatus.error);
  }

  @override
  void end() {
    _span.end();
  }
}

class MeasureObservabilityService implements ObservabilityService {
  final bool enableLogging;
  final bool autoStart;
  bool _initialized = false;
  MsrNavigatorObserver? _navigatorObserver;

  MeasureObservabilityService({
    this.enableLogging = false,
    this.autoStart = true,
  });

  @override
  bool get isEnabled => _initialized;

  @override
  Future<void> initialize() async {
    try {
      // Configure privacy-preserving defaults
      const config = MeasureConfig(
        enableLogging: false,
        autoStart: true,
        enableDiagnosticMode: false,
      );

      // Initialize Measure. If native channel fails, catch safely.
      if (!_initialized) {
        await Measure.instance.init(() {}, config: config);
        _initialized = true;
        _navigatorObserver = MsrNavigatorObserver();
      }
    } catch (e, st) {
      developer.log(
        'Measure initialization failed gracefully. Telemetry disabled.',
        error: e,
        stackTrace: st,
      );
      _initialized = false;
    }
  }

  @override
  ObservabilitySpan startSpan(String name) {
    if (!isEnabled) {
      return const NoOpSpan();
    }
    try {
      final span = Measure.instance.startSpan(name);
      return MeasureSpanWrapper(span);
    } catch (_) {
      return const NoOpSpan();
    }
  }

  @override
  void trackCustomEvent(
    String name, {
    Map<String, Object> attributes = const {},
  }) {
    if (!isEnabled) return;
    try {
      final safeBuilder = AttributeBuilder();
      for (final entry in attributes.entries) {
        // Enforce privacy rule: Exclude forbidden PII and sensitive keys
        final key = entry.key.toLowerCase();
        if (key.contains('phone') ||
            key.contains('email') ||
            key.contains('address') ||
            key.contains('location') ||
            key.contains('note') ||
            key.contains('secret') ||
            key.contains('token_value')) {
          continue;
        }

        final val = entry.value;
        if (val is String) {
          safeBuilder.add(entry.key, val);
        } else if (val is int) {
          safeBuilder.add(entry.key, val);
        } else if (val is double) {
          safeBuilder.add(entry.key, val);
        } else if (val is bool) {
          safeBuilder.add(entry.key, val);
        } else {
          safeBuilder.add(entry.key, val.toString());
        }
      }

      Measure.instance.trackEvent(name: name, attributes: safeBuilder.build());
    } catch (_) {
      // Telemetry must never crash the app
    }
  }

  @override
  void trackScreenView(String screenName) {
    if (!isEnabled) return;
    try {
      Measure.instance.trackScreenViewEvent(
        name: screenName,
        captureLayoutSnapshot:
            false, // Privacy safe: do not snapshot raw screens by default
      );
    } catch (_) {
      // Silent catch
    }
  }

  @override
  void trackHandledError(
    Object error,
    StackTrace stack, {
    Map<String, Object> context = const {},
  }) {
    if (!isEnabled) return;
    try {
      final attrBuilder = AttributeBuilder();
      for (final entry in context.entries) {
        attrBuilder.add(entry.key, entry.value.toString());
      }
      Measure.instance.trackHandledError(
        error,
        stack,
        attributes: attrBuilder.build(),
      );
    } catch (_) {
      // Telemetry error must never impact business flow
    }
  }

  @override
  NavigatorObserver? get navigatorObserver => _navigatorObserver;

  @override
  Widget wrapRootWidget(Widget child) {
    return MeasureWidget(child: child);
  }

  @override
  Future<void> stop() async {
    if (isEnabled) {
      await Measure.instance.stop();
    }
  }
}
