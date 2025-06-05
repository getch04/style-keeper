import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/data/models/shopping_list_model.dart';
import 'package:style_keeper/features/wardrobe/presentation/providers/shopping_list_provider.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/new_shopping_list_page.dart';

class ShoppingListDetailPage extends StatefulWidget {
  const ShoppingListDetailPage({super.key});
  static const name = 'shopping-list-detail';

  @override
  State<ShoppingListDetailPage> createState() => _ShoppingListDetailPageState();
}

class _ShoppingListDetailPageState extends State<ShoppingListDetailPage> {
  // Manage checked state for each item
  final List<bool> checked = [false, false];

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final list = extra?['list'] as ShoppingListModel;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large image placeholder
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: 320,
                child: Center(
                  child: Image.file(
                    File(list.imagePath!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Details and list
            Container(
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
                                list.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Budget: ${list.budget.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFFBDBDBD),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Spent: ${list.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.yellow,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                final provider =
                                    context.read<ShoppingListProvider>();
                                provider.setNewListName(list.name);
                                provider.setNewListImagePath(list.imagePath);
                                provider.clearTemporaryItems();
                                for (var item in list.items) {
                                  provider.addTemporaryItem(item);
                                }
                                provider.updateEditShoppingMode(true, list.id);
                                context.push('/${NewShoppingListPage.name}');
                              },
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: AppColors.yellow.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppImages.edit,
                                    width: 22,
                                    height: 22,
                                    color: AppColors.yellow,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'List items:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // List items
                    ...list.items.map((item) => _ShoppingListItem(
                          name: item.name,
                          placeOfPurchase: item.placeOfPurchase,
                          imagePath: item.imagePath,
                          price: item.price.toString(),
                          checked: checked[0],
                          onChanged: (val) => setState(() => checked[0] = val),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShoppingListItem extends StatelessWidget {
  final String name;
  final String placeOfPurchase;
  final String imagePath;
  final String price;
  final bool checked;
  final ValueChanged<bool> onChanged;
  const _ShoppingListItem({
    required this.name,
    required this.placeOfPurchase,
    required this.imagePath,
    required this.price,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => onChanged(!checked),
            child: SvgPicture.asset(
              checked ? AppImages.squareCheck : AppImages.squareUncheck,
              width: 16,
              height: 16,
            ),
          ),
          const SizedBox(width: 8),
          // Image
          if (imagePath.isNotEmpty)
            FittedBox(
              fit: BoxFit.contain,
              child: Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.darkGray.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Place: $placeOfPurchase',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
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
  }
}
