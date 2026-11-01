/// Clock port for deterministic time injection.
/// Pure Dart: zero external imports.
library;

abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
