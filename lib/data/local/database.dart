import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/models/audit_event.dart';
import '../../domain/models/listing.dart';
import '../../domain/models/request.dart';
import 'tables.dart';

part 'database.g.dart';

LazyDatabase _defaultConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gharhold.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [Listings, Requests, AuditEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _defaultConnection());

  AppDatabase.inMemory() : super(NativeDatabase.memory());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // PRAGMA foreign_keys = ON;
      await customStatement('PRAGMA foreign_keys = ON;');
      // Create the partial unique index using activeRequestStatuses as single source
      await customStatement(buildActiveRequestPartialIndexSql());
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );

  // --- Domain mapping helpers ---

  static PropertyListing listingFromEntity(ListingEntity e) {
    return PropertyListing(
      id: e.id,
      title: e.title,
      neighbourhood: e.neighbourhood,
      bhk: e.bhk,
      monthlyRent: e.monthlyRent,
      depositMonths: e.depositMonths,
      depositAmount: e.depositAmount,
      brokerage: e.brokerage,
      societyCharges: e.societyCharges,
      maintenance: e.maintenance,
      state: e.state,
      version: e.version,
      ownerId: e.ownerId,
    );
  }

  static ListingsCompanion listingToCompanion(PropertyListing l) {
    return ListingsCompanion(
      id: Value(l.id),
      title: Value(l.title),
      neighbourhood: Value(l.neighbourhood),
      bhk: Value(l.bhk),
      monthlyRent: Value(l.monthlyRent),
      depositMonths: Value(l.depositMonths),
      depositAmount: Value(l.depositAmount),
      brokerage: Value(l.brokerage),
      societyCharges: Value(l.societyCharges),
      maintenance: Value(l.maintenance),
      state: Value(l.state),
      version: Value(l.version),
      ownerId: Value(l.ownerId),
    );
  }

  static ViewingRequest requestFromEntity(RequestEntity e) {
    return ViewingRequest(
      id: e.id,
      idempotencyKey: e.idempotencyKey,
      listingId: e.listingId,
      renterId: e.renterId,
      kind: e.kind,
      preferredWindow: e.preferredWindow,
      note: e.note,
      status: e.status,
      syncState: e.syncState,
      clientListingVersion: e.clientListingVersion,
      reopenReason: e.reopenReason,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  static RequestsCompanion requestToCompanion(ViewingRequest r) {
    return RequestsCompanion(
      id: Value(r.id),
      idempotencyKey: Value(r.idempotencyKey),
      listingId: Value(r.listingId),
      renterId: Value(r.renterId),
      kind: Value(r.kind),
      preferredWindow: Value(r.preferredWindow),
      note: Value(r.note),
      status: Value(r.status),
      syncState: Value(r.syncState),
      clientListingVersion: Value(r.clientListingVersion),
      reopenReason: Value(r.reopenReason),
      createdAt: Value(r.createdAt),
      updatedAt: Value(r.updatedAt),
    );
  }

  static AuditEvent auditEventFromEntity(AuditEventEntity e) {
    return AuditEvent(
      timestamp: e.timestamp,
      correlationId: e.correlationId,
      component: e.component,
      eventType: e.eventType,
      previousState: e.previousState,
      newState: e.newState,
      ruleOrErrorCode: e.ruleOrErrorCode,
      summary: e.summary,
    );
  }

  static AuditEventsCompanion auditEventToCompanion(AuditEvent a) {
    return AuditEventsCompanion(
      timestamp: Value(a.timestamp),
      correlationId: Value(a.correlationId),
      component: Value(a.component),
      eventType: Value(a.eventType),
      previousState: Value(a.previousState),
      newState: Value(a.newState),
      ruleOrErrorCode: Value(a.ruleOrErrorCode),
      summary: Value(a.summary),
    );
  }
}
