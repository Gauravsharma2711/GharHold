import 'package:flutter/material.dart';
import '../../data/fixtures/seed_listings.dart';
import '../../data/preview_state.dart';
import '../../domain/models/listing.dart';
import '../theme/tokens.dart';
import '../widgets/listing_card.dart';
import '../widgets/state_views.dart';

class GH01ListingFeedScreen extends StatelessWidget {
  final GharHoldPreviewState state;
  final ValueChanged<PropertyListing> onSelectListing;

  const GH01ListingFeedScreen({
    super.key,
    required this.state,
    required this.onSelectListing,
  });

  @override
  Widget build(BuildContext context) {
    final listings = state.filteredListings;

    return Scaffold(
      backgroundColor: GharHoldColors.paper,
      body: CustomScrollView(
        slivers: [
          // Banner for demo disclosure
          SliverToBoxAdapter(
            child: Container(
              color: GharHoldColors.fog,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: GharHoldColors.slate,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'FRONTEND PREVIEW · LOCAL DEMO STATE · Illustrative Mumbai fixtures',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: GharHoldColors.slate,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Subheader & Headline
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mumbai Rental Discovery',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: GharHoldColors.forestInk,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'One verified viewing or hold at a time. Approximate area only.',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: GharHoldColors.slate,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Neighbourhood Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: kDocumentedNeighbourhoods.map((neighbourhood) {
                        final isSelected =
                            state.selectedNeighbourhood == neighbourhood;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(neighbourhood),
                            selected: isSelected,
                            onSelected: (_) =>
                                state.filterNeighbourhood(neighbourhood),
                            backgroundColor: GharHoldColors.fog,
                            selectedColor: GharHoldColors.limeVoltage,
                            checkmarkColor: GharHoldColors.forestInk,
                            labelStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: GharHoldColors.forestInk,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: GharHoldRadii.pillRadius,
                              side: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Listings content
          if (listings.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: GharHoldEmptyView(
                icon: Icons.search_off_rounded,
                title: 'No Listings Found',
                message:
                    'No available listings in ${state.selectedNeighbourhood}. Try another neighbourhood or reset filters.',
                actionLabel: 'Show All Neighbourhoods',
                onAction: () => state.filterNeighbourhood('All'),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = listings[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ListingCard(
                      listing: item,
                      onTap: () => onSelectListing(item),
                    ),
                  );
                }, childCount: listings.length),
              ),
            ),
        ],
      ),
    );
  }
}
