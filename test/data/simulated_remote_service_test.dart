import 'package:flutter_test/flutter_test.dart';
import 'package:gharhold/data/remote/fault_config.dart';
import 'package:gharhold/data/remote/simulated_remote_service.dart';
import 'package:gharhold/domain/models/listing.dart';
import 'package:gharhold/domain/models/request.dart';
import 'package:gharhold/domain/ports/remote_service.dart';

void main() {
  group('SimulatedRemoteService & Fault Injection Tests', () {
    late FaultConfig config;
    late SimulatedRemoteService service;

    final dummyRequest = ViewingRequest(
      id: 'req-1',
      idempotencyKey: 'idem-1',
      listingId: 'L1',
      renterId: 'r1',
      kind: RequestKind.VIEWING,
      preferredWindow: 'Weekend Morning',
      note: 'Hello',
      status: RequestStatus.REQUESTED,
      syncState: SyncState.PENDING_SYNC,
      clientListingVersion: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setUp(() {
      config = FaultConfig(latency: Duration.zero);
      service = SimulatedRemoteService(config: config);
    });

    test('Normal mode succeeds when versions match', () async {
      await expectLater(
        service.submitViewingRequest(dummyRequest, 1),
        completes,
      );

      final updated = service.getServerListing('L1');
      expect(updated?.state, equals(ListingState.VIEWING_REQUESTED));
    });

    test(
      'Normal mode throws StaleVersionConflict when client version is outdated',
      () async {
        expect(
          () => service.submitViewingRequest(dummyRequest, 0),
          throwsA(isA<StaleVersionConflict>()),
        );
      },
    );

    test('Network drop fault throws NetworkException', () async {
      config.setDropNetwork();
      expect(config.isNetworkDrop, isTrue);

      expect(
        () => service.submitViewingRequest(dummyRequest, 1),
        throwsA(isA<NetworkException>()),
      );

      // Fault stays set until changed
      expect(config.isNetworkDrop, isTrue);
    });

    test(
      'Stale conflict fault is one-shot and returns UNAVAILABLE v2',
      () async {
        config.setStaleConflict();
        expect(config.isStaleConflict, isTrue);

        try {
          await service.submitViewingRequest(dummyRequest, 1);
          fail('Should have thrown StaleVersionConflict');
        } on StaleVersionConflict catch (e) {
          expect(e.clientVersion, equals(1));
          expect(e.serverVersion, equals(2));
          expect(
            e.authoritativeListing.state,
            equals(ListingState.UNAVAILABLE),
          );
          expect(e.authoritativeListing.version, equals(2));
        }

        // One-shot check: fault must revert to normal after triggering
        expect(config.mode, equals(FaultMode.normal));
      },
    );
  });
}
