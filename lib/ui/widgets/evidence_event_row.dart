import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../domain/models/audit_event.dart';
import '../theme/tokens.dart';

class EvidenceEventRow extends StatefulWidget {
  final AuditEvent event;

  const EvidenceEventRow({super.key, required this.event});

  @override
  State<EvidenceEventRow> createState() => _EvidenceEventRowState();
}

class _EvidenceEventRowState extends State<EvidenceEventRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ev = widget.event;
    final timeStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(ev.timestamp);
    final shortCorr = ev.correlationId.length > 8
        ? '${ev.correlationId.substring(0, 8)}...'
        : ev.correlationId;

    final badgeColor = switch (ev.eventType) {
      AuditEventType.RULE_REJECTED => GharHoldColors.alarmRed,
      AuditEventType.SYNC_FAILURE => GharHoldColors.signalBlue,
      AuditEventType.CONFLICT => GharHoldColors.alarmRed,
      AuditEventType.STATE_TRANSITION => GharHoldColors.forestInk,
      AuditEventType.OWNER_DECISION => GharHoldColors.spruce,
      AuditEventType.DATA_RESET => GharHoldColors.charcoal,
      _ => GharHoldColors.slate,
    };

    return Material(
      color: GharHoldColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: GharHoldColors.fog, width: 1),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            onTap: () => setState(() => _expanded = !_expanded),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ev.eventType.name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ev.summary,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: GharHoldColors.forestInk,
                    ),
                    maxLines: _expanded ? null : 1,
                    overflow: _expanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Text(
                    timeStr,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: GharHoldColors.slate,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'corr: $shortCorr',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontFamilyFallback: ['monospace'],
                      color: GharHoldColors.pebble,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      size: 12,
                      color: GharHoldColors.slate,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Copy Correlation ID',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: ev.correlationId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Correlation ID copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            trailing: Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: GharHoldColors.slate,
              size: 20,
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1, color: GharHoldColors.fog),
                  const SizedBox(height: 8),
                  _buildDetailRow('Component', ev.component),
                  _buildDetailRow('Previous State', ev.previousState),
                  _buildDetailRow('New State', ev.newState),
                  if (ev.ruleOrErrorCode != null)
                    _buildDetailRow('Rule / Error Code', ev.ruleOrErrorCode!),
                  _buildDetailRow('Full Correlation ID', ev.correlationId),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: GharHoldColors.slate,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: GharHoldColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
