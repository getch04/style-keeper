import 'package:flutter/material.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class TripListTab extends StatelessWidget {
  const TripListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ...[
          _TripCard(
            title: 'VERY LONG LIST TITLE...',
            duration: '2 days',
            clothes: 12,
          ),
          _TripCard(
            title: 'VERY LONG LIST TITLE...',
            duration: '5 days',
            clothes: 3,
          ),
          _TripCard(
            title: 'VERY LONG LIST TITLE...',
            duration: '6 Hours',
            clothes: 2,
          ),
        ],
        SizedBox(height: 24),
      ],
    );
  }
}

class _TripCard extends StatelessWidget {
  final String title;
  final String duration;
  final int clothes;
  const _TripCard(
      {required this.title, required this.duration, required this.clothes});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
            width: 100,
            height: 80,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.darkGray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'Duration: $duration',
                  style: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Clothes: $clothes',
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
    );
  }
}
