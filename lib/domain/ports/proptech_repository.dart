/// Proptech repository port defining data access and coordinated transactional actions.
/// Pure Dart: zero external imports.
library;

import '../models/audit_event.dart';
import '../models/listing.dart';
import '../models/request.dart';
import '../rules/rules.dart';

abstract interface class ProptechRepository {
  /// Stream of all property listings.
  Stream<List<PropertyListing>> watchListings();

  /// Stream of a single property listing by ID.
  Stream<PropertyListing?> watchListing(String id);

  /// Stream of viewing requests, optionally filtered by renter or owner.
  Stream<List<ViewingRequest>> watchRequests({
    String? renterId,
    String? ownerId,
  });

  /// Stream of a single request by ID.
  Stream<ViewingRequest?> watchRequest(String id);

  /// Stream of diagnostic audit events in chronological order.
  Stream<List<AuditEvent>> watchAuditEvents();

  /// Get current listings snapshot.
  Future<List<PropertyListing>> getListings();

  /// Get a single listing snapshot.
  Future<PropertyListing?> getListing(String id);

  /// Get current requests snapshot.
  Future<List<ViewingRequest>> getRequests({String? renterId, String? ownerId});

  /// Get current audit events snapshot.
  Future<List<AuditEvent>> getAuditEvents();

  /// Submit a new viewing request.
  /// Validates rules, commits locally (REQUESTED/PENDING_SYNC + VIEWING_REQUESTED + audit),
  /// then triggers simulated remote sync.
  Future<ValidationResult> submitViewingRequest({
    required String listingId,
    required String renterId,
    required String preferredWindow,
    String? note,
  });

  /// Retries a sync for a request in SYNC_FAILED_RETRYABLE.
  /// Reuses original idempotencyKey.
  Future<ValidationResult> retrySync(String requestId);

  /// Owner approves viewing request.
  Future<ValidationResult> approveRequest(
    String requestId,
    String actorId, {
    Role actorRole = Role.OWNER,
  });

  /// Owner declines viewing request.
  Future<ValidationResult> declineRequest(
    String requestId,
    String actorId, {
    Role actorRole = Role.OWNER,
  });

  /// Owner reopens declined viewing request with non-empty reason.
  Future<ValidationResult> reopenRequest(
    String requestId,
    String actorId, {
    required String reason,
    Role actorRole = Role.OWNER,
  });

  /// Renter requests token lock after viewing approval.
  Future<ValidationResult> requestToken(
    String requestId,
    String actorId, {
    Role actorRole = Role.RENTER,
  });

  /// Owner confirms token lock, locking listing (TOKEN_LOCKED).
  Future<ValidationResult> confirmToken(
    String requestId,
    String actorId, {
    Role actorRole = Role.OWNER,
  });

  /// Owner marks listing off-market.
  Future<ValidationResult> markOffMarket(
    String listingId,
    String actorId, {
    Role actorRole = Role.OWNER,
  });

  /// Owner relists unavailable listing.
  Future<ValidationResult> relist(
    String listingId,
    String actorId, {
    Role actorRole = Role.OWNER,
  });

  /// Startup recovery scan. Converts any leftover PENDING_SYNC requests to
  /// SYNC_FAILED_RETRYABLE and emits RESUME_SCAN audit event.
  /// Returns the count of recovered requests.
  Future<int> runStartupRecovery();

  /// Resets database to exact 10 seed fixtures and initial state.
  Future<void> resetToSeed();
}
