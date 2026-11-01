import 'package:flutter/material.dart';
import '../data/preview_state.dart';
import '../domain/models/listing.dart';
import '../domain/models/request.dart';
import 'screens/gh01_listing_feed.dart';
import 'screens/gh02_listing_detail.dart';
import 'screens/gh03_request_viewing_sheet.dart';
import 'screens/gh04_my_requests.dart';
import 'screens/gh05_owner_inbox.dart';
import 'screens/gh06_evidence_drawer.dart';
import 'screens/gh07_settings_reset.dart';
import 'theme/tokens.dart';
import 'widgets/inspection_bar.dart';

class GharHoldAppShell extends StatefulWidget {
  final GharHoldPreviewState state;

  const GharHoldAppShell({super.key, required this.state});

  @override
  State<GharHoldAppShell> createState() => _GharHoldAppShellState();
}

class _GharHoldAppShellState extends State<GharHoldAppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedNavIndex =
      0; // 0: Feed, 1: My Requests, 2: Owner Inbox, 3: Settings
  PropertyListing? _selectedListing;

  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onStateChanged);
    widget.state.observability.trackScreenView('gh01_listing_feed');
  }

  @override
  void dispose() {
    widget.state.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    // If user switches role via inspection bar, automatically switch to appropriate tab
    if (widget.state.currentRole == Role.OWNER &&
        _selectedNavIndex != 2 &&
        _selectedNavIndex != 3) {
      setState(() {
        _selectedNavIndex = 2; // Owner Inbox
      });
    } else if (widget.state.currentRole == Role.RENTER &&
        _selectedNavIndex == 2) {
      setState(() {
        _selectedNavIndex = 0; // Feed
      });
    } else {
      setState(() {});
    }
  }

  void _openRequestViewingSheet(PropertyListing listing) {
    widget.state.observability.trackScreenView('gh03_request_viewing');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return GH03RequestViewingSheet(
          listing: listing,
          state: widget.state,
          onSuccess: () {
            Navigator.of(ctx).pop();
            setState(() {
              _selectedListing = null; // back to feed
              _selectedNavIndex = 1; // go to My Requests to track
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Viewing request submitted and tracked in My Requests.',
                ),
                backgroundColor: GharHoldColors.forestInk,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 720;
    final isOwner = widget.state.currentRole == Role.OWNER;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: GharHoldColors.paper,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.home_work_rounded,
              color: GharHoldColors.forestInk,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'GharHold',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: GharHoldColors.forestInk,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isOwner
                    ? GharHoldColors.spruce
                    : GharHoldColors.limeVoltage,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isOwner ? 'OWNER VIEW' : 'RENTER VIEW',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isOwner
                      ? GharHoldColors.paper
                      : GharHoldColors.forestInk,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings & Reset',
            onPressed: () {
              setState(() {
                _selectedListing = null;
                _selectedNavIndex = 3;
              });
              widget.state.observability.trackScreenView('gh07_settings_reset');
            },
          ),
        ],
      ),
      endDrawer: GH06EvidenceDrawer(state: widget.state),
      body: Column(
        children: [
          Expanded(child: _buildBody(isWide)),
          // Persistent Inspection Bar at the bottom
          ArchitectureInspectionBar(
            state: widget.state,
            onOpenEvidence: () {
              widget.state.observability.trackScreenView(
                'gh06_evidence_drawer',
              );
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) {
          setState(() {
            _selectedListing = null;
            _selectedNavIndex = index;
            if (index == 2 && widget.state.currentRole != Role.OWNER) {
              widget.state.setRole(Role.OWNER);
            } else if ((index == 0 || index == 1) &&
                widget.state.currentRole != Role.RENTER) {
              widget.state.setRole(Role.RENTER);
            }
          });

          final screenName = switch (index) {
            0 => 'gh01_listing_feed',
            1 => 'gh04_my_requests',
            2 => 'gh05_owner_inbox',
            3 => 'gh07_settings_reset',
            _ => 'screen_$index',
          };
          widget.state.observability.trackScreenView(screenName);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            activeIcon: Icon(Icons.checklist),
            label: 'My Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_outlined),
            activeIcon: Icon(Icons.inbox),
            label: 'Owner Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildBody(bool isWide) {
    if (_selectedListing != null) {
      if (isWide) {
        // Two-pane layout for wide screens: Feed on left, Detail on right
        return Row(
          children: [
            SizedBox(
              width: 380,
              child: GH01ListingFeedScreen(
                state: widget.state,
                onSelectListing: (listing) {
                  setState(() => _selectedListing = listing);
                  widget.state.observability.trackScreenView(
                    'gh02_listing_detail',
                  );
                  widget.state.observability.trackCustomEvent(
                    'listing_detail_opened',
                    attributes: {'listing_state': listing.state.name},
                  );
                },
              ),
            ),
            const VerticalDivider(width: 1, color: GharHoldColors.fog),
            Expanded(
              child: GH02ListingDetailScreen(
                listing: _selectedListing!,
                state: widget.state,
                onRequestViewing: () =>
                    _openRequestViewingSheet(_selectedListing!),
                onBack: () => setState(() => _selectedListing = null),
              ),
            ),
          ],
        );
      }
      return GH02ListingDetailScreen(
        listing: _selectedListing!,
        state: widget.state,
        onRequestViewing: () => _openRequestViewingSheet(_selectedListing!),
        onBack: () => setState(() => _selectedListing = null),
      );
    }

    switch (_selectedNavIndex) {
      case 0:
        return GH01ListingFeedScreen(
          state: widget.state,
          onSelectListing: (listing) {
            setState(() => _selectedListing = listing);
            widget.state.observability.trackScreenView('gh02_listing_detail');
            widget.state.observability.trackCustomEvent(
              'listing_detail_opened',
              attributes: {'listing_state': listing.state.name},
            );
          },
        );
      case 1:
        return GH04MyRequestsScreen(
          state: widget.state,
          onExploreFeed: () {
            setState(() {
              _selectedNavIndex = 0;
            });
          },
        );
      case 2:
        return GH05OwnerInboxScreen(state: widget.state);
      case 3:
        return GH07SettingsResetScreen(state: widget.state);
      default:
        return GH01ListingFeedScreen(
          state: widget.state,
          onSelectListing: (listing) {
            setState(() => _selectedListing = listing);
            widget.state.observability.trackScreenView('gh02_listing_detail');
            widget.state.observability.trackCustomEvent(
              'listing_detail_opened',
              attributes: {'listing_state': listing.state.name},
            );
          },
        );
    }
  }
}
