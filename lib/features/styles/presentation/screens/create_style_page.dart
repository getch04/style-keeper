import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/styles/presentation/providers/looks_list_provider.dart';
import 'package:style_keeper/features/styles/presentation/screens/add_looks_item_page.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/shared/widgets/add_photo_section.dart';

class CreateStylePage extends StatefulWidget {
  static const String name = "create-style";
  const CreateStylePage({super.key});

  @override
  State<CreateStylePage> createState() => _CreateStylePageState();
}

class _CreateStylePageState extends State<CreateStylePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<LooksListProvider>();
    if (provider.newListName != null) {
      _nameController.text = provider.newListName!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final provider = context.read<LooksListProvider>();
        // Always check for imagePath in GoRouter extra
        final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
        if (extra != null) {
          final imagePath = extra['imagePath'] as String?;
          if (imagePath != null) {
            provider.setNewListImagePath(imagePath);
          }
        }
        if (provider.editLooksMode && provider.looksListIdToBeEdited != null) {
          await _loadLooksList(provider.looksListIdToBeEdited!);
        }
        _isInitialized = true;
      });
    }
  }

  Future<void> _loadLooksList(String listId) async {
    final provider = context.read<LooksListProvider>();
    final looksList = await provider.getLooksList(listId);
    if (looksList != null) {
      setState(() {
        _nameController.text = looksList.name;
        provider.setNewListName(looksList.name);
        provider.setNewListImagePath(looksList.imagePath);
        provider.clearTemporaryItems();
        for (final item in looksList.items) {
          provider.addTemporaryItem(item);
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    context.read<LooksListProvider>().clearEditLooksMode();
    super.dispose();
  }

  Future<void> _saveLooksList() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _isSaving = true);

    try {
      final provider = context.read<LooksListProvider>();
      if (provider.editLooksMode && provider.looksListIdToBeEdited != null) {
        // Update existing list
        final looksList =
            await provider.getLooksList(provider.looksListIdToBeEdited!);
        if (looksList != null) {
          final updatedList = looksList.copyWith(
            name: _nameController.text,
            imagePath: provider.newListImagePath,
            items: provider.temporaryItems,
          );
          await provider.updateLooksList(updatedList);
        }
      } else {
        // Create new list
        await provider.createLooksList(
          name: _nameController.text,
          imagePath: provider.newListImagePath,
        );
      }

      provider.clearTemporaryItems();
      provider.clearNewListForm();
      provider.clearEditLooksMode();
      if (mounted) {
        context.go('/styles');
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LooksListProvider>(
      builder: (context, provider, child) {
        final isEditing =
            provider.editLooksMode && provider.looksListIdToBeEdited != null;
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (provider.newListImagePath == null)
                  const AddPhotoSection(
                    returnTo: CreateStylePage.name,
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
                    hintText: 'Name of new look',
                    hintStyle: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
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
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'List items:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push('/${AddLooksItemPage.name}');
                        },
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
                ...provider.temporaryItems.map((item) => _LookListItem(
                      item: item,
                      onDelete: () => provider.removeTemporaryItem(item.id),
                    )),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveLooksList,
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
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            isEditing ? 'Save Changes' : 'Save and continue'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LookListItem extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback onDelete;

  const _LookListItem({
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
              height: 80,
              width: 110,
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
