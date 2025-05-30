import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';

class ImagePlaceholer extends StatelessWidget {
  const ImagePlaceholer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 164,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.darkGray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppImages.noImage, // Placeholder image
          width: 62,
          height: 62,
          color: AppColors.black,
        ),
      ),
    );
  }
}
