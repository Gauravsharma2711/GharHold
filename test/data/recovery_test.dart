import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharhold/data/local/database.dart';
import 'package:gharhold/data/local/database_seeder.dart';
import 'package:gharhold/data/remote/fault_config.dart';
import 'package:gharhold/data/remote/simulated_remote_service.dart';
import 'package:gharhold/data/repository/proptech_repository_impl.dart';
import 'package:gharhold/domain/models/audit_event.dart';
import 'package:gharhold/domain/models/listing.dart';
import 'package:gharhold/domain/models/request.dart';

void main() {
  group('Startup Recovery & File-Backed Restart Tests', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('gharhold_test_db_');
      dbFile = File('${tempDir.path}/test_restart.sqlite');
    });

    tearDown(() async {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'File-backed restart recovers interrupted PENDING_SYNC without auto-sending',
      () async {
        // Phase 1: First app session
        {
          final db1 = AppDatabase(NativeDatabase(dbFile));
          await DatabaseSeeder(db1).seed();

          // Simulate an interrupted request write: request is PENDING_SYNC, listing is VIEWING_REQUESTED
          final now = DateTime.now();
          await db1
              .into(db1.requests)
              .insert(
                RequestsCompanion(
                  id: const drift.Value('req-interrupted-1'),
                  idempotencyKey: const drift.Value('idem-interrupted-1'),
                  listingId: const drift.Value('L2'),
                  renterId: const drift.Value('r1'),
                  kind: const drift.Value(RequestKind.VIEWING),
                  preferredWindow: const drift.Value('Weekend Morning'),
                  note: const drift.Value(
                    'Confidential note: please do not leak my phone 9876543210',
                  ),
                  status: const drift.Value(RequestStatus.REQUESTED),
                  syncState: const drift.Value(SyncState.PENDING_SYNC),
                  clientListingVersion: const drift.Value(1),
                  createdAt: drift.Value(now),
                  updatedAt: drift.Value(now),
                ),
              );

          await (db1.update(
            db1.listings,
          )..where((tbl) => tbl.id.equals('L2'))).write(
            const ListingsCompanion(
              state: drift.Value(ListingState.VIEWING_REQUESTED),
            ),
          );

          // Simulate app crash / force close: database closed without finishing remote sync
          await db1.close();
        }

        // Phase 2: Relaunch app on the same SQLite file
        {
          final db2 = AppDatabase(NativeDatabase(dbFile));
          final faultConfig = FaultConfig(latency: Duration.zero);
          final remoteService = SimulatedRemoteService(config: faultConfig);
          final repository = ProptechRepositoryImpl(
            db: db2,
            remoteService: remoteService,
          );

          // App startup executes recovery scan
          final recovered = await repository.runStartupRecovery();
          expect(recovered, equals(1));

          // Verify request was converted to SYNC_FAILED_RETRYABLE
          final request = await repository
              .watchRequest('req-interrupted-1')
              .first;
          expect(request?.syncState, equals(SyncState.SYNC_FAILED_RETRYABLE));

          // Verify listing remains locked in VIEWING_REQUESTED
          final listing = await repository.getListing('L2');
          expect(listing?.state, equals(ListingState.VIEWING_REQUESTED));

          // Verify RESUME_SCAN audit event was recorded
          final events = await repository.getAuditEvents();
          final resumeEvent = events.firstWhere(
            (e) => e.eventType == AuditEventType.RESUME_SCAN,
          );
          expect(resumeEvent.component, equals('StartupRecovery'));
          expect(resumeEvent.previousState, equals('PENDING_SYNC'));
          expect(resumeEvent.newState, equals('SYNC_FAILED_RETRYABLE'));

          // Privacy check: verify that personal note was NEVER written to audit events
          for (final event in events) {
            expect(
              event.summary.contains('9876543210'),
              isFalse,
              reason: 'Phone number leaked in audit summary',
            );
            expect(
              event.summary.contains('Confidential note'),
              isFalse,
              reason: 'Private note leaked in audit summary',
            );
          }

          // Retry Safely can now be triggered explicitly by user
          final retryResult = await repository.retrySync('req-interrupted-1');
          expect(retryResult.isValid, isTrue);

          final syncedRequest = await repository
              .watchRequest('req-interrupted-1')
              .first;
          expect(syncedRequest?.syncState, equals(SyncState.SUBMITTED));
          expect(syncedRequest?.idempotencyKey, equals('idem-interrupted-1'));

          await db2.close();
        }
      },
    );
  });
}
