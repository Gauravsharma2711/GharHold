import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/audit_event.dart';
import '../theme/tokens.dart';

class RequestTimeline extends StatelessWidget {
  final List<AuditEvent> events;

  const RequestTimeline({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GharHoldColors.fog,
          borderRadius: GharHoldRadii.cardRadius,
        ),
        child: const Center(
          child: Text(
            'No audit events recorded for this request yet.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: GharHoldColors.slate,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Request Lifecycle & Audit Timeline',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: GharHoldColors.forestInk,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: events.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final ev = events[index];
            final timeStr = DateFormat('hh:mm:ss a').format(ev.timestamp);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: GharHoldColors.forestInk,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (index < events.length - 1)
                      Container(
                        width: 2,
                        height: 36,
                        color: GharHoldColors.pebble.withOpacity(0.4),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: GharHoldColors.fog,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ev.eventType.name,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: GharHoldColors.forestInk,
                              ),
                            ),
                            Text(
                              timeStr,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: GharHoldColors.slate,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ev.summary,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            color: GharHoldColors.charcoal,
                          ),
                        ),
                        if (ev.previousState.isNotEmpty &&
                            ev.newState.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Transition: ${ev.previousState} → ${ev.newState}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: GharHoldColors.slate,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
