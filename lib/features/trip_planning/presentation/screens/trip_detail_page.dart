import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/trip_planning/data/models/trip_model.dart';
import 'package:style_keeper/features/trip_planning/data/trip_provider.dart';
import 'package:style_keeper/features/trip_planning/presentation/screens/add_trip_page.dart';

class TripDetailPage extends StatefulWidget {
  const TripDetailPage({super.key});
  static const name = 'trip-detail';

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<bool> checked;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final trip = extra?['trip'] as TripModel;
      checked = List.generate(trip.items.length, (index) => false);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final trip = extra?['trip'] as TripModel;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Large image with rounded corners
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 320,
              child: trip.imagePath.isNotEmpty
                  ? Image.file(
                      File(trip.imagePath),
                      fit: BoxFit.cover,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          // Details and list
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Duration: ${trip.duration}',
                                style: const TextStyle(
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            final provider = context.read<TripProvider>();
                            provider.updateEditTripMode(true, trip.id);
                            context.push('/${AddTripPage.name}');
                          },
                          child: SvgPicture.asset(
                            AppImages.edit,
                            width: 34,
                            height: 34,
                            color: AppColors.yellow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'List items:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tabs
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.yellow,
                      indicatorWeight: 3,
                      labelColor: AppColors.yellow,
                      unselectedLabelColor: Colors.black,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      tabs: const [
                        Tab(text: 'All clothes'),
                        Tab(text: 'Completed looks'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // All clothes tab
                          ListView.builder(
                            itemCount: trip.items.length,
                            itemBuilder: (context, index) {
                              final item = trip.items[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Checkbox
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          checked[index] = !checked[index];
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        checked[index]
                                            ? AppImages.squareCheck
                                            : AppImages.squareUncheck,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Image
                                    item.imagePath.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              File(item.imagePath),
                                              width: 64,
                                              height: 64,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                                size: 32),
                                          ),
                                    const SizedBox(width: 12),
                                    // Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            'Look: Summer vibes 2005', // Placeholder, replace with actual look if available
                                            style: TextStyle(
                                              color: Color(0xFFBDBDBD),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      AppImages.eye,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          // Completed looks tab (empty for now)
                          const Center(
                            child: Text(
                              'No completed looks yet',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShoppingListItem extends StatelessWidget {
  final String name;
  final String placeOfPurchase;
  final String imagePath;
  final String price;
  final bool checked;
  final ValueChanged<bool> onChanged;
  const _ShoppingListItem({
    required this.name,
    required this.placeOfPurchase,
    required this.imagePath,
    required this.price,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => onChanged(!checked),
            child: SvgPicture.asset(
              checked ? AppImages.squareCheck : AppImages.squareUncheck,
              width: 16,
              height: 16,
            ),
          ),
          const SizedBox(width: 8),
          // Image
          if (imagePath.isNotEmpty)
            FittedBox(
              fit: BoxFit.contain,
              child: Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.darkGray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Place: $placeOfPurchase',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          SvgPicture.asset(
            AppImages.eye,
            width: 24,
            height: 24,
          ),
        ],
      ),
    );
  }
}
