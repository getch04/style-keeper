import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/shared/widgets/add_photo_section.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class CreateStylePage extends StatelessWidget {
  static const String name = "create-style";
  const CreateStylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Add photo section
            const AddPhotoSection(
              returnTo: CreateStylePage.name,
            ),
            const SizedBox(height: 22),
            // Name input and Add items button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Name of new look',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'List items:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: SvgPicture.asset(AppImages.plus,
                        width: 22, height: 22, color: AppColors.white),
                    label: const Text(
                      'Add items',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // List items
            ...List.generate(2, (index) => const _LookListItem()),
            const SizedBox(height: 22),
            // Save and continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                child: const Text('Save and continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LookListItem extends StatelessWidget {
  const _LookListItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Delete icon
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SvgPicture.asset(
              AppImages.delete,
              width: 24,
              height: 24,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          // Image
          const ImagePlaceholer(
            height: 80,
            width: 110,
          ),
          const SizedBox(width: 16),
          // Description and price
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'sdsadasdas dasd asd asdas dad as dasd',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.darkGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  '120 000',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Eye icon
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: SvgPicture.asset(
              AppImages.look,
              width: 24,
              height: 24,
              color: AppColors.lightGray,
            ),
          ),
        ],
      ),
    );
  }
}
