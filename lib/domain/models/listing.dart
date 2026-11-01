/// Domain model for rental property listings in GharHold.
/// Pure Dart: zero Flutter, database or network imports.
library;

enum ListingState { AVAILABLE, VIEWING_REQUESTED, TOKEN_LOCKED, UNAVAILABLE }

class PropertyListing {
  final String id;
  final String title;
  final String neighbourhood;
  final int bhk;
  final int monthlyRent; // Whole INR
  final int depositMonths;
  final int? depositAmount; // Explicit or calculated
  final int? brokerage;
  final int? societyCharges;
  final int? maintenance;
  final ListingState state;
  final int version;
  final String ownerId;

  const PropertyListing({
    required this.id,
    required this.title,
    required this.neighbourhood,
    required this.bhk,
    required this.monthlyRent,
    required this.depositMonths,
    this.depositAmount,
    this.brokerage,
    this.societyCharges,
    this.maintenance,
    required this.state,
    required this.version,
    required this.ownerId,
  });

  int get calculatedDeposit => depositAmount ?? (monthlyRent * depositMonths);

  PropertyListing copyWith({
    String? id,
    String? title,
    String? neighbourhood,
    int? bhk,
    int? monthlyRent,
    int? depositMonths,
    int? depositAmount,
    int? brokerage,
    int? societyCharges,
    int? maintenance,
    ListingState? state,
    int? version,
    String? ownerId,
  }) {
    return PropertyListing(
      id: id ?? this.id,
      title: title ?? this.title,
      neighbourhood: neighbourhood ?? this.neighbourhood,
      bhk: bhk ?? this.bhk,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      depositMonths: depositMonths ?? this.depositMonths,
      depositAmount: depositAmount ?? this.depositAmount,
      brokerage: brokerage ?? this.brokerage,
      societyCharges: societyCharges ?? this.societyCharges,
      maintenance: maintenance ?? this.maintenance,
      state: state ?? this.state,
      version: version ?? this.version,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
