import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class ShoppingTab extends StatelessWidget {
  const ShoppingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => _ShoppingListCard(index: index)),
    );
  }
}

class _ShoppingListCard extends StatelessWidget {
  final int index;
  const _ShoppingListCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final isEnglish = index == 0;
    return GestureDetector(
      onTap: () {
        context.push('/shopping-list-detail');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
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
          children: [
            const ImagePlaceholer(
              width: 120,
              height: 100,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnglish
                        ? 'VERY LONG LIST TITLE...'
                        : 'ОЧЕНЬ ДЛИННОЕ НА...',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isEnglish ? 'Budget: 15,000,000' : 'Бюджет: 15 000 000',
                    style: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEnglish ? 'Spent: 222,53' : 'Потрачено: 222,53',
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
    );
  }
}
