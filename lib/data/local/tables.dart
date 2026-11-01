import 'package:drift/drift.dart';

import '../../domain/models/audit_event.dart';
import '../../domain/models/listing.dart';
import '../../domain/models/request.dart';

/// Listings table storing the 10 property fixtures and their authoritative local state.
@DataClassName('ListingEntity')
class Listings extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get neighbourhood => text()();
  IntColumn get bhk => integer()();
  IntColumn get monthlyRent => integer()();
  IntColumn get depositMonths => integer()();
  IntColumn get depositAmount => integer().nullable()();
  IntColumn get brokerage => integer().nullable()();
  IntColumn get societyCharges => integer().nullable()();
  IntColumn get maintenance => integer().nullable()();
  TextColumn get state => textEnum<ListingState>()();
  IntColumn get version => integer()();
  TextColumn get ownerId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Requests table storing viewing & token requests.
/// Has a UNIQUE constraint on idempotency_key and a partial unique index on active requests.
@DataClassName('RequestEntity')
class Requests extends Table {
  TextColumn get id => text()();
  TextColumn get idempotencyKey => text().unique()();
  TextColumn get listingId => text().references(Listings, #id)();
  TextColumn get renterId => text()();
  TextColumn get kind => textEnum<RequestKind>()();
  TextColumn get preferredWindow => text()();
  TextColumn get note => text()();
  TextColumn get status => textEnum<RequestStatus>()();
  TextColumn get syncState => textEnum<SyncState>()();
  IntColumn get clientListingVersion => integer()();
  TextColumn get reopenReason => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Audit events table logging diagnostic, state transition, and fault evidence.
@DataClassName('AuditEventEntity')
class AuditEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get correlationId => text()();
  TextColumn get component => text()();
  TextColumn get eventType => textEnum<AuditEventType>()();
  TextColumn get previousState => text()();
  TextColumn get newState => text()();
  TextColumn get ruleOrErrorCode => text().nullable()();
  TextColumn get summary => text()();
}

/// Helper that builds the SQL for the partial unique index on requests(listing_id)
/// using activeRequestStatuses as the single source of truth.
String buildActiveRequestPartialIndexSql() {
  final activeStatusesSql = activeRequestStatuses
      .map((s) => "'${s.name}'")
      .join(', ');
  return 'CREATE UNIQUE INDEX IF NOT EXISTS one_active_request_per_listing '
      'ON requests(listing_id) WHERE status IN ($activeStatusesSql);';
}
