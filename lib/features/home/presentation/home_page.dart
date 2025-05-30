import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/home/data/weather_service.dart';
import 'package:style_keeper/shared/widgets/app_bottom_nav_bar.dart';
import 'package:style_keeper/shared/widgets/app_main_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Future<WeatherInfo?>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherService().fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppMainBar(title: 'Hello!'),
      backgroundColor: AppColors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Weather Card
          FutureBuilder<WeatherInfo?>(
            future: _weatherFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildWeatherCard(
                  date: _todayString(),
                  temperature: '--',
                  icon: AppImages.cloud,
                  description: 'Loading...',
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                final weather = snapshot.data!;
                return _buildWeatherCard(
                  date: _todayString(),
                  temperature: '${weather.temperature.round()}°C',
                  icon: _mapWeatherIcon(weather.icon),
                  description: weather.description,
                );
              } else {
                return _buildWeatherCard(
                  date: _todayString(),
                  temperature: '--',
                  icon: AppImages.cloud,
                  description: 'Unavailable',
                );
              }
            },
          ),
          const SizedBox(height: 24),
          // Section Title
          const Text(
            'Recommendations for today:',
            style: TextStyle(
              color: AppColors.darkGray,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          // Recommendations List
          ...List.generate(3, (index) => _buildRecommendationCard()),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  String _todayString() {
    final now = DateTime.now();
    return '${_weekdayName(now.weekday)} ${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}';
  }

  String _weekdayName(int weekday) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return names[(weekday - 1) % 7];
  }

  String _mapWeatherIcon(String iconCode) {
    // Map OpenWeatherMap icon codes to your SVGs if you want
    // For now, just return AppImages.cloud for all
    return AppImages.cloud;
  }

  Widget _buildWeatherCard({
    required String date,
    required String temperature,
    required String icon,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGray.withOpacity(0.15),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                temperature,
                style: const TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          SvgPicture.asset(
            icon,
            width: 48,
            height: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGray.withOpacity(0.15),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and item count
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Summer vibes 2002',
                style: TextStyle(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                '12 items',
                style: TextStyle(
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Horizontal list of image placeholders
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) => Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.darkGray.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.imageAdd, // Placeholder image
                    width: 32,
                    height: 32,
                    color: AppColors.darkGray.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
