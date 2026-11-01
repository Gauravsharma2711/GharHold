import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/listing.dart';
import '../../domain/models/request.dart';
import '../theme/tokens.dart';
import 'listing_status_pill.dart';
import 'sync_badge.dart';

class RequestCard extends StatelessWidget {
  final ViewingRequest request;
  final PropertyListing? listing;
  final VoidCallback onTap;
  final Widget? trailingAction;

  const RequestCard({
    super.key,
    required this.request,
    this.listing,
    required this.onTap,
    this.trailingAction,
  });

  @override
  Widget build(BuildContext context) {
    final title = listing?.title ?? 'Listing ${request.listingId}';
    final neighbourhood = listing?.neighbourhood ?? 'Mumbai';
    final timeStr = DateFormat('dd MMM, hh:mm a').format(request.updatedAt);

    return Material(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: GharHoldColors.forestInk,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$neighbourhood · Renter: ${request.renterId}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: GharHoldColors.slate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RequestStatusPill(status: request.status),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: GharHoldColors.fog,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: GharHoldColors.forestInk,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Window: ${request.preferredWindow}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: GharHoldColors.charcoal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (request.note.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Note: "${request.note}"',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: GharHoldColors.slate,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (request.reopenReason != null &&
                  request.reopenReason!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: GharHoldColors.linenMist,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info,
                        size: 14,
                        color: GharHoldColors.forestInk,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Reopen reason: ${request.reopenReason}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: GharHoldColors.forestInk,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              const Divider(height: 1, color: GharHoldColors.fog),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SyncBadge(syncState: request.syncState),
                  Text(
                    timeStr,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: GharHoldColors.pebble,
                    ),
                  ),
                ],
              ),
              if (trailingAction != null) ...[
                const SizedBox(height: 10),
                trailingAction!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
