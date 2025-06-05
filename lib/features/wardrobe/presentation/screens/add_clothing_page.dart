import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/data/services/wardrobe_hive_service.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/camera_overlay_page.dart';
import 'package:style_keeper/shared/widgets/add_photo_section.dart';
import 'package:style_keeper/shared/widgets/notice_dialog.dart';
import 'package:uuid/uuid.dart';

class AddClothingPage extends StatefulWidget {
  static const String name = "add-product";
  final VoidCallback? onClothingSaved;

  const AddClothingPage({
    super.key,
    this.onClothingSaved,
  });

  @override
  State<AddClothingPage> createState() => _AddClothingPageState();
}

class _AddClothingPageState extends State<AddClothingPage> {
  String? imagePath;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isSaving = false;

  bool isEditMode = false;
  ClothingItem? itemToEdit;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
      isEditMode = extra['isEditMode'] as bool? ?? false;
      itemToEdit = extra['itemToEdit'] as ClothingItem?;

      if (isEditMode && itemToEdit != null) {
        _loadExistingData();
      } else if (!isEditMode) {
        if (extra['imagePath'] != null) {
          imagePath = extra['imagePath'] as String;
        }
      }
      _isInitialized = true;
    }
  }

  void _loadExistingData() {
    final item = itemToEdit!;
    imagePath = item.imagePath;
    _nameController.text = item.name;
    _brandController.text = item.brand;
    _placeController.text = item.placeOfPurchase;
    _priceController.text = item.price.toString();
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
    if (imagePath == null || _nameController.text.isEmpty) return;
    setState(() => _isSaving = true);

    final item = ClothingItem(
      id: isEditMode ? itemToEdit!.id : const Uuid().v4(),
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      placeOfPurchase: _placeController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      imagePath: imagePath!,
      createdAt: isEditMode ? itemToEdit!.createdAt : DateTime.now(),
    );

    if (isEditMode) {
      await WardrobeHiveService().updateClothingItem(item);
    } else {
      await WardrobeHiveService().addClothingItem(item);
    }

    setState(() => _isSaving = false);
    widget.onClothingSaved?.call();
    if (mounted) context.go('/wardrobe');
  }

  void _showNoticeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => NoticeDialog(
        onContinue: () {
          context.push('/${CameraOverlayPage.name}', extra: {
            'returnTo': AddClothingPage.name,
          });
        },
        onCancel: () {
          GoRouter.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (imagePath == null && !isEditMode)
            const AddPhotoSection(
              returnTo: AddClothingPage.name,
            ),
          if (imagePath != null)
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
                        File(imagePath!),
                        height: 180,
                        width: 180,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 30),
                    GestureDetector(
                      onTap: () {
                        if (!isEditMode) {
                          setState(() => imagePath = null);
                        }
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
          _buildInput(_nameController, 'Name of clothing'),
          const SizedBox(height: 14),
          _buildInput(_brandController, 'Brand'),
          const SizedBox(height: 14),
          _buildInput(_placeController, 'Place of purchase'),
          const SizedBox(height: 14),
          _buildInput(_priceController, 'Price', isNumber: true),
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
                  : Text(isEditMode ? 'Update' : 'Save and continue'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      cursorColor: Colors.black,
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
