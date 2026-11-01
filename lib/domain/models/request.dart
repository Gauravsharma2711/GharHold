/// Domain model for viewing & token requests in GharHold.
/// Pure Dart: zero Flutter, database or network imports.
library;

enum Role { RENTER, OWNER }

enum RequestKind { VIEWING, TOKEN }

enum RequestStatus {
  REQUESTED,
  APPROVED,
  DECLINED,
  REOPENED,
  TOKEN_REQUESTED,
  TOKEN_CONFIRMED,
  ABORTED,
}

enum SyncState {
  PENDING_SYNC,
  SUBMITTED,
  SYNC_FAILED_RETRYABLE,
  CONFLICT_STALE_DATA,
  RESOLVED_ABORTED,
}

/// The authoritative list of statuses considered active for BR-1b and partial uniqueness.
const Set<RequestStatus> activeRequestStatuses = {
  RequestStatus.REQUESTED,
  RequestStatus.APPROVED,
  RequestStatus.REOPENED,
  RequestStatus.TOKEN_REQUESTED,
  RequestStatus.TOKEN_CONFIRMED,
};

class ViewingRequest {
  final String id;
  final String idempotencyKey;
  final String listingId;
  final String renterId;
  final RequestKind kind;
  final String preferredWindow;
  final String note;
  final RequestStatus status;
  final SyncState syncState;
  final int clientListingVersion;
  final String? reopenReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ViewingRequest({
    required this.id,
    required this.idempotencyKey,
    required this.listingId,
    required this.renterId,
    required this.kind,
    required this.preferredWindow,
    required this.note,
    required this.status,
    required this.syncState,
    required this.clientListingVersion,
    this.reopenReason,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => activeRequestStatuses.contains(status);

  ViewingRequest copyWith({
    String? id,
    String? idempotencyKey,
    String? listingId,
    String? renterId,
    RequestKind? kind,
    String? preferredWindow,
    String? note,
    RequestStatus? status,
    SyncState? syncState,
    int? clientListingVersion,
    String? reopenReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ViewingRequest(
      id: id ?? this.id,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      listingId: listingId ?? this.listingId,
      renterId: renterId ?? this.renterId,
      kind: kind ?? this.kind,
      preferredWindow: preferredWindow ?? this.preferredWindow,
      note: note ?? this.note,
      status: status ?? this.status,
      syncState: syncState ?? this.syncState,
      clientListingVersion: clientListingVersion ?? this.clientListingVersion,
      reopenReason: reopenReason ?? this.reopenReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
