import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/presentation/providers/shopping_list_provider.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/add_shopping_item_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/wardrobe_page.dart';
import 'package:style_keeper/shared/widgets/add_photo_section.dart';

class NewShoppingListPage extends StatefulWidget {
  static const String name = "new-shopping-list";
  const NewShoppingListPage({super.key});

  @override
  State<NewShoppingListPage> createState() => _NewShoppingListPageState();
}

class _NewShoppingListPageState extends State<NewShoppingListPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize controller with stored value if any
    final provider = context.read<ShoppingListProvider>();
    if (provider.newListName != null) {
      _nameController.text = provider.newListName!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
        if (extra != null) {
          final imagePath = extra['imagePath'] as String?;
          if (imagePath != null) {
            context.read<ShoppingListProvider>().setNewListImagePath(imagePath);
          }
        }
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveShoppingList() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _isSaving = true);

    try {
      //provider
      final provider = context.read<ShoppingListProvider>();
      final isEditing = provider.editShoppingMode;
      final listId = provider.shoppingListIdToBeEdited;

      if (isEditing && listId != null) {
        // Update existing list
        final existingList =
            provider.shoppingLists.firstWhere((list) => list.id == listId);
        final updatedList = existingList.copyWith(
          name: _nameController.text,
          items: provider.temporaryItems,
          totalPrice: provider.temporaryItemsTotalPrice,
          budget: provider.temporaryItemsTotalPrice,
          imagePath: provider.newListImagePath ?? existingList.imagePath,
          updatedAt: DateTime.now(),
        );
        await provider.updateShoppingList(updatedList);
      } else {
        // Create new list
        await provider.createShoppingList(
          name: _nameController.text,
          budget: provider.temporaryItemsTotalPrice,
          imagePath: provider.newListImagePath,
        );
      }

      provider.clearTemporaryItems();
      provider.clearNewListForm();
      if (mounted) {
        context.go('/${WardrobePage.name}');
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (provider.newListImagePath == null)
              const AddPhotoSection(
                returnTo: NewShoppingListPage.name,
              ),
            if (provider.newListImagePath != null)
              Container(
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.file(
                          File(provider.newListImagePath!),
                          height: 180,
                          width: 180,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {
                          provider.setNewListImagePath(null);
                        },
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              AppImages.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 22),
            TextField(
              controller: _nameController,
              onChanged: (value) => provider.setNewListName(value),
              style: const TextStyle(
                color: AppColors.darkGray,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
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
                    context.push('/${AddShoppingItemPage.name}');
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
            if (provider.temporaryItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No items added yet',
                    style: TextStyle(
                      color: AppColors.lightGray,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ...provider.temporaryItems.map((item) => ShoppingListItem(
                  item: item,
                  onDelete: () => provider.removeTemporaryItem(item.id),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveShoppingList,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow.withOpacity(
                      _isSaving ? 0.25 : 1,
                    ),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Text('Save and continue'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ShoppingListItem extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback onDelete;

  const ShoppingListItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

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
            child: GestureDetector(
              onTap: onDelete,
              child: SvgPicture.asset(
                AppImages.delete,
                width: 24,
                height: 24,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(item.imagePath),
              height: 70,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Description and price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.darkGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.brand.isNotEmpty)
                  AutoSizeText(
                    'Brand: ${item.brand}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.lightGray,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  '${item.price}',
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
              //eye
              AppImages.eye)
        ],
      ),
    );
  }
}
