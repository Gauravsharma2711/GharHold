import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gharhold/data/preview_state.dart';
import 'package:gharhold/main.dart';

void main() {
  group('GharHold UI Acceptance Widget Tests', () {
    testWidgets(
      'Launches directly into GH01 Listing Feed without auth or onboarding',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final state = GharHoldPreviewState();
        await tester.pumpWidget(GharHoldApp(previewState: state));
        await tester.pumpAndSettle();

        // Check GH01 elements
        expect(find.text('GharHold'), findsOneWidget);
        expect(find.text('Mumbai Rental Discovery'), findsOneWidget);
        expect(
          find.text(
            'FRONTEND PREVIEW · LOCAL DEMO STATE · Illustrative Mumbai fixtures',
          ),
          findsOneWidget,
        );

        // Check persistent Inspection Bar
        expect(find.text('SIMULATION'), findsOneWidget);
        expect(find.text('Preview Test Seam'), findsOneWidget);
        expect(find.text('Renter'), findsOneWidget);
        expect(find.text('Owner'), findsOneWidget);

        // Verify no login or signup screens exist
        expect(find.text('Login'), findsNothing);
        expect(find.text('Sign Up'), findsNothing);
        expect(find.text('Create Account'), findsNothing);
      },
    );

    testWidgets('Neighbourhood filter filters listing feed', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final state = GharHoldPreviewState();
      await tester.pumpWidget(GharHoldApp(previewState: state));
      await tester.pumpAndSettle();

      // Filter by Powai
      await tester.tap(find.text('Powai'));
      await tester.pumpAndSettle();

      // Listings from Powai should be present
      expect(find.text('Lakeview Horizon 2BHK'), findsOneWidget);
      expect(find.text('Hiranandani Central 1BHK'), findsOneWidget);
    });

    testWidgets(
      'Tapping listing opens GH02 Listing Detail with Cost Breakdown',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final state = GharHoldPreviewState();
        await tester.pumpWidget(GharHoldApp(previewState: state));
        await tester.pumpAndSettle();

        // Tap on Lakeview Horizon 2BHK
        await tester.tap(find.text('Lakeview Horizon 2BHK'));
        await tester.pumpAndSettle();

        // GH02 elements
        expect(find.text('Listing Detail'), findsOneWidget);
        expect(find.text('Move-in Cost Breakdown'), findsOneWidget);
        expect(find.text('Estimated Initial Outlay'), findsOneWidget);
        expect(find.text('Request Viewing'), findsOneWidget);
      },
    );

    testWidgets('Role Switcher toggles between Renter and Owner views', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final state = GharHoldPreviewState();
      await tester.pumpWidget(GharHoldApp(previewState: state));
      await tester.pumpAndSettle();

      expect(find.text('RENTER VIEW'), findsOneWidget);

      // Tap 'Owner' on inspection bar
      await tester.tap(find.text('Owner'));
      await tester.pumpAndSettle();

      expect(find.text('OWNER VIEW'), findsOneWidget);
      expect(find.text('Owner & Society Inbox'), findsOneWidget);
    });

    testWidgets('Evidence button opens GH06 Evidence Drawer', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final state = GharHoldPreviewState();
      await tester.pumpWidget(GharHoldApp(previewState: state));
      await tester.pumpAndSettle();

      // Tap 'Evidence Log'
      await tester.tap(find.text('Evidence Log'));
      await tester.pumpAndSettle();

      expect(find.text('GH06 Evidence Drawer'), findsOneWidget);
      expect(
        find.text('SIMULATION LOG · PREVIEW SAMPLE TRACES'),
        findsOneWidget,
      );
    });

    testWidgets('Settings tab reaches GH07 Settings & Reset Demo State', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final state = GharHoldPreviewState();
      await tester.pumpWidget(GharHoldApp(previewState: state));
      await tester.pumpAndSettle();

      // Tap settings icon or nav
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Settings & Demo Scope'), findsOneWidget);
      expect(find.text('Reset & Reseed Demo Data'), findsOneWidget);
    });
  });
}
