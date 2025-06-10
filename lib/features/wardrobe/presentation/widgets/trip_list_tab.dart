import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/trip_planning/data/models/trip_model.dart';
import 'package:style_keeper/features/trip_planning/data/trip_provider.dart';
import 'package:style_keeper/features/trip_planning/presentation/screens/trip_detail_page.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class TripListTab extends StatefulWidget {
  const TripListTab({super.key});

  @override
  State<TripListTab> createState() => _TripListTabState();
}

class _TripListTabState extends State<TripListTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TripProvider>(context, listen: false).loadTrips();
    });
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TripModel> _filterTrips(List<TripModel> trips) {
    if (_searchQuery.isEmpty) return trips;
    return trips
        .where((t) => t.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, provider, child) {
        final filteredTrips = _filterTrips(provider.trips);
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Search Bar (always visible)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SvgPicture.asset(
                          AppImages.search,
                          width: 12,
                          height: 12,
                          color: AppColors.darkGray,
                        ),
                      ),
                      prefixStyle: const TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                if (provider.trips.isEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.card_travel,
                          size: 64, color: AppColors.yellow.withOpacity(0.7)),
                      const SizedBox(height: 24),
                      const Text(
                        'No trips yet!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap the + button to add your first trip.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                else if (filteredTrips.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No trips match your search',
                        style: TextStyle(
                          color: AppColors.darkGray,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else ...[
                  ...filteredTrips.map((trip) => _TripCard(trip: trip)),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TripCard extends StatelessWidget {
  final TripModel trip;
  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/${TripDetailPage.name}', extra: {'trip': trip});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGray.withOpacity(0.10),
              blurRadius: 12,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            const ImagePlaceholer(
              width: 100,
              height: 80,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.darkGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Duration: ${trip.duration}',
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Clothes: ${trip.items.length}',
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
