import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';

class AddPhotoSection extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final String? imagePath;

  const AddPhotoSection({
    super.key,
    required this.label,
    this.onTap,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: AppColors.yellow,
        strokeWidth: 2,
        borderType: BorderType.RRect,
        radius: const Radius.circular(24),
        dashPattern: const [12, 8],
        child: Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: imagePath == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppImages.imageAdd,
                        width: 64,
                        color: AppColors.yellow,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        label,
                        style: const TextStyle(
                          color: AppColors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      imagePath!,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
