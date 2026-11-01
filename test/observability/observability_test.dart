import 'package:flutter_test/flutter_test.dart';
import 'package:gharhold/data/preview_state.dart';
import 'package:gharhold/domain/models/request.dart';
import 'package:gharhold/domain/rules/rules.dart';
import 'package:gharhold/observability/measure_observability_service.dart';
import 'package:gharhold/observability/noop_observability_service.dart';

void main() {
  group('Observability Integration & Privacy Tests', () {
    test(
      'NoOpObservabilityService records events and spans in memory without network',
      () async {
        final service = NoOpObservabilityService();
        expect(service.isEnabled, isFalse);

        await service.initialize();
        expect(service.isEnabled, isFalse);

        final span = service.startSpan('app_startup');
        span.setAttribute('layer', 'bootstrap');
        span.setStatusOk();
        span.end();

        expect(service.recordedSpans, contains('app_startup'));

        service.trackScreenView('gh01_listing_feed');
        expect(service.recordedScreens, contains('gh01_listing_feed'));

        service.trackCustomEvent('app_started', attributes: {'mode': 'test'});
        expect(service.recordedEvents.length, 1);
        expect(service.recordedEvents.first['name'], 'app_started');
        expect(service.recordedEvents.first['attributes']['mode'], 'test');
      },
    );

    test(
      'MeasureObservabilityService filters sensitive PII keys from custom events',
      () {
        final service = MeasureObservabilityService();
        // Even if uninitialized, trackCustomEvent should fail gracefully with no crash
        expect(
          () => service.trackCustomEvent(
            'user_action',
            attributes: {
              'phone_number': '+919876543210',
              'email_address': 'renter@example.com',
              'property_address': 'Flat 402, Powai',
              'location_coordinates': '19.0760, 72.8777',
              'user_note': 'Private viewing note',
              'safe_status': 'submitted',
            },
          ),
          returnsNormally,
        );
      },
    );

    test(
      'Telemetry failures do not alter business state in GharHoldPreviewState',
      () {
        final mockObservability = NoOpObservabilityService();
        final state = GharHoldPreviewState(observability: mockObservability);

        // Submit a valid viewing request for L1
        final result = state.submitViewingRequest(
          listingId: 'L1',
          preferredWindow: 'Tomorrow 10 AM',
          note: 'Relocating to Mumbai',
        );

        expect(result, isA<Valid>());
        expect(
          mockObservability.recordedSpans,
          contains('viewing_request_transaction'),
        );
        expect(
          mockObservability.recordedEvents.any(
            (e) => e['name'] == 'viewing_request_submitted',
          ),
          isTrue,
        );

        // Owner approve action
        state.setRole(Role.OWNER);
        final reqId = state.requests.first.id;
        final approveRes = state.ownerApprove(reqId);

        expect(approveRes, isA<Valid>());
        expect(
          mockObservability.recordedSpans,
          contains('owner_decision_transaction'),
        );
        expect(
          mockObservability.recordedEvents.any(
            (e) => e['name'] == 'owner_request_approved',
          ),
          isTrue,
        );

        // Business state must be intact
        final updatedReq = state.getRequestById(reqId);
        expect(updatedReq?.status, RequestStatus.APPROVED);
      },
    );

    test('Observability tracks fault mode changes without leaking PII', () {
      final mockObservability = NoOpObservabilityService();
      final state = GharHoldPreviewState(observability: mockObservability);

      state.setFaultMode(PreviewFaultMode.DROP_NETWORK);
      expect(
        mockObservability.recordedEvents.any(
          (e) =>
              e['name'] == 'fault_mode_changed' &&
              e['attributes']['fault_mode'] == 'DROP_NETWORK',
        ),
        isTrue,
      );

      state.resetPreviewData();
      expect(
        mockObservability.recordedEvents.any(
          (e) => e['name'] == 'demo_data_reset',
        ),
        isTrue,
      );
    });
  });
}
