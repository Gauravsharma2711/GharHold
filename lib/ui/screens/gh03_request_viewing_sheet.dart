import 'package:flutter/material.dart';
import 'package:measure_flutter/measure_flutter.dart';
import '../../data/preview_state.dart';
import '../../domain/models/listing.dart';
import '../../domain/rules/rules.dart';
import '../theme/tokens.dart';
import '../widgets/primary_pill_button.dart';

class GH03RequestViewingSheet extends StatefulWidget {
  final PropertyListing listing;
  final GharHoldPreviewState state;
  final VoidCallback onSuccess;

  const GH03RequestViewingSheet({
    super.key,
    required this.listing,
    required this.state,
    required this.onSuccess,
  });

  @override
  State<GH03RequestViewingSheet> createState() =>
      _GH03RequestViewingSheetState();
}

class _GH03RequestViewingSheetState extends State<GH03RequestViewingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  String _selectedWindow = 'Tomorrow 10:00 AM - 12:00 PM';
  String? _errorMessage;
  bool _isSubmitting = false;

  final List<String> _windows = [
    'Today 5:00 PM - 7:00 PM',
    'Tomorrow 10:00 AM - 12:00 PM',
    'Tomorrow 4:00 PM - 6:00 PM',
    'This Weekend 11:00 AM - 1:00 PM',
    'This Weekend 3:00 PM - 5:00 PM',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() {
      _errorMessage = null;
    });

    final note = _noteController.text.trim();
    if (note.length > 200) {
      setState(() {
        _errorMessage =
            'Note cannot exceed 200 characters (currently ${note.length}).';
      });
      return;
    }

    setState(() => _isSubmitting = true);

    final result = widget.state.submitViewingRequest(
      listingId: widget.listing.id,
      preferredWindow: _selectedWindow,
      note: note,
    );

    setState(() => _isSubmitting = false);

    if (result is Rejected) {
      setState(() {
        _errorMessage = '[${result.ruleCode}] ${result.userMessage}';
      });
    } else {
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GharHoldColors.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: GharHoldColors.pebble.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Request a Viewing',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: GharHoldColors.forestInk,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Context badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: GharHoldColors.fog,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.apartment,
                      size: 16,
                      color: GharHoldColors.forestInk,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.listing.title} · ${widget.listing.neighbourhood}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: GharHoldColors.forestInk,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Preferred window selector
              const Text(
                'Preferred Viewing Window',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: GharHoldColors.forestInk,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: GharHoldColors.pebble),
                  borderRadius: GharHoldRadii.inputRadius,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedWindow,
                    isExpanded: true,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: GharHoldColors.charcoal,
                    ),
                    items: _windows.map((w) {
                      return DropdownMenuItem(value: w, child: Text(w));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedWindow = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Optional Note field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Optional Note to Owner',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: GharHoldColors.forestInk,
                    ),
                  ),
                  Text(
                    'Max 200 chars',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: _noteController.text.length > 200
                          ? GharHoldColors.alarmRed
                          : GharHoldColors.slate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              MsrMask(
                child: TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  maxLength: 200,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText:
                        'e.g. Relocating from Pune, looking for 11-month lease.',
                    counterText: '',
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: GharHoldColors.fog,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: GharHoldColors.alarmRed.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 16,
                        color: GharHoldColors.alarmRed,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: GharHoldColors.alarmRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              // Disclaimers & Action
              const Text(
                'Submitting saves the request locally and requests an owner response. It does not mean the viewing is approved.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: GharHoldColors.slate,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: GharHoldColors.forestInk,
                        side: const BorderSide(color: GharHoldColors.forestInk),
                        minimumSize: const Size(48, 48),
                        shape: const RoundedRectangleBorder(
                          borderRadius: GharHoldRadii.pillRadius,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: PrimaryPillButton(
                      label: 'Submit Request',
                      isLoading: _isSubmitting,
                      onPressed: _handleSubmit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
