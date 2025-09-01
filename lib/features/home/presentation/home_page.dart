import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/styles/data/models/looks_list_model.dart';
import 'package:style_keeper/features/styles/presentation/providers/looks_list_provider.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class HomePage extends StatefulWidget {
  static const String name = "home";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedWeatherIndex = 0;

  final List<Map<String, String>> weatherIcons = [
    {'selected': AppImages.yellowSun, 'unselected': AppImages.sun},
    {'selected': AppImages.yellowWind, 'unselected': AppImages.wind},
    {'selected': AppImages.yellowCloud, 'unselected': AppImages.cloud},
    {'selected': AppImages.yellowRain, 'unselected': AppImages.rain},
    {'selected': AppImages.yellowStorm, 'unselected': AppImages.storm},
    {'selected': AppImages.yellowSnow, 'unselected': AppImages.snow},
  ];

  // Weather mapping for filtering
  final List<String> weatherTypes = [
    'sunny',
    'windy',
    'cloudy',
    'rainy',
    'stormy',
    'snowy',
  ];

  @override
  void initState() {
    super.initState();
    // Load looks lists filtered by default weather (sunny) when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final defaultWeather = weatherTypes[selectedWeatherIndex]; // sunny
      context.read<LooksListProvider>().loadLooksListsByWeather(defaultWeather);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // New Weather Card Design
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What is the weather like today?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(weatherIcons.length, (index) {
                  final isSelected = selectedWeatherIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedWeatherIndex = index;
                      });
                      // Load looks filtered by selected weather
                      final selectedWeather = weatherTypes[index];
                      context
                          .read<LooksListProvider>()
                          .loadLooksListsByWeather(selectedWeather);
                    },
                    child: SvgPicture.asset(
                      isSelected
                          ? weatherIcons[index]['selected']!
                          : weatherIcons[index]['unselected']!,
                      width: 44,
                      height: 44,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        // Section Title
        const Text(
          'All Looks',
          style: TextStyle(
            color: AppColors.darkGray,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        // Looks List
        Consumer<LooksListProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.looksLists.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.yellow.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.style,
                        size: 64, color: AppColors.yellow.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No looks yet!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: const Text(
                      'Create your first look to get started.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }

            return Column(
              children: provider.looksLists
                  .map((look) => _buildRecommendationCard(look))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(LooksListModel look) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGray.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and item count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                look.name,
                style: const TextStyle(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '${look.items.length} items',
                style: const TextStyle(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Horizontal list of images
          SizedBox(
            height: 113,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: look.items.length.clamp(0, 4),
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = look.items[index];
                return item.imagePath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(item.imagePath),
                          width: 113,
                          height: 91,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const ImagePlaceholer(
                        width: 113,
                        height: 91,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
