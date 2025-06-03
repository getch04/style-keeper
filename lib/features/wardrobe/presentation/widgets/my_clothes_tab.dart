import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    _loadClothes();
  }

  void _loadClothes() {
    _clothesFuture = WardrobeHiveService().getAllClothingItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadClothes();
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
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: clothes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (context, index) {
            final item = clothes[index];
            return GestureDetector(
              onTap: () {
                context.push('/${ClothingDetailPage.name}', extra: item);
              },
              child: Container(
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
                                borderRadius: BorderRadius.circular(12),
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
            );
          },
        );
      },
    );
  }
}
