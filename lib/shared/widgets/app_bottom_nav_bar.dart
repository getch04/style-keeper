import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style_keeper/core/constants/app_images.dart';

import '../../core/constants/app_colors.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // Uncomment if using SVG icons

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: AppColors.yellow,
        unselectedItemColor: AppColors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.home,
                colorFilter: currentIndex == 0
                    ? const ColorFilter.mode(AppColors.yellow, BlendMode.srcIn)
                    : null),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.wardrobe,
                colorFilter: currentIndex == 1
                    ? const ColorFilter.mode(AppColors.yellow, BlendMode.srcIn)
                    : null),
            label: 'Wardrobe',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AppImages.style,
                colorFilter: currentIndex == 2
                    ? const ColorFilter.mode(AppColors.yellow, BlendMode.srcIn)
                    : null),
            label: 'Looks',
          ),
        ],
      ),
    );
  }
}
