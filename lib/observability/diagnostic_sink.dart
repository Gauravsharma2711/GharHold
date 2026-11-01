/// Observability module for GharHold.
/// Provides structured logging of AuditEvents and in-memory sample traces.
library;

import '../domain/models/audit_event.dart';

abstract class DiagnosticSink {
  void log(AuditEvent event);
  List<AuditEvent> get events;
  void clear();
}

class InMemDiagnosticSink implements DiagnosticSink {
  final List<AuditEvent> _events = [];

  InMemDiagnosticSink([List<AuditEvent>? initialEvents]) {
    if (initialEvents != null) {
      _events.addAll(initialEvents);
    }
  }

  @override
  void log(AuditEvent event) {
    _events.insert(0, event); // newest first
  }

  @override
  List<AuditEvent> get events => List.unmodifiable(_events);

  @override
  void clear() {
    _events.clear();
  }

  /// Deterministic sample events clearly labelled as preview samples for GH06
  static List<AuditEvent> createSamplePreviewEvents() {
    final now = DateTime.now();
    return [
      AuditEvent(
        timestamp: now.subtract(const Duration(minutes: 1)),
        correlationId: 'sample-corr-101',
        component: 'ui.preview_state',
        eventType: AuditEventType.STATE_TRANSITION,
        previousState: 'REQUESTED',
        newState: 'APPROVED',
        ruleOrErrorCode: null,
        summary:
            '[SAMPLE] Owner approved viewing request for listing L1 (Powai 2BHK)',
      ),
      AuditEvent(
        timestamp: now.subtract(const Duration(minutes: 4)),
        correlationId: 'sample-corr-100',
        component: 'ui.preview_state',
        eventType: AuditEventType.STATE_TRANSITION,
        previousState: 'AVAILABLE',
        newState: 'VIEWING_REQUESTED',
        ruleOrErrorCode: null,
        summary:
            '[SAMPLE] Renter submitted viewing request for listing L1 (Powai 2BHK)',
      ),
      AuditEvent(
        timestamp: now.subtract(const Duration(minutes: 10)),
        correlationId: 'sample-corr-099',
        component: 'domain.rules',
        eventType: AuditEventType.RULE_REJECTED,
        previousState: 'TOKEN_LOCKED',
        newState: 'TOKEN_LOCKED',
        ruleOrErrorCode: 'ERR_LISTING_NOT_AVAILABLE',
        summary:
            '[SAMPLE] Rejection: attempt to request viewing on token-locked listing L6',
      ),
      AuditEvent(
        timestamp: now.subtract(const Duration(minutes: 15)),
        correlationId: 'sample-corr-098',
        component: 'ui.preview_state',
        eventType: AuditEventType.DATA_RESET,
        previousState: 'RESET',
        newState: 'SEEDED',
        ruleOrErrorCode: null,
        summary:
            '[SAMPLE] In-memory preview fixtures initialized with 10 Mumbai listings',
      ),
    ];
  }
}
