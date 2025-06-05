import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/presentation/providers/shopping_list_provider.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/new_shopping_list_page.dart';
import 'package:style_keeper/shared/widgets/add_photo_section.dart';
import 'package:uuid/uuid.dart';

class AddShoppingItemPage extends StatefulWidget {
  static const String name = "add-shopping-item";

  const AddShoppingItemPage({super.key});

  @override
  State<AddShoppingItemPage> createState() => _AddShoppingItemPageState();
}

class _AddShoppingItemPageState extends State<AddShoppingItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isSaving = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with stored values if any
    final provider = context.read<ShoppingListProvider>();
    if (provider.newItemName != null) {
      _nameController.text = provider.newItemName!;
    }
    if (provider.newItemBrand != null) {
      _brandController.text = provider.newItemBrand!;
    }
    if (provider.newItemPlace != null) {
      _placeController.text = provider.newItemPlace!;
    }
    if (provider.newItemPrice != null) {
      _priceController.text = provider.newItemPrice!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      if (extra != null) {
        final imagePath = extra['imagePath'] as String?;
        if (imagePath != null) {
          context.read<ShoppingListProvider>().setNewItemImagePath(imagePath);
        }
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _placeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveClothingItem() async {
    final provider = context.read<ShoppingListProvider>();
    if (provider.newItemImagePath == null || _nameController.text.isEmpty)
      return;
    setState(() => _isSaving = true);

    try {
      final item = ClothingItem(
        id: const Uuid().v4(),
        name: _nameController.text,
        brand: _brandController.text,
        placeOfPurchase: _placeController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        imagePath: provider.newItemImagePath!,
        createdAt: DateTime.now(),
      );

      // Add to temporary items in provider
      provider.addTemporaryItem(item);
      provider.clearNewItemForm();

      if (mounted) {
        context.go('/${NewShoppingListPage.name}');
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (provider.newItemImagePath == null)
                const AddPhotoSection(
                  returnTo: AddShoppingItemPage.name,
                ),
              if (provider.newItemImagePath != null)
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
                            File(provider.newItemImagePath!),
                            height: 180,
                            width: 180,
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(width: 30),
                        GestureDetector(
                          onTap: () {
                            provider.setNewItemImagePath(null);
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
              _buildInput(
                _nameController,
                'Name of clothing',
                onChanged: (value) => provider.setNewItemName(value),
              ),
              const SizedBox(height: 14),
              _buildInput(
                _brandController,
                'Brand',
                onChanged: (value) => provider.setNewItemBrand(value),
              ),
              const SizedBox(height: 14),
              _buildInput(
                _placeController,
                'Place of purchase',
                onChanged: (value) => provider.setNewItemPlace(value),
              ),
              const SizedBox(height: 14),
              _buildInput(
                _priceController,
                'Price',
                isNumber: true,
                onChanged: (value) => provider.setNewItemPrice(value),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveClothingItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow.withOpacity(
                      _isSaving ? 0.25 : 1,
                    ),
                    foregroundColor: AppColors.white,
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
                              strokeWidth: 2, color: AppColors.white),
                        )
                      : const Text('Save and continue'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      cursorColor: Colors.black,
      onChanged: onChanged,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFBDBDBD),
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
