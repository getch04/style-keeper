import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/trip_planning/presentation/screens/add_trip_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/add_clothing_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/my_clothes_tab.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/new_shopping_list_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/shopping_tab.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/trip_list_tab.dart';

class WardrobePage extends StatefulWidget {
  static const String name = "wardrobe";
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  int _selectedTab = 0;
  final List<String> _tabs = ['My clothes', 'Shopping', 'Trip list'];
  Key _clothesTabKey = UniqueKey();

  void _refreshClothesTab() {
    setState(() {
      _clothesTabKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedTab == 0
          ? Padding(
              padding: const EdgeInsets.only(right: 5),
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    context.push('/${AddClothingPage.name}', extra: {
                      'onClothingSaved': _refreshClothesTab,
                    });
                  },
                  icon: SvgPicture.asset(
                    AppImages.plus,
                    width: 24,
                    color: AppColors.white,
                  ),
                  label: const Text(
                    'Add new CLOTHING',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            )
          : _selectedTab == 1
              ? Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context.push('/${NewShoppingListPage.name}');
                      },
                      icon: SvgPicture.asset(
                        AppImages.plus,
                        width: 24,
                        color: AppColors.white,
                      ),
                      label: const Text(
                        'Add new LIST',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context.push('/${AddTripPage.name}');
                      },
                      icon: SvgPicture.asset(
                        AppImages.plus,
                        width: 24,
                        color: AppColors.white,
                      ),
                      label: const Text(
                        'Add new TRIP',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Toggle buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_tabs.length, (index) {
              final isSelected = _selectedTab == index;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      height: 90,
                      width: 104,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.yellow : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (!isSelected)
                            BoxShadow(
                              color: AppColors.darkGray.withOpacity(0.10),
                              blurRadius: 12,
                              offset: const Offset(0, 0),
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (index == 0)
                            SvgPicture.asset(
                              AppImages.clothes,
                              width: 28,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.darkGray,
                            ),
                          if (index == 1)
                            SvgPicture.asset(
                              AppImages.shopping,
                              width: 28,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.darkGray,
                            ),
                          if (index == 2)
                            SvgPicture.asset(
                              AppImages.tripList,
                              width: 28,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.darkGray,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            _tabs[index],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.darkGray,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
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
                SvgPicture.asset(
                  AppImages.search,
                  width: 22,
                  color: AppColors.darkGray,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Search',
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _selectedTab == 0
              ? MyClothesTab(key: _clothesTabKey)
              : _selectedTab == 1
                  ? const ShoppingTab()
                  : const TripListTab(),
        ],
      ),
    );
  }
}
