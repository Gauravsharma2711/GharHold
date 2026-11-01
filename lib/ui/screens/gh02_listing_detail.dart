import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/preview_state.dart';
import '../../domain/models/listing.dart';
import '../theme/tokens.dart';
import '../widgets/cost_breakdown_card.dart';
import '../widgets/listing_status_pill.dart';
import '../widgets/primary_pill_button.dart';

class GH02ListingDetailScreen extends StatelessWidget {
  final PropertyListing listing;
  final GharHoldPreviewState state;
  final VoidCallback onRequestViewing;
  final VoidCallback onBack;

  const GH02ListingDetailScreen({
    super.key,
    required this.listing,
    required this.state,
    required this.onRequestViewing,
    required this.onBack,
  });

  String _formatINR(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Re-fetch current listing state from preview state in case it updated
    final currentListing = state.getListingById(listing.id) ?? listing;
    final isAvailable = currentListing.state == ListingState.AVAILABLE;
    final activeRequest = state.getActiveRequestForListing(currentListing.id);

    return Scaffold(
      backgroundColor: GharHoldColors.paper,
      appBar: AppBar(
        title: const Text('Listing Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Feed',
          onPressed: onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Title & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentListing.title,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: GharHoldColors.forestInk,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: GharHoldColors.slate,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${currentListing.neighbourhood} (approx.) · ${currentListing.bhk} BHK',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: GharHoldColors.slate,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListingStatusPill(state: currentListing.state),
              ],
            ),
            const SizedBox(height: 16),
            // Rent banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GharHoldColors.linenMist,
                borderRadius: GharHoldRadii.cardRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monthly Rent',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: GharHoldColors.forestInk,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatINR(currentListing.monthlyRent),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: GharHoldColors.forestInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Security Deposit',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: GharHoldColors.forestInk,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatINR(currentListing.calculatedDeposit),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: GharHoldColors.forestInk,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Move-in Cost breakdown
            CostBreakdownCard(listing: currentListing),
            const SizedBox(height: 16),
            // Privacy notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GharHoldColors.fog,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: GharHoldColors.forestInk,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Exact address is withheld to prevent ghost visits. Coordination happens strictly through confirmed viewings.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: GharHoldColors.slate,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Request Action Section
            if (isAvailable) ...[
              SizedBox(
                width: double.infinity,
                child: PrimaryPillButton(
                  label: 'Request Viewing',
                  icon: Icons.calendar_month,
                  onPressed: onRequestViewing,
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Holding a viewing slot locks the listing until owner decides.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: GharHoldColors.slate,
                  ),
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: GharHoldColors.fog,
                  borderRadius: GharHoldRadii.cardRadius,
                  border: Border.all(
                    color: GharHoldColors.pebble.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lock_clock,
                          size: 18,
                          color: GharHoldColors.forestInk,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentListing.state == ListingState.VIEWING_REQUESTED
                              ? 'Viewing Already Requested'
                              : currentListing.state ==
                                    ListingState.TOKEN_LOCKED
                              ? 'Listing Token Locked'
                              : 'Listing Off-Market',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: GharHoldColors.forestInk,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentListing.state == ListingState.VIEWING_REQUESTED
                          ? 'This listing is held by an active request. Invariant BR-1b permits at most one active viewing request at a time.'
                          : currentListing.state == ListingState.TOKEN_LOCKED
                          ? 'A token hold has been confirmed for this flat. New requests cannot be accepted (BR-1).'
                          : 'This flat is currently marked unavailable by the owner (BR-1).',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        height: 1.4,
                        color: GharHoldColors.charcoal,
                      ),
                    ),
                    if (activeRequest != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Active Request ID: ${activeRequest.id} (Renter: ${activeRequest.renterId})',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: GharHoldColors.slate,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
