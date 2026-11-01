import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharhold/data/local/database.dart';
import 'package:gharhold/data/local/tables.dart';
import 'package:gharhold/domain/models/listing.dart';
import 'package:gharhold/domain/models/request.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.inMemory();
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite Database Tests', () {
    test(
      'buildActiveRequestPartialIndexSql uses domain activeRequestStatuses as single source',
      () {
        final sql = buildActiveRequestPartialIndexSql();
        expect(
          sql,
          contains(
            'CREATE UNIQUE INDEX IF NOT EXISTS one_active_request_per_listing',
          ),
        );
        expect(sql, contains('ON requests(listing_id) WHERE status IN'));
        for (final status in activeRequestStatuses) {
          expect(sql, contains("'${status.name}'"));
        }
        expect(sql, isNot(contains("'DECLINED'")));
        expect(sql, isNot(contains("'ABORTED'")));
      },
    );

    test('Insert and query listing works', () async {
      final listing = ListingsCompanion(
        id: const Value('L1'),
        title: const Value('1 BHK Powai Flat'),
        neighbourhood: const Value('Powai'),
        bhk: const Value(1),
        monthlyRent: const Value(35000),
        depositMonths: const Value(2),
        state: const Value(ListingState.AVAILABLE),
        version: const Value(1),
        ownerId: const Value('o1'),
      );

      await db.into(db.listings).insert(listing);

      final fetched = await (db.select(
        db.listings,
      )..where((tbl) => tbl.id.equals('L1'))).getSingle();
      expect(fetched.title, equals('1 BHK Powai Flat'));
      expect(fetched.state, equals(ListingState.AVAILABLE));
      expect(fetched.version, equals(1));
    });

    test(
      'Database partial unique index blocks second active request on same listing',
      () async {
        // 1. Insert listing
        await db
            .into(db.listings)
            .insert(
              const ListingsCompanion(
                id: Value('L1'),
                title: Value('1 BHK Powai'),
                neighbourhood: Value('Powai'),
                bhk: Value(1),
                monthlyRent: Value(35000),
                depositMonths: Value(2),
                state: Value(ListingState.AVAILABLE),
                version: Value(1),
                ownerId: Value('o1'),
              ),
            );

        final now = DateTime.now();

        // 2. Insert first active request (REQUESTED)
        await db
            .into(db.requests)
            .insert(
              RequestsCompanion(
                id: const Value('req-1'),
                idempotencyKey: const Value('idem-1'),
                listingId: const Value('L1'),
                renterId: const Value('r1'),
                kind: const Value(RequestKind.VIEWING),
                preferredWindow: const Value('Weekend Morning'),
                note: const Value('Looking forward'),
                status: const Value(RequestStatus.REQUESTED),
                syncState: const Value(SyncState.SUBMITTED),
                clientListingVersion: const Value(1),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        // 3. Attempt direct insert of second active request on L1 bypassing domain rules
        expect(
          () async => await db
              .into(db.requests)
              .insert(
                RequestsCompanion(
                  id: const Value('req-2'),
                  idempotencyKey: const Value('idem-2'),
                  listingId: const Value('L1'),
                  renterId: const Value('r2'),
                  kind: const Value(RequestKind.VIEWING),
                  preferredWindow: const Value('Weekday Evening'),
                  note: const Value('Second applicant'),
                  status: const Value(RequestStatus.REQUESTED),
                  syncState: const Value(SyncState.PENDING_SYNC),
                  clientListingVersion: const Value(1),
                  createdAt: Value(now),
                  updatedAt: Value(now),
                ),
              ),
          throwsA(isA<SqliteException>()),
          reason:
              'Partial unique index one_active_request_per_listing must reject second active request',
        );
      },
    );

    test(
      'Database allows new active request after previous request becomes DECLINED',
      () async {
        await db
            .into(db.listings)
            .insert(
              const ListingsCompanion(
                id: Value('L1'),
                title: Value('1 BHK Powai'),
                neighbourhood: Value('Powai'),
                bhk: Value(1),
                monthlyRent: Value(35000),
                depositMonths: Value(2),
                state: Value(ListingState.AVAILABLE),
                version: Value(1),
                ownerId: Value('o1'),
              ),
            );

        final now = DateTime.now();

        // First request inserted as DECLINED (inactive)
        await db
            .into(db.requests)
            .insert(
              RequestsCompanion(
                id: const Value('req-1'),
                idempotencyKey: const Value('idem-1'),
                listingId: const Value('L1'),
                renterId: const Value('r1'),
                kind: const Value(RequestKind.VIEWING),
                preferredWindow: const Value('Weekend Morning'),
                note: const Value('Looking forward'),
                status: const Value(RequestStatus.DECLINED),
                syncState: const Value(SyncState.SUBMITTED),
                clientListingVersion: const Value(1),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        // Second request inserted as REQUESTED on same listing succeeds
        await db
            .into(db.requests)
            .insert(
              RequestsCompanion(
                id: const Value('req-2'),
                idempotencyKey: const Value('idem-2'),
                listingId: const Value('L1'),
                renterId: const Value('r2'),
                kind: const Value(RequestKind.VIEWING),
                preferredWindow: const Value('Weekday Evening'),
                note: const Value('Second applicant'),
                status: const Value(RequestStatus.REQUESTED),
                syncState: const Value(SyncState.SUBMITTED),
                clientListingVersion: const Value(1),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        final allRequests = await db.select(db.requests).get();
        expect(allRequests.length, equals(2));
      },
    );

    test('Idempotency key UNIQUE constraint prevents duplicate keys', () async {
      await db
          .into(db.listings)
          .insert(
            const ListingsCompanion(
              id: Value('L1'),
              title: Value('1 BHK Powai'),
              neighbourhood: Value('Powai'),
              bhk: Value(1),
              monthlyRent: Value(35000),
              depositMonths: Value(2),
              state: Value(ListingState.AVAILABLE),
              version: Value(1),
              ownerId: Value('o1'),
            ),
          );
      await db
          .into(db.listings)
          .insert(
            const ListingsCompanion(
              id: Value('L2'),
              title: Value('2 BHK Powai'),
              neighbourhood: Value('Powai'),
              bhk: Value(2),
              monthlyRent: Value(55000),
              depositMonths: Value(2),
              state: Value(ListingState.AVAILABLE),
              version: Value(1),
              ownerId: Value('o1'),
            ),
          );

      final now = DateTime.now();

      await db
          .into(db.requests)
          .insert(
            RequestsCompanion(
              id: const Value('req-1'),
              idempotencyKey: const Value('same-idem-key'),
              listingId: const Value('L1'),
              renterId: const Value('r1'),
              kind: const Value(RequestKind.VIEWING),
              preferredWindow: const Value('Weekend Morning'),
              note: const Value('First'),
              status: const Value(RequestStatus.DECLINED),
              syncState: const Value(SyncState.SUBMITTED),
              clientListingVersion: const Value(1),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      expect(
        () async => await db
            .into(db.requests)
            .insert(
              RequestsCompanion(
                id: const Value('req-2'),
                idempotencyKey: const Value('same-idem-key'),
                listingId: const Value('L2'),
                renterId: const Value('r2'),
                kind: const Value(RequestKind.VIEWING),
                preferredWindow: const Value('Weekday Evening'),
                note: const Value('Second with same key'),
                status: const Value(RequestStatus.REQUESTED),
                syncState: const Value(SyncState.SUBMITTED),
                clientListingVersion: const Value(1),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('Transaction rollback ensures all-or-nothing consistency', () async {
      await db
          .into(db.listings)
          .insert(
            const ListingsCompanion(
              id: Value('L1'),
              title: Value('1 BHK Powai'),
              neighbourhood: Value('Powai'),
              bhk: Value(1),
              monthlyRent: Value(35000),
              depositMonths: Value(2),
              state: Value(ListingState.AVAILABLE),
              version: Value(1),
              ownerId: Value('o1'),
            ),
          );

      final now = DateTime.now();

      try {
        await db.transaction(() async {
          // 1. Update listing state to VIEWING_REQUESTED
          await (db.update(
            db.listings,
          )..where((tbl) => tbl.id.equals('L1'))).write(
            const ListingsCompanion(
              state: Value(ListingState.VIEWING_REQUESTED),
            ),
          );

          // 2. Insert valid request
          await db
              .into(db.requests)
              .insert(
                RequestsCompanion(
                  id: const Value('req-1'),
                  idempotencyKey: const Value('idem-1'),
                  listingId: const Value('L1'),
                  renterId: const Value('r1'),
                  kind: const Value(RequestKind.VIEWING),
                  preferredWindow: const Value('Weekend Morning'),
                  note: const Value('Valid'),
                  status: const Value(RequestStatus.REQUESTED),
                  syncState: const Value(SyncState.PENDING_SYNC),
                  clientListingVersion: const Value(1),
                  createdAt: Value(now),
                  updatedAt: Value(now),
                ),
              );

          // 3. Simulate failure in transaction
          throw Exception('Simulated transaction failure');
        });
      } catch (e) {
        // Expected
      }

      // Verify that listing is still AVAILABLE and no request exists
      final listing = await (db.select(
        db.listings,
      )..where((tbl) => tbl.id.equals('L1'))).getSingle();
      expect(listing.state, equals(ListingState.AVAILABLE));

      final requests = await db.select(db.requests).get();
      expect(requests, isEmpty);
    });
  });
}
