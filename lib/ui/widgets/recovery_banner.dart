import 'package:flutter/material.dart';
import '../../domain/models/request.dart';
import '../theme/tokens.dart';
import 'primary_pill_button.dart';

class RecoveryBanner extends StatelessWidget {
  final SyncState syncState;
  final VoidCallback onRetry;
  final VoidCallback? onDismissConflict;

  const RecoveryBanner({
    super.key,
    required this.syncState,
    required this.onRetry,
    this.onDismissConflict,
  });

  @override
  Widget build(BuildContext context) {
    if (syncState == SyncState.SYNC_FAILED_RETRYABLE) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: GharHoldColors.linenMist,
          borderRadius: GharHoldRadii.cardRadius,
          border: Border.all(color: GharHoldColors.forestInk.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 18,
                  color: GharHoldColors.forestInk,
                ),
                SizedBox(width: 8),
                Text(
                  'Saved locally · Network submission failed',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: GharHoldColors.forestInk,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Your request is safely held in local device storage. The owner has not received it yet. Retrying will safely reuse your unique request key without duplicate bookings.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                height: 1.4,
                color: GharHoldColors.charcoal,
              ),
            ),
            const SizedBox(height: 10),
            PrimaryPillButton(
              label: 'Retry Safely ↻',
              icon: Icons.refresh,
              onPressed: onRetry,
            ),
          ],
        ),
      );
    }

    if (syncState == SyncState.CONFLICT_STALE_DATA) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: GharHoldColors.fog,
          borderRadius: GharHoldRadii.cardRadius,
          border: Border.all(color: GharHoldColors.alarmRed.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: GharHoldColors.alarmRed,
                ),
                SizedBox(width: 8),
                Text(
                  'Stale Conflict Detected',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: GharHoldColors.alarmRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'The listing was modified by the owner or locked by another renter while you were submitting. Your request was aborted to prevent double-booking, and local truth has been refreshed.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                height: 1.4,
                color: GharHoldColors.charcoal,
              ),
            ),
            if (onDismissConflict != null) ...[
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: onDismissConflict,
                style: OutlinedButton.styleFrom(
                  foregroundColor: GharHoldColors.forestInk,
                  side: const BorderSide(color: GharHoldColors.forestInk),
                  shape: const RoundedRectangleBorder(
                    borderRadius: GharHoldRadii.pillRadius,
                  ),
                ),
                child: const Text(
                  'Acknowledge & Refresh Truth',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
