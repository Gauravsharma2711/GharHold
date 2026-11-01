import 'package:flutter/material.dart';
import '../../data/preview_state.dart';
import '../theme/tokens.dart';
import '../widgets/outlined_pill_button.dart';

class GH07SettingsResetScreen extends StatelessWidget {
  final GharHoldPreviewState state;

  const GH07SettingsResetScreen({super.key, required this.state});

  void _showResetConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: GharHoldColors.paper,
          shape: RoundedRectangleBorder(borderRadius: GharHoldRadii.cardRadius),
          title: const Text(
            'Confirm Reset Demo State',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              color: GharHoldColors.alarmRed,
            ),
          ),
          content: const Text(
            'This action will reseed all in-memory property listings and requests to default source fixtures. Note: This clears the in-memory preview state (no durable database was modified).',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              height: 1.4,
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
              label: 'Reset Preview Fixtures',
              borderColor: GharHoldColors.alarmRed,
              textColor: GharHoldColors.alarmRed,
              onPressed: () {
                state.resetPreviewData();
                Navigator.of(dialogCtx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'In-memory preview data reseeded to default fixtures.',
                    ),
                    backgroundColor: GharHoldColors.forestInk,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GharHoldColors.paper,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          const Text(
            'Settings & Demo Scope',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: GharHoldColors.forestInk,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'GharHold Mumbai rental coordination prototype architecture info.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: GharHoldColors.slate,
            ),
          ),
          const SizedBox(height: 20),
          // Demo scope card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GharHoldColors.fog,
              borderRadius: GharHoldRadii.cardRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: GharHoldColors.forestInk,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FRONTEND PREVIEW',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: GharHoldColors.paper,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Phase 1 Architecture',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: GharHoldColors.forestInk,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '• Isolated In-Memory State: All listings and requests are managed in an in-memory preview state decoupled from future backend persistence.\n'
                  '• Invariant BR-1: A listing accepts a new viewing or token request only while it is AVAILABLE.\n'
                  '• Invariant BR-1b: At most one active viewing request exists per listing.\n'
                  '• Invariant BR-2: A declined request cannot jump directly to approved; it requires explicit reopening with a reason.\n'
                  '• Invariant BR-3: Retries safely reuse the same UUID idempotency key to prevent duplicate booking.\n'
                  '• Token Marker: Token is a workflow lock marker only. No money moves, and no live payment gateway is integrated.\n'
                  '• Approximate Area Only: Precise GPS coordinates and exact home addresses are never shown or collected.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    height: 1.5,
                    color: GharHoldColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Reseed & Reset Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GharHoldColors.paper,
              borderRadius: GharHoldRadii.cardRadius,
              border: Border.all(
                color: GharHoldColors.alarmRed.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.restart_alt,
                      size: 20,
                      color: GharHoldColors.alarmRed,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Reset Preview State',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: GharHoldColors.alarmRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Restores all 10 illustrative Mumbai listing fixtures (Powai, Andheri East, Bandra West, Malad West) and default demo request states. Does not clear a database as persistence is in-memory for this phase.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    height: 1.4,
                    color: GharHoldColors.slate,
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedPillButton(
                  label: 'Reset & Reseed Demo Data',
                  icon: Icons.refresh,
                  borderColor: GharHoldColors.alarmRed,
                  textColor: GharHoldColors.alarmRed,
                  onPressed: () => _showResetConfirmDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Simulation disclaimer
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: GharHoldColors.fog,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.terminal, size: 18, color: GharHoldColors.forestInk),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Inspection Bar controls (Renter/Owner role toggle, Drop Network, Stale Conflict) are live preview test seams.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
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
}
