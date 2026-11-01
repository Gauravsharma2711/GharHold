import 'package:flutter/material.dart';
import '../../data/preview_state.dart';
import '../../domain/models/request.dart';
import '../../domain/rules/rules.dart';
import '../theme/tokens.dart';
import '../widgets/outlined_pill_button.dart';
import '../widgets/primary_pill_button.dart';
import '../widgets/request_card.dart';
import '../widgets/request_timeline.dart';
import '../widgets/state_views.dart';

class GH05OwnerInboxScreen extends StatefulWidget {
  final GharHoldPreviewState state;

  const GH05OwnerInboxScreen({super.key, required this.state});

  @override
  State<GH05OwnerInboxScreen> createState() => _GH05OwnerInboxScreenState();
}

class _GH05OwnerInboxScreenState extends State<GH05OwnerInboxScreen> {
  String? _selectedRequestId;

  void _showReopenDialog(ViewingRequest req) {
    final controller = TextEditingController();
    String? localError;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: GharHoldColors.paper,
              shape: RoundedRectangleBorder(
                borderRadius: GharHoldRadii.cardRadius,
              ),
              title: const Text(
                'Reopen Declined Request',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  color: GharHoldColors.forestInk,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invariant BR-2 requires an explicit, non-empty reason to reopen a previously declined viewing slot.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: GharHoldColors.slate,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText:
                          'e.g. Schedule conflict resolved, flat is available.',
                      errorText: localError,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: GharHoldColors.slate),
                  ),
                ),
                PrimaryPillButton(
                  label: 'Reopen Slot',
                  onPressed: () {
                    final reason = controller.text.trim();
                    if (reason.isEmpty) {
                      setDialogState(() {
                        localError = 'Reopen reason cannot be empty (BR-2).';
                      });
                      return;
                    }
                    final res = widget.state.ownerReopen(req.id, reason);
                    if (res is Rejected) {
                      setDialogState(() {
                        localError = '[${res.ruleCode}] ${res.userMessage}';
                      });
                    } else {
                      Navigator.of(dialogCtx).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeclineConfirmDialog(ViewingRequest req) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: GharHoldColors.paper,
          shape: RoundedRectangleBorder(borderRadius: GharHoldRadii.cardRadius),
          title: const Text(
            'Confirm Decline',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: GharHoldColors.alarmRed,
            ),
          ),
          content: const Text(
            'Declining will release this viewing hold and return the flat to AVAILABLE status. To approve later, it must be explicitly reopened with a reason.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: GharHoldColors.charcoal,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: GharHoldColors.slate),
              ),
            ),
            OutlinedPillButton(
              label: 'Decline Hold',
              borderColor: GharHoldColors.alarmRed,
              textColor: GharHoldColors.alarmRed,
              onPressed: () {
                widget.state.ownerDecline(req.id);
                Navigator.of(dialogCtx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final requests = widget.state.ownerRequests;

    return Scaffold(
      backgroundColor: GharHoldColors.paper,
      body: requests.isEmpty
          ? const GharHoldEmptyView(
              icon: Icons.inbox_outlined,
              title: 'Owner Inbox Empty',
              message:
                  'No viewing or token requests have been received for your listings.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Owner & Society Inbox',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: GharHoldColors.forestInk,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'One holder at a time. Review and respond to requests.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: GharHoldColors.slate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: GharHoldColors.linenMist,
                        borderRadius: GharHoldRadii.pillRadius,
                      ),
                      child: const Text(
                        'Owner o1',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: GharHoldColors.forestInk,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...requests.map((req) {
                  final listing = widget.state.getListingById(req.listingId);
                  final isExpanded = _selectedRequestId == req.id;
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
                              const SizedBox(height: 6),
                              // Owner Action Buttons
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  // Approve (if REQUESTED or REOPENED)
                                  if (req.status == RequestStatus.REQUESTED ||
                                      req.status == RequestStatus.REOPENED)
                                    PrimaryPillButton(
                                      label: 'Approve Viewing',
                                      icon: Icons.check,
                                      onPressed: () {
                                        final res = widget.state.ownerApprove(
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
                                  // Decline (if REQUESTED, APPROVED, REOPENED)
                                  if (req.status == RequestStatus.REQUESTED ||
                                      req.status == RequestStatus.APPROVED ||
                                      req.status == RequestStatus.REOPENED)
                                    OutlinedPillButton(
                                      label: 'Decline',
                                      icon: Icons.close,
                                      borderColor: GharHoldColors.alarmRed,
                                      textColor: GharHoldColors.alarmRed,
                                      onPressed: () =>
                                          _showDeclineConfirmDialog(req),
                                    ),
                                  // Reopen (only if DECLINED)
                                  if (req.status == RequestStatus.DECLINED)
                                    OutlinedPillButton(
                                      label: 'Reopen with Reason',
                                      icon: Icons.replay,
                                      onPressed: () => _showReopenDialog(req),
                                    ),
                                  // Confirm Token (if TOKEN_REQUESTED)
                                  if (req.status ==
                                      RequestStatus.TOKEN_REQUESTED)
                                    PrimaryPillButton(
                                      label: 'Confirm Token (Lock Listing)',
                                      icon: Icons.lock,
                                      onPressed: () {
                                        final res = widget.state
                                            .ownerConfirmToken(req.id);
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
                              const SizedBox(height: 8),
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
                                          ? 'Hide Audit Log'
                                          : 'View Audit Log',
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
