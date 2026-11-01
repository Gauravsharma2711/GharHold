import 'package:flutter/material.dart';
import '../../domain/models/listing.dart';
import '../../domain/models/request.dart';
import '../theme/tokens.dart';

class ListingStatusPill extends StatelessWidget {
  final ListingState state;

  const ListingStatusPill({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final (icon, label, bgColor, fgColor, borderColor) = switch (state) {
      ListingState.AVAILABLE => (
        Icons.check_circle_outline,
        'Available',
        GharHoldColors.linenMist,
        GharHoldColors.forestInk,
        Colors.transparent,
      ),
      ListingState.VIEWING_REQUESTED => (
        Icons.schedule,
        'Viewing Requested',
        GharHoldColors.fog,
        GharHoldColors.signalBlue,
        GharHoldColors.signalBlue.withOpacity(0.3),
      ),
      ListingState.TOKEN_LOCKED => (
        Icons.lock_outline,
        'Token Locked',
        GharHoldColors.forestInk,
        GharHoldColors.paper,
        Colors.transparent,
      ),
      ListingState.UNAVAILABLE => (
        Icons.block,
        'Unavailable',
        GharHoldColors.fog,
        GharHoldColors.alarmRed,
        GharHoldColors.alarmRed.withOpacity(0.3),
      ),
    };

    return Semantics(
      label: 'Listing status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: GharHoldRadii.pillRadius,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: fgColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
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

class RequestStatusPill extends StatelessWidget {
  final RequestStatus status;

  const RequestStatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (icon, label, bgColor, fgColor, borderColor) = switch (status) {
      RequestStatus.REQUESTED => (
        Icons.schedule,
        'Requested',
        GharHoldColors.fog,
        GharHoldColors.signalBlue,
        GharHoldColors.signalBlue.withOpacity(0.3),
      ),
      RequestStatus.APPROVED => (
        Icons.check_circle,
        'Approved',
        GharHoldColors.linenMist,
        GharHoldColors.forestInk,
        Colors.transparent,
      ),
      RequestStatus.DECLINED => (
        Icons.cancel_outlined,
        'Declined',
        GharHoldColors.fog,
        GharHoldColors.alarmRed,
        GharHoldColors.alarmRed.withOpacity(0.3),
      ),
      RequestStatus.REOPENED => (
        Icons.replay,
        'Reopened',
        GharHoldColors.linenMist,
        GharHoldColors.spruce,
        Colors.transparent,
      ),
      RequestStatus.TOKEN_REQUESTED => (
        Icons.key,
        'Token Requested',
        GharHoldColors.fog,
        GharHoldColors.signalBlue,
        GharHoldColors.signalBlue.withOpacity(0.3),
      ),
      RequestStatus.TOKEN_CONFIRMED => (
        Icons.lock,
        'Token Confirmed',
        GharHoldColors.forestInk,
        GharHoldColors.paper,
        Colors.transparent,
      ),
      RequestStatus.ABORTED => (
        Icons.error_outline,
        'Aborted',
        GharHoldColors.fog,
        GharHoldColors.alarmRed,
        GharHoldColors.alarmRed.withOpacity(0.4),
      ),
    };

    return Semantics(
      label: 'Request status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: GharHoldRadii.pillRadius,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: fgColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
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
