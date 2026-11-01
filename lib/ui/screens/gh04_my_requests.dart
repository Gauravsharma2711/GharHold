import 'package:flutter/material.dart';
import '../../data/preview_state.dart';
import '../../domain/models/request.dart';
import '../../domain/rules/rules.dart';
import '../theme/tokens.dart';
import '../widgets/primary_pill_button.dart';
import '../widgets/recovery_banner.dart';
import '../widgets/request_card.dart';
import '../widgets/request_timeline.dart';
import '../widgets/state_views.dart';

class GH04MyRequestsScreen extends StatefulWidget {
  final GharHoldPreviewState state;
  final VoidCallback onExploreFeed;

  const GH04MyRequestsScreen({
    super.key,
    required this.state,
    required this.onExploreFeed,
  });

  @override
  State<GH04MyRequestsScreen> createState() => _GH04MyRequestsScreenState();
}

class _GH04MyRequestsScreenState extends State<GH04MyRequestsScreen> {
  String? _selectedRequestId;

  @override
  Widget build(BuildContext context) {
    final requests = widget.state.renterRequests;

    return Scaffold(
      backgroundColor: GharHoldColors.paper,
      body: requests.isEmpty
          ? GharHoldEmptyView(
              icon: Icons.assignment_outlined,
              title: 'No Viewing Requests',
              message:
                  'You haven\'t made any viewing or token hold requests yet. Explore available Mumbai rentals to request one.',
              actionLabel: 'Explore Listings',
              onAction: widget.onExploreFeed,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                const Text(
                  'My Rental Requests',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: GharHoldColors.forestInk,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Track the lifecycle of your viewing slots and token holds.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: GharHoldColors.slate,
                  ),
                ),
                const SizedBox(height: 16),
                ...requests.map((req) {
                  final listing = widget.state.getListingById(req.listingId);
                  final isExpanded = _selectedRequestId == req.id;

                  // Audit events relevant to this request or listing
                  final relatedEvents = widget.state.auditEvents.where((e) {
                    return e.summary.contains(req.id) ||
                        e.summary.contains(req.listingId) ||
                        (listing != null && e.summary.contains(listing.title));
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recovery banner for retryable failure or stale conflict
                        if (req.syncState == SyncState.SYNC_FAILED_RETRYABLE ||
                            req.syncState == SyncState.CONFLICT_STALE_DATA)
                          RecoveryBanner(
                            syncState: req.syncState,
                            onRetry: () => widget.state.retryRequest(req.id),
                            onDismissConflict: () =>
                                widget.state.resolveConflict(req.id),
                          ),
                        RequestCard(
                          request: req,
                          listing: listing,
                          onTap: () {
                            setState(() {
                              _selectedRequestId = isExpanded ? null : req.id;
                            });
                          },
                          trailingAction: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Token Hold action if approved
                              if (req.status == RequestStatus.APPROVED) ...[
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: GharHoldColors.linenMist,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            size: 16,
                                            color: GharHoldColors.forestInk,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            'Viewing Approved by Owner',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: GharHoldColors.forestInk,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'You may now request a token hold marker. Note: Token is a workflow lock, not a money payment.',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          color: GharHoldColors.charcoal,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      PrimaryPillButton(
                                        label:
                                            'Hold with Token (Workflow Hold)',
                                        icon: Icons.lock_outline,
                                        onPressed: () {
                                          final res = widget.state.requestToken(
                                            req.id,
                                          );
                                          if (res is Rejected) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(res.userMessage),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _selectedRequestId = isExpanded
                                            ? null
                                            : req.id;
                                      });
                                    },
                                    icon: Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      size: 16,
                                      color: GharHoldColors.forestInk,
                                    ),
                                    label: Text(
                                      isExpanded
                                          ? 'Hide Timeline'
                                          : 'View Audit Timeline',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: GharHoldColors.forestInk,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Expanded Timeline
                        if (isExpanded) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: RequestTimeline(events: relatedEvents),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
