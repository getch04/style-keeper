import 'package:flutter/material.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class MyClothesTab extends StatelessWidget {
  const MyClothesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
    );
  }
}
