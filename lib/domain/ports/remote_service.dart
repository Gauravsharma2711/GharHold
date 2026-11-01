/// Remote service port and domain exceptions/results for simulated sync.
/// Pure Dart: zero external imports.
library;

import '../models/listing.dart';
import '../models/request.dart';

/// Exception thrown by the remote service when a network drop fault is active.
class NetworkException implements Exception {
  final String message;
  const NetworkException([
    this.message = 'Simulated network drop: connection unreachable',
  ]);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when the remote server has an optimistic version conflict.
class StaleVersionConflict implements Exception {
  final PropertyListing authoritativeListing;
  final int clientVersion;
  final int serverVersion;

  const StaleVersionConflict({
    required this.authoritativeListing,
    required this.clientVersion,
    required this.serverVersion,
  });

  @override
  String toString() =>
      'StaleVersionConflict: Client version $clientVersion conflicts with server version $serverVersion';
}

/// Port defining the contract for synchronizing viewing/token requests to remote service.
abstract interface class RemoteService {
  /// Submit a request to the remote service against a specific listing version.
  /// Throws [NetworkException] on drop-network fault.
  /// Throws [StaleVersionConflict] on optimistic concurrency conflict.
  Future<void> submitViewingRequest(
    ViewingRequest request,
    int clientListingVersion,
  );
}
