import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/listing.dart';
import '../theme/tokens.dart';
import 'listing_status_pill.dart';

class ListingCard extends StatelessWidget {
  final PropertyListing listing;
  final VoidCallback onTap;

  const ListingCard({super.key, required this.listing, required this.onTap});

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
    final currencyText = _formatINR(listing.monthlyRent);
    final depositText = listing.depositAmount != null
        ? '${_formatINR(listing.depositAmount!)} deposit'
        : '${listing.depositMonths} mo. deposit';

    return Semantics(
      button: true,
      label:
          '${listing.bhk} BHK flat, ${listing.neighbourhood}, $currencyText per month, ${listing.state.name}, button.',
      child: Material(
        color: GharHoldColors.paper,
        borderRadius: GharHoldRadii.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: GharHoldRadii.cardRadius,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: GharHoldRadii.cardRadius,
              border: Border.all(color: GharHoldColors.fog, width: 1.5),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing.title,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: GharHoldColors.forestInk,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: GharHoldColors.slate,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${listing.neighbourhood} (approx.) · ${listing.bhk} BHK',
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
                    ListingStatusPill(state: listing.state),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: GharHoldColors.fog),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$currencyText /mo',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: GharHoldColors.forestInk,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            depositText,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: GharHoldColors.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          'View Details',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: GharHoldColors.forestInk,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: GharHoldColors.forestInk,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
