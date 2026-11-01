import 'package:flutter/material.dart';
import '../../data/preview_state.dart';
import '../../domain/models/request.dart';
import '../theme/tokens.dart';

class ArchitectureInspectionBar extends StatelessWidget {
  final GharHoldPreviewState state;
  final VoidCallback onOpenEvidence;

  const ArchitectureInspectionBar({
    super.key,
    required this.state,
    required this.onOpenEvidence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GharHoldColors.forestInk,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top indicator row: SIMULATION tag & Evidence button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: GharHoldColors.limeVoltage,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'SIMULATION',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: GharHoldColors.forestInk,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Preview Test Seam',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: GharHoldColors.linenMist,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onOpenEvidence,
                  icon: const Icon(
                    Icons.receipt_long,
                    size: 14,
                    color: GharHoldColors.limeVoltage,
                  ),
                  label: const Text(
                    'Evidence Log',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: GharHoldColors.limeVoltage,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: const Size(48, 36),
                    tapTargetSize: MaterialTapTargetSize.padded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Controls row: Role Toggle & Fault Selector
            Wrap(
              spacing: 8,
              runSpacing: 6,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Role Toggle
                Container(
                  decoration: BoxDecoration(
                    color: GharHoldColors.spruce,
                    borderRadius: GharHoldRadii.pillRadius,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildRoleOption(
                        label: 'Renter',
                        isSelected: state.currentRole == Role.RENTER,
                        onTap: () => state.setRole(Role.RENTER),
                      ),
                      _buildRoleOption(
                        label: 'Owner',
                        isSelected: state.currentRole == Role.OWNER,
                        onTap: () => state.setRole(Role.OWNER),
                      ),
                    ],
                  ),
                ),
                // Fault Selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: GharHoldColors.spruce,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PreviewFaultMode>(
                      value: state.faultMode,
                      dropdownColor: GharHoldColors.forestInk,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: GharHoldColors.limeVoltage,
                      ),
                      isDense: true,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: GharHoldColors.paper,
                      ),
                      onChanged: (mode) {
                        if (mode != null) state.setFaultMode(mode);
                      },
                      items: const [
                        DropdownMenuItem(
                          value: PreviewFaultMode.NORMAL,
                          child: Text('Fault: Normal'),
                        ),
                        DropdownMenuItem(
                          value: PreviewFaultMode.DROP_NETWORK,
                          child: Text('Fault: Drop Network'),
                        ),
                        DropdownMenuItem(
                          value: PreviewFaultMode.STALE_CONFLICT,
                          child: Text('Fault: Stale Conflict'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 32, minWidth: 64),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? GharHoldColors.limeVoltage : Colors.transparent,
          borderRadius: GharHoldRadii.pillRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? GharHoldColors.forestInk : GharHoldColors.paper,
          ),
        ),
      ),
    );
  }
}
