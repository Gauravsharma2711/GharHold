import 'package:flutter/material.dart';
import '../../data/preview_state.dart';
import '../theme/tokens.dart';
import '../widgets/evidence_event_row.dart';
import '../widgets/state_views.dart';

class GH06EvidenceDrawer extends StatelessWidget {
  final GharHoldPreviewState state;

  const GH06EvidenceDrawer({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final events = state.auditEvents;

    return Drawer(
      backgroundColor: GharHoldColors.paper,
      width: MediaQuery.of(context).size.width * 0.88,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(16),
              color: GharHoldColors.forestInk,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'GH06 Evidence Drawer',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: GharHoldColors.paper,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: GharHoldColors.paper,
                        ),
                        tooltip: 'Close Drawer',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: GharHoldColors.limeVoltage,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'SIMULATION LOG · PREVIEW SAMPLE TRACES',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: GharHoldColors.forestInk,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Structured audit events recorded by the in-memory proptech coordination state machine. Notes and exact addresses are excluded for privacy.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      height: 1.3,
                      color: GharHoldColors.linenMist,
                    ),
                  ),
                ],
              ),
            ),
            // Metrics summary bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: GharHoldColors.fog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recorded Events: ${events.length}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: GharHoldColors.forestInk,
                    ),
                  ),
                  Text(
                    'Role: ${state.currentRole.name} | Fault: ${state.faultMode.name}',
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
            // Events list
            Expanded(
              child: events.isEmpty
                  ? const GharHoldEmptyView(
                      icon: Icons.receipt_long_outlined,
                      title: 'No Audit Events',
                      message:
                          'No events have been captured yet in this preview session.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return EvidenceEventRow(event: events[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
