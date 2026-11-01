import 'package:drift/drift.dart';

import '../../domain/models/audit_event.dart';
import '../fixtures/seed_listings.dart';
import 'database.dart';

class DatabaseSeeder {
  final AppDatabase db;

  const DatabaseSeeder(this.db);

  /// Seeds the database idempotently.
  /// If [reset] is true, deletes all existing rows and reseeds.
  Future<void> seed({bool reset = false}) async {
    await db.transaction(() async {
      if (reset) {
        await db.delete(db.requests).go();
        await db.delete(db.listings).go();
        await db.delete(db.auditEvents).go();
      } else {
        final existingCount = await (db.selectOnly(
          db.listings,
        )..addColumns([db.listings.id.count()])).getSingle();
        final count = existingCount.read(db.listings.id.count()) ?? 0;
        if (count > 0) {
          // Already seeded
          return;
        }
      }

      // Seed listings
      final listings = createSeedListings();
      for (final l in listings) {
        await db.into(db.listings).insert(AppDatabase.listingToCompanion(l));
      }

      // Seed requests (L5 active request for r2)
      final requests = createSeedRequests();
      for (final r in requests) {
        await db.into(db.requests).insert(AppDatabase.requestToCompanion(r));
      }

      // Seed audit event
      final now = DateTime.now();
      await db
          .into(db.auditEvents)
          .insert(
            AuditEventsCompanion(
              timestamp: Value(now),
              correlationId: const Value('seed-init'),
              component: const Value('DatabaseSeeder'),
              eventType: const Value(AuditEventType.DATA_RESET),
              previousState: Value(reset ? 'PREVIOUS_STATE' : 'EMPTY'),
              newState: const Value('SEEDED'),
              ruleOrErrorCode: const Value(null),
              summary: Value(
                reset
                    ? 'Database reset: reseeded 10 fixtures and L5 active request.'
                    : 'Initial seed: loaded 10 listings and L5 active request.',
              ),
            ),
          );
    });
  }
}
