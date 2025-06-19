import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/data/services/wardrobe_hive_service.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/completed_looks_list.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class ChooseItemsBottomSheet extends StatefulWidget {
  final void Function(List<ClothingItem>)? onItemsSelected;
  const ChooseItemsBottomSheet({super.key, this.onItemsSelected});

  @override
  State<ChooseItemsBottomSheet> createState() => _ChooseItemsBottomSheetState();
}

class _ChooseItemsBottomSheetState extends State<ChooseItemsBottomSheet>
    with SingleTickerProviderStateMixin {
  int selectedTab = 0;
  final List<String> tabs = ['All clothes', 'Completed looks', 'Recomendation'];
  Set<int> selectedItems = {};
  late Future<List<ClothingItem>> _clothesFuture;
  List<ClothingItem> _allClothes = [];

  @override
  void initState() {
    super.initState();
    _loadClothes();
  }

  void _loadClothes() {
    _clothesFuture = WardrobeHiveService().getAllClothingItems();
  }

  Widget _buildAllClothesTab() {
    return FutureBuilder<List<ClothingItem>>(
      future: _clothesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final clothes = snapshot.data ?? [];
        _allClothes = clothes;
        if (clothes.isEmpty) {
          return const Center(
            child: Text(
              'No clothes available',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: clothes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final item = clothes[index];
            final isSelected = selectedItems.contains(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedItems.remove(index);
                  } else {
                    selectedItems.add(index);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: item.imagePath.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(item.imagePath),
                                width: double.infinity,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const ImagePlaceholer(height: 140),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: SvgPicture.asset(
                        isSelected
                            ? AppImages.circleCheck
                            : AppImages.circleUncheck,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.9;
    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const SizedBox(width: 15),
                    const Text(
                      'Choose items',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: SvgPicture.asset(
                        AppImages.close,
                        width: 28,
                        height: 28,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10),
                // Tabs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(tabs.length, (i) {
                    final isActive = selectedTab == i;
                    return GestureDetector(
                      onTap: () => setState(() => selectedTab = i),
                      child: Column(
                        children: [
                          Text(
                            tabs[i],
                            style: TextStyle(
                              color: isActive ? AppColors.yellow : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          if (isActive)
                            Container(
                              height: 3,
                              width: MediaQuery.of(context).size.width * 0.22,
                              color: AppColors.yellow,
                            ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                // Content
                Expanded(
                  child: selectedTab == 0
                      ? _buildAllClothesTab()
                      : selectedTab == 1
                          ? CompletedLooksList(
                              initialSelectedItems: selectedItems.toList(),
                              onSelectionChanged: _updateSelectedItems,
                            )
                          : const Center(
                              child: Text(
                                'Coming soon...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                ),
              ],
            ),

            // Sticky add button
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: selectedItems.isNotEmpty
                        ? () {
                            final selected = selectedItems
                                .map((i) => _allClothes[i])
                                .toList();
                            if (widget.onItemsSelected != null) {
                              widget.onItemsSelected!(selected);
                            }
                            Navigator.of(context).pop(selected);
                          }
                        : null,
                    icon: SvgPicture.asset(
                      AppImages.plus,
                      width: 22,
                      height: 22,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Add ${selectedItems.length} Items',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSelectedItems(List<int> selected) {
    setState(() {
      selectedItems = selected.toSet();
    });
  }
}
