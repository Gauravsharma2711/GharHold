/// In-memory fault injection configuration for SimulatedRemoteService.
/// Reset to Normal on application launch.
library;

enum FaultMode { normal, dropNetwork, staleConflict }

class FaultConfig {
  FaultMode mode;
  Duration latency;

  FaultConfig({
    this.mode = FaultMode.normal,
    this.latency = const Duration(milliseconds: 500),
  });

  bool get isNetworkDrop => mode == FaultMode.dropNetwork;
  bool get isStaleConflict => mode == FaultMode.staleConflict;

  void setNormal() => mode = FaultMode.normal;
  void setDropNetwork() => mode = FaultMode.dropNetwork;
  void setStaleConflict() => mode = FaultMode.staleConflict;
}
