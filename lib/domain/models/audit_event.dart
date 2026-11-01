/// Domain model for diagnostic audit events in GharHold.
/// Pure Dart: zero Flutter, database or network imports.
library;

enum AuditEventType {
  RULE_REJECTED,
  STATE_TRANSITION,
  SYNC_FAILURE,
  CONFLICT,
  RETRY,
  RESUME_SCAN,
  FAULT_SET,
  OWNER_DECISION,
  DATA_RESET,
}

class AuditEvent {
  final DateTime timestamp;
  final String correlationId;
  final String component;
  final AuditEventType eventType;
  final String previousState;
  final String newState;
  final String? ruleOrErrorCode;
  final String summary;

  const AuditEvent({
    required this.timestamp,
    required this.correlationId,
    required this.component,
    required this.eventType,
    required this.previousState,
    required this.newState,
    this.ruleOrErrorCode,
    required this.summary,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'correlationId': correlationId,
    'component': component,
    'eventType': eventType.name,
    'previousState': previousState,
    'newState': newState,
    'ruleOrErrorCode': ruleOrErrorCode,
    'summary': summary,
  };
}
