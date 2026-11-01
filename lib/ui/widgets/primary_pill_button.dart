import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class PrimaryPillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? semanticLabel;

  const PrimaryPillButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: semanticLabel ?? label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
        child: Material(
          color: onPressed != null && !isLoading
              ? GharHoldColors.limeVoltage
              : GharHoldColors.fog,
          borderRadius: GharHoldRadii.pillRadius,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: GharHoldRadii.pillRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) ...[
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          GharHoldColors.forestInk,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (icon != null) ...[
                    Icon(icon, size: 18, color: GharHoldColors.forestInk),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: GharHoldColors.forestInk,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
