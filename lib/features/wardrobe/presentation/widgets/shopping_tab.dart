import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/data/models/shopping_list_model.dart';
import 'package:style_keeper/features/wardrobe/presentation/providers/shopping_list_provider.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/shopping_list_detail_page.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class ShoppingTab extends StatefulWidget {
  const ShoppingTab({super.key});

  @override
  State<ShoppingTab> createState() => _ShoppingTabState();
}

class _ShoppingTabState extends State<ShoppingTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load shopping lists when the tab is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShoppingListProvider>().loadShoppingLists();
    });
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ShoppingListModel> _filterShoppingLists(List<ShoppingListModel> lists) {
    if (_searchQuery.isEmpty) return lists;
    return lists
        .where((l) => l.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
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
        final filteredLists = _filterShoppingLists(shoppingLists);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Search Bar
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SvgPicture.asset(
                          AppImages.search,
                          width: 12,
                          color: AppColors.darkGray,
                        ),
                      ),
                      prefixStyle: const TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),

                if (shoppingLists.isEmpty)
                  const Center(
                    child: Text(
                      'No shopping lists yet',
                      style: TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 16,
                      ),
                    ),
                  ),

                ...filteredLists
                    .map((list) => _ShoppingListCard(
                          list: list,
                        ))
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShoppingListCard extends StatefulWidget {
  final ShoppingListModel list;

  const _ShoppingListCard({
    required this.list,
  });

  @override
  State<_ShoppingListCard> createState() => _ShoppingListCardState();
}

class _ShoppingListCardState extends State<_ShoppingListCard> {
  bool _isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/${ShoppingListDetailPage.name}', extra: {
          'list': widget.list,
        });
      },
      onLongPress: () {
        setState(() {
          _isLongPressed = true;
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (widget.list.imagePath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(widget.list.imagePath!),
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
                          widget.list.name,
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
                          'Total: ${Provider.of<ShoppingListProvider>(context).shoppingLists.fold(0.0, (sum, list) => sum + list.calculatedTotalPrice).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFFBDBDBD),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Spent: ${widget.list.items.fold(0.0, (sum, item) => sum + (item.price))}',
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
            if (_isLongPressed) ...[
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  context
                      .read<ShoppingListProvider>()
                      .deleteShoppingList(widget.list.id);
                  setState(() {
                    _isLongPressed = false;
                  });
                },
                child: Container(
                  width: 36,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    AppImages.delete,
                    width: 18,
                    height: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
