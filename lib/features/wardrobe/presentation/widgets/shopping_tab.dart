import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/features/wardrobe/domain/models/shopping_list_model.dart';
import 'package:style_keeper/features/wardrobe/presentation/providers/shopping_list_provider.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/shopping_list_detail_page.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class ShoppingTab extends StatefulWidget {
  const ShoppingTab({super.key});

  @override
  State<ShoppingTab> createState() => _ShoppingTabState();
}

class _ShoppingTabState extends State<ShoppingTab> {
  @override
  void initState() {
    super.initState();
    // Load shopping lists when the tab is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShoppingListProvider>().loadShoppingLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final shoppingLists = provider.shoppingLists;

        if (shoppingLists.isEmpty) {
          return const Center(
            child: Text(
              'No shopping lists yet',
              style: TextStyle(
                color: AppColors.darkGray,
                fontSize: 16,
              ),
            ),
          );
        }

        return Column(
          children: shoppingLists
              .map((list) => _ShoppingListCard(
                    list: list,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _ShoppingListCard extends StatelessWidget {
  final ShoppingListModel list;

  const _ShoppingListCard({
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/${ShoppingListDetailPage.name}', extra: {
          'list': list,
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
            if (list.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(list.imagePath!),
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              )
            else
              const ImagePlaceholer(
                width: 100,
                height: 80,
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: AppColors.darkGray,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Budget: ${list.budget.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Spent: ${list.items.fold(0.0, (sum, item) => sum + (item.price))}',
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
