import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/add_clothing_page.dart';

class ClothingDetailPage extends StatelessWidget {
  static const String name = "clothing-detail";
  const ClothingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final item = GoRouterState.of(context).extra as ClothingItem;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          child: // we will receive a path to the iamge, so it is not network image
              item.imagePath != ''
                  ? Image.file(
                      File(item.imagePath),
                      width: double.infinity,
                      height: 260,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(),
        ),
        // Details
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${item.brand}   |   ${item.placeOfPurchase}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ]),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        context.push('/${AddClothingPage.name}', extra: {
                          'isEditMode': true,
                          'itemToEdit': item,
                        });
                      },
                      child: SvgPicture.asset(AppImages.coloredEdit),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Text(
                    '${item.price} ₴',
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Related looks:',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
