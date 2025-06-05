import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/data/services/wardrobe_hive_service.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/clothing_detail_page.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class MyClothesTab extends StatefulWidget {
  const MyClothesTab({super.key});

  @override
  State<MyClothesTab> createState() => _MyClothesTabState();
}

class _MyClothesTabState extends State<MyClothesTab> {
  late Future<List<ClothingItem>> _clothesFuture;
  int? _longPressedIndex;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadClothes();
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

  void _loadClothes() {
    _clothesFuture = WardrobeHiveService().getAllClothingItems();
  }

  Future<void> _deleteClothingItem(String id) async {
    await WardrobeHiveService().deleteClothingItem(id);
    setState(() {
      _longPressedIndex = null;
      _loadClothes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClothingItem>>(
      future: _clothesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final clothes = snapshot.data ?? [];
        final filteredClothes = _searchQuery.isEmpty
            ? clothes
            : clothes
                .where((item) => item.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();
        if (clothes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.checkroom,
                    size: 64, color: AppColors.yellow.withOpacity(0.7)),
                const SizedBox(height: 24),
                const Text(
                  'No clothes yet!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the + button to add your first clothing item.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
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
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: const TextStyle(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SvgPicture.asset(
                          AppImages.search,
                          width: 16,
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
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredClothes.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final item = filteredClothes[index];
                    return GestureDetector(
                      onTap: () {
                        if (_longPressedIndex != null) {
                          setState(() => _longPressedIndex = null);
                        } else {
                          context.push(
                            '/${ClothingDetailPage.name}',
                            extra: item,
                          );
                        }
                      },
                      onLongPress: () {
                        setState(() => _longPressedIndex = index);
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.darkGray.withOpacity(0.10),
                                  blurRadius: 12,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: item.imagePath.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.file(
                                              File(item.imagePath),
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const ImagePlaceholer(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_longPressedIndex == index)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => _deleteClothingItem(item.id),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: SvgPicture.asset(
                                        AppImages.delete,
                                        color: Colors.white,
                                        width: 26,
                                        height: 26,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
