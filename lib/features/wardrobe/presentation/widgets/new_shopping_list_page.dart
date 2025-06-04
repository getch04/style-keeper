import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/add_shopping_item_page.dart';
import 'package:style_keeper/shared/widgets/add_photo_section.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class NewShoppingListPage extends StatelessWidget {
  static const String name = "new-shopping-list";
  const NewShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const AddPhotoSection(),
        const SizedBox(height: 22),
        TextField(
          decoration: InputDecoration(
            hintText: 'List name',
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontWeight: FontWeight.w500,
              fontSize: 16,
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
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'List items:',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.darkGray,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.pushNamed(
                  AddShoppingItemPage.name,
                );
              },
              icon: SvgPicture.asset(
                AppImages.plus,
                width: 18,
                height: 18,
                color: Colors.white,
              ),
              label: const Text(
                'Add items',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
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
        const ShoppingListItem(),
      ],
    );
  }
}

class ShoppingListItem extends StatelessWidget {
  const ShoppingListItem({super.key});

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
            height: 70,
            width: 90,
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
                AutoSizeText(
                  'Look: Summer vibes 2005',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColors.lightGray,
                  ),
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
