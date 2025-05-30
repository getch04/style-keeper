import 'package:flutter/material.dart';
import 'package:style_keeper/shared/widgets/app_bottom_nav_bar.dart';
import 'package:style_keeper/shared/widgets/app_main_bar.dart';

import 'features/home/presentation/home_page.dart';
import 'features/wardrobe/presentation/wardrobe_page.dart';
// import 'features/looks/presentation/looks_page.dart'; // Add when you have it

class AppMainPage extends StatefulWidget {
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  int _currentIndex = 0;

  static const List<String> _titles = [
    'Hello!',
    'Wardrobe',
    'Looks',
  ];

  static final List<Widget> _pages = [
    const HomePage(),
    const WardrobePage(),
    // LooksPage(), // Add your Looks page here
    const Center(child: Text('Looks')), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppMainBar(title: _titles[_currentIndex]),
      body: _pages[_currentIndex],
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
}
