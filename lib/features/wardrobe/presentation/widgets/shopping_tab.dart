import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/features/wardrobe/presentation/providers/shopping_list_provider.dart';
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
                    name: list.name,
                    budget: list.budget,
                    spent:
                        list.items.fold(0.0, (sum, item) => sum + (item.price)),
                    imagePath: list.imagePath,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _ShoppingListCard extends StatelessWidget {
  final String name;
  final double budget;
  final double spent;
  final String? imagePath;

  const _ShoppingListCard({
    required this.name,
    required this.budget,
    required this.spent,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/shopping-list-detail');
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
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imagePath!),
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
                    name,
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
                    'Budget: ${budget.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Spent: ${spent.toStringAsFixed(2)}',
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
