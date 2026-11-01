import 'package:flutter/material.dart';
import '../../domain/models/request.dart';
import '../theme/tokens.dart';

class SyncBadge extends StatelessWidget {
  final SyncState syncState;

  const SyncBadge({super.key, required this.syncState});

  @override
  Widget build(BuildContext context) {
    final (icon, label, bgColor, fgColor, borderColor) = switch (syncState) {
      SyncState.PENDING_SYNC => (
        Icons.cloud_upload_outlined,
        'Saved on device · Pending sync',
        GharHoldColors.fog,
        GharHoldColors.signalBlue,
        GharHoldColors.signalBlue.withOpacity(0.3),
      ),
      SyncState.SUBMITTED => (
        Icons.check,
        'Submitted',
        GharHoldColors.linenMist,
        GharHoldColors.forestInk,
        Colors.transparent,
      ),
      SyncState.SYNC_FAILED_RETRYABLE => (
        Icons.sync_problem,
        'Sync failed · Retry available',
        GharHoldColors.fog,
        GharHoldColors.signalBlue,
        GharHoldColors.signalBlue.withOpacity(0.4),
      ),
      SyncState.CONFLICT_STALE_DATA => (
        Icons.warning_amber_rounded,
        'Stale conflict · Aborted',
        GharHoldColors.fog,
        GharHoldColors.alarmRed,
        GharHoldColors.alarmRed.withOpacity(0.3),
      ),
      SyncState.RESOLVED_ABORTED => (
        Icons.task_alt,
        'Conflict resolved',
        GharHoldColors.fog,
        GharHoldColors.forestInk,
        GharHoldColors.pebble.withOpacity(0.3),
      ),
    };

    return Semantics(
      label: 'Sync status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: GharHoldRadii.pillRadius,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: fgColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
