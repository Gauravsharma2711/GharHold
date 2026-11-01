/// Deterministic move-in cost breakdown.
/// Pure Dart: zero Flutter, database or network imports.
library;

class CostBreakdown {
  final int monthlyRent;
  final int securityDeposit;
  final int? brokerage;
  final int? societyCharges;
  final int? maintenance;
  final int? estimatedStampDutyAndRegistration;
  final bool includesIllustrativeStatutoryAssumption;

  const CostBreakdown({
    required this.monthlyRent,
    required this.securityDeposit,
    this.brokerage,
    this.societyCharges,
    this.maintenance,
    this.estimatedStampDutyAndRegistration,
    this.includesIllustrativeStatutoryAssumption = false,
  });

  int get totalKnownMoveIn {
    var total = monthlyRent + securityDeposit;
    if (brokerage != null) total += brokerage!;
    if (societyCharges != null) total += societyCharges!;
    if (maintenance != null) total += maintenance!;
    if (estimatedStampDutyAndRegistration != null) {
      total += estimatedStampDutyAndRegistration!;
    }
    return total;
  }
}
