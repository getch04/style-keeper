import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  int _selectedTab = 0;
  final List<String> _tabs = ['My clothes', 'Shopping', 'Trip list'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onPressed: () {
          context.push('/add-product');
        },
        icon: SvgPicture.asset(
          AppImages.plus,
          width: 24,
          color: AppColors.white,
        ),
        label: const Text(
          'Add new CLOTHING',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
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
                                  ? AppColors.darkGray
                                  : AppColors.darkGray,
                            ),
                          if (index == 2)
                            SvgPicture.asset(
                              AppImages.tripList,
                              width: 28,
                              color: isSelected
                                  ? AppColors.darkGray
                                  : AppColors.darkGray,
                            ),
                          const SizedBox(width: 8),
                          Text(
                            _tabs[index],
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.darkGray,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                  width: 28,
                  color: AppColors.darkGray,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Search',
                  style: TextStyle(
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Grid of image placeholders
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              return Container(
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
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: ImagePlaceholer(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
