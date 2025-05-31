import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/shared/widgets/add_photo_section.dart';

import 'choose_items_bottom_sheet.dart';

class NewShoppingListPage extends StatelessWidget {
  static const String name = "new-shopping-list";
  const NewShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        AddPhotoSection(
          label: 'Add photo',
          onTap: () {},
        ),
        const SizedBox(height: 32),
        TextField(
          decoration: InputDecoration(
            hintText: 'List name',
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'List items:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.darkGray,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ChooseItemsBottomSheet(),
                );
              },
              icon: SvgPicture.asset(AppImages.plus,
                  width: 22, height: 22, color: Colors.white),
              label: const Text(
                'Add items',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
