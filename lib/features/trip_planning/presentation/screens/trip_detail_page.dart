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
  late List<bool> checkedClothes;
  late List<bool> checkedLooks;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final trip = extra?['trip'] as TripModel;
      checkedClothes = List.generate(trip.items.length, (index) => false);
      checkedLooks =
          List.generate(trip.completedLooks.length, (index) => false);
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
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _tabController.animateTo(0);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _tabController.index == 0
                                        ? AppColors.yellow
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                'All clothes (${trip.items.length})',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _tabController.index == 0
                                      ? AppColors.yellow
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _tabController.animateTo(1);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _tabController.index == 1
                                        ? AppColors.yellow
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Completed looks (${trip.completedLooks.length})',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _tabController.index == 1
                                      ? AppColors.yellow
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
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
                                          checkedClothes[index] =
                                              !checkedClothes[index];
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        checkedClothes[index]
                                            ? AppImages.squareCheck
                                            : AppImages.squareUncheck,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: item.imagePath.isNotEmpty
                                          ? Image.file(
                                              File(item.imagePath),
                                              width: 64,
                                              height: 64,
                                              fit: BoxFit.cover,
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
                          // Completed looks tab
                          ListView.builder(
                            itemCount: trip.completedLooks.length,
                            itemBuilder: (context, index) {
                              final look = trip.completedLooks[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Checkbox
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          checkedLooks[index] =
                                              !checkedLooks[index];
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        checkedLooks[index]
                                            ? AppImages.squareCheck
                                            : AppImages.squareUncheck,
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Preview images (first 3 items)
                                    SizedBox(
                                      width: 64,
                                      height: 64,
                                      child: Row(
                                        children:
                                            look.items.take(3).map((item) {
                                          return Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 2),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: item.imagePath.isNotEmpty
                                                    ? Image.file(
                                                        File(item.imagePath),
                                                        height: 64,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Container(
                                                        height: 64,
                                                        color: Colors
                                                            .grey.shade200,
                                                        child: const Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color: Colors.grey,
                                                          size: 16,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            look.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${look.items.length} items',
                                            style: const TextStyle(
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
