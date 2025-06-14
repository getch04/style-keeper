import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/home/data/weather_service.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class HomePage extends StatefulWidget {
  static const String name = "home";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<WeatherInfo?>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherService().fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Weather Card
        FutureBuilder<WeatherInfo?>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildWeatherCard(
                date: _todayString(),
                temperature: '---',
                icon: "",
                description: 'Loading...',
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final weather = snapshot.data!;
              return _buildWeatherCard(
                date: _todayString(),
                temperature: '${weather.temperature.round()}°C',
                icon: weather.icon,
                description: weather.description,
              );
            } else {
              return _buildWeatherCard(
                date: _todayString(),
                temperature: '---',
                icon: "",
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
        ...List.generate(2, (index) => _buildRecommendationCard()),
      ],
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

  String _mapWeatherIcon(int temp) {
    //let's map the icon based on the temprature
    if (temp > 30) {
      return AppImages.sun;
    } else if (temp > 20) {
      return AppImages.cloud;
    } else if (temp > 10) {
      return AppImages.rain;
    } else {
      return AppImages.snow;
    }
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
                  fontSize: 45,
                ),
              ),
            ],
          ),
          // if (icon.isNotEmpty)
          //   CachedNetworkImage(
          //     imageUrl: icon,
          //     placeholder: (context, url) => const CircularProgressIndicator(),
          //     errorWidget: (context, url, error) => SvgPicture.asset(
          //       icon,
          //       width: 60,
          //       height: 60,
          //     ),
          //   )
          // else
          SvgPicture.asset(
            _mapWeatherIcon(int.tryParse(temperature) ?? 0),
            width: 60,
            height: 60,
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
            color: AppColors.darkGray.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 0),
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
            height: 113,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) => const ImagePlaceholer(
                      width: 113,
                      height: 91,
                    )),
          ),
        ],
      ),
    );
  }
}
