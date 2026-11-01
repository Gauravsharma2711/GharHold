import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/listing.dart';
import '../theme/tokens.dart';

class CostBreakdownCard extends StatelessWidget {
  final PropertyListing listing;

  const CostBreakdownCard({super.key, required this.listing});

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
    final deposit = listing.calculatedDeposit;
    final brokerage = listing.brokerage;
    final society = listing.societyCharges;
    final maintenance = listing.maintenance;

    var totalKnown = listing.monthlyRent + deposit;
    if (brokerage != null) totalKnown += brokerage;
    if (society != null) totalKnown += society;
    if (maintenance != null) totalKnown += maintenance;

    return Container(
      decoration: BoxDecoration(
        color: GharHoldColors.paper,
        borderRadius: GharHoldRadii.cardRadius,
        border: Border.all(color: GharHoldColors.fog, width: 1.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Move-in Cost Breakdown',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: GharHoldColors.forestInk,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: GharHoldColors.linenMist,
                  borderRadius: GharHoldRadii.pillRadius,
                ),
                child: const Text(
                  'Deterministic',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: GharHoldColors.forestInk,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRow('First Month Rent', _formatINR(listing.monthlyRent)),
          _buildRow(
            'Security Deposit (${listing.depositMonths} months)',
            _formatINR(deposit),
          ),
          if (brokerage != null)
            _buildRow('Brokerage (one-time)', _formatINR(brokerage))
          else
            _buildRow('Brokerage', 'Not specified (omitted)', isMuted: true),
          if (society != null)
            _buildRow('Society / Move-in fee', _formatINR(society))
          else
            _buildRow(
              'Society / Move-in fee',
              'Not specified (omitted)',
              isMuted: true,
            ),
          if (maintenance != null)
            _buildRow('Monthly Maintenance', _formatINR(maintenance))
          else
            _buildRow(
              'Monthly Maintenance',
              'Included or unknown',
              isMuted: true,
            ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: GharHoldColors.fog),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Estimated Initial Outlay',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: GharHoldColors.obsidian,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatINR(totalKnown),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: GharHoldColors.forestInk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: GharHoldColors.fog,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 14, color: GharHoldColors.slate),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Illustrative demo figures. Stamp duty & registration are statutory assumptions. Missing fees are omitted, not assumed zero.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      height: 1.4,
                      color: GharHoldColors.slate,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isMuted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: isMuted
                    ? GharHoldColors.pebble
                    : GharHoldColors.charcoal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: isMuted ? FontWeight.w400 : FontWeight.w600,
              color: isMuted ? GharHoldColors.pebble : GharHoldColors.forestInk,
            ),
          ),
        ],
      ),
    );
  }
}
