import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_colors.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'features/wardrobe/data/models/clothing_item.dart';
import 'features/wardrobe/presentation/providers/wardrobe_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ClothingItemAdapter());
  await Hive.openBox<ClothingItem>('clothing_items');

  // Initialize dependency injection
  await configureDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WardrobeProvider()),
        // Add other providers here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Style Keeper',
      routerConfig: AppRouter.router,
      theme: ThemeData(
        fontFamily: 'Jost',
        primarySwatch: AppColors.primarySwatch,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.darkGray,
          secondary: AppColors.yellow,
          surface: AppColors.white,
          error: Colors.red,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.darkGray,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Jost',
        primarySwatch: AppColors.primarySwatch,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.yellow,
          secondary: AppColors.yellow,
          surface: AppColors.darkGray,
          error: Colors.red,
        ),
        useMaterial3: true,
      ),
    );
  }
}
