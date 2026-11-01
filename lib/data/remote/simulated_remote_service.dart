import '../../domain/models/listing.dart';
import '../../domain/models/request.dart';
import '../../domain/ports/remote_service.dart';
import '../fixtures/seed_listings.dart';
import 'fault_config.dart';

/// Simulated remote service providing controlled server emulation and fault injection.
/// Note: Clearly disclosed in UI as SIMULATION. No network or hosted server is used.
class SimulatedRemoteService implements RemoteService {
  final FaultConfig config;
  final Map<String, PropertyListing> _serverListings = {};

  SimulatedRemoteService({
    FaultConfig? config,
    List<PropertyListing>? initialListings,
  }) : config = config ?? FaultConfig() {
    resetServerState(initialListings);
  }

  /// Resets simulated server listings to initial state.
  void resetServerState([List<PropertyListing>? listings]) {
    _serverListings.clear();
    final seeds = listings ?? createSeedListings();
    for (final l in seeds) {
      _serverListings[l.id] = l;
    }
  }

  PropertyListing? getServerListing(String id) => _serverListings[id];

  @override
  Future<void> submitViewingRequest(
    ViewingRequest request,
    int clientListingVersion,
  ) async {
    // 1. Simulate network latency
    if (config.latency > Duration.zero) {
      await Future<void>.delayed(config.latency);
    }

    // 2. Check for network drop fault
    if (config.isNetworkDrop) {
      throw const NetworkException(
        'Simulated network drop: connection unreachable',
      );
    }

    // 3. Check for stale conflict fault (one-shot)
    if (config.isStaleConflict) {
      // Revert fault to normal (one-shot)
      config.setNormal();

      final current =
          _serverListings[request.listingId] ??
          PropertyListing(
            id: request.listingId,
            title: 'Unknown',
            neighbourhood: 'Unknown',
            bhk: 1,
            monthlyRent: 30000,
            depositMonths: 2,
            state: ListingState.UNAVAILABLE,
            version: 2,
            ownerId: 'o1',
          );

      // Server changes listing to UNAVAILABLE at version 2
      final conflictListing = current.copyWith(
        state: ListingState.UNAVAILABLE,
        version: current.version + 1,
      );
      _serverListings[request.listingId] = conflictListing;

      throw StaleVersionConflict(
        authoritativeListing: conflictListing,
        clientVersion: clientListingVersion,
        serverVersion: conflictListing.version,
      );
    }

    // 4. Normal optimistic concurrency check
    final serverListing = _serverListings[request.listingId];
    if (serverListing != null &&
        clientListingVersion != serverListing.version) {
      throw StaleVersionConflict(
        authoritativeListing: serverListing,
        clientVersion: clientListingVersion,
        serverVersion: serverListing.version,
      );
    }

    // 5. Update server listing state on acceptance
    if (serverListing != null) {
      _serverListings[request.listingId] = serverListing.copyWith(
        state: ListingState.VIEWING_REQUESTED,
      );
    }
  }
}
