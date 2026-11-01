/// Unique ID and idempotency key generation port.
/// Pure Dart: zero external imports.
library;

abstract interface class IdGenerator {
  String nextId({String prefix});
  String nextCorrelationId();
  String nextIdempotencyKey();
}

class StandardIdGenerator implements IdGenerator {
  int _counter = 1;

  @override
  String nextId({String prefix = 'req'}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final count = _counter++;
    return '$prefix-$timestamp-$count';
  }

  @override
  String nextCorrelationId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final count = _counter++;
    return 'corr-$timestamp-$count';
  }

  @override
  String nextIdempotencyKey() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final count = _counter++;
    return 'idem-$timestamp-$count';
  }
}

