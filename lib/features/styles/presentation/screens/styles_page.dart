import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class StylesPage extends StatelessWidget {
  static const String name = "styles";
  const StylesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
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
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      AppImages.search,
                      width: 18,
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

            // Scrollable Content
            Expanded(
              child: ListView(
                children: [
                  _StyleCollection(
                    title: 'Summer vibes 2002',
                    itemCount: 12,
                    images: List.generate(3, (index) => null),
                  ),
                  _StyleCollection(
                    title: 'Look #1',
                    itemCount: 3,
                    images: List.generate(3, (index) => null),
                  ),
                  _StyleCollection(
                    title: 'New season 2021',
                    itemCount: 2,
                    images: List.generate(3, (index) => null),
                  ),
                  const SizedBox(height: 80), // Space for the floating button
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const CreateLookButton(),
    );
  }
}

class _StyleCollection extends StatelessWidget {
  final String title;
  final int itemCount;
  final List<String?> images;

  const _StyleCollection({
    required this.title,
    required this.itemCount,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              Text(
                '$itemCount items',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: images.map((image) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  height: 91,
                  width: 113,
                  child: const ImagePlaceholer(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateLookButton extends StatelessWidget {
  const CreateLookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.yellow,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          onPressed: () {
            context.push('/create-style');
          },
          icon: SvgPicture.asset(
            AppImages.plus,
            width: 24,
            color: AppColors.white,
          ),
          label: const Text(
            'Add new TRIP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
