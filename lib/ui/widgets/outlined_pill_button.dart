import 'package:flutter/material.dart';
import '../theme/tokens.dart';

class OutlinedPillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color textColor;
  final String? semanticLabel;

  const OutlinedPillButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.borderColor = GharHoldColors.forestInk,
    this.textColor = GharHoldColors.forestInk,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: semanticLabel ?? label,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
        child: Material(
          color: GharHoldColors.paper,
          shape: RoundedRectangleBorder(
            borderRadius: GharHoldRadii.pillRadius,
            side: BorderSide(
              color: onPressed != null ? borderColor : GharHoldColors.pebble,
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: GharHoldRadii.pillRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18,
                      color: onPressed != null
                          ? textColor
                          : GharHoldColors.pebble,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: onPressed != null
                          ? textColor
                          : GharHoldColors.pebble,
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
