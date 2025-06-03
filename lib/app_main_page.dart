import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/shared/widgets/app_bottom_nav_bar.dart';
import 'package:style_keeper/shared/widgets/app_main_bar.dart';
// import 'features/looks/presentation/looks_page.dart'; // Add when you have it

class AppMainPage extends StatelessWidget {
  const AppMainPage({super.key, required this.child});

  final Widget child;

  String _getTitle(String location) {
    if (location.startsWith('/wardrobe')) {
      return 'Wardrobe';
    } else if (location.startsWith('/looks') ||
        location.startsWith('/styles')) {
      return 'Looks';
    } else if (location.startsWith('/add-product')) {
      return 'New clothing';
    } else if (location.startsWith('/create-style')) {
      return 'Create Style';
    } else if (location.startsWith('/new-shopping-list')) {
      return 'New shopping list';
    } else if (location.startsWith('/clothing-detail')) {
      return 'Clothing';
    } else if (location.startsWith('/shopping-list-detail')) {
      return 'Shopping';
    } else {
      return 'Hello!';
    }
  }

  int _getCurrentIndex(String location) {
    if (location.startsWith('/wardrobe') ||
        location.startsWith('/add-product') ||
        location.startsWith('/new-shopping-list') ||
        location.startsWith('/clothing-detail') ||
        location.startsWith('/shopping-list-detail')) {
      return 1;
    } else if (location.startsWith('/looks') ||
        location.startsWith('/styles') ||
        location.startsWith('/create-style')) {
      return 2;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final bool showBack = location.startsWith('/add-product') ||
        location.startsWith('/create-style') ||
        location.startsWith('/new-shopping-list') ||
        location.startsWith('/clothing-detail') ||
        location.startsWith('/shopping-list-detail');
    final int currentIndex = _getCurrentIndex(location);
    final String appBarTitle = _getTitle(location);

    return Scaffold(
      appBar: AppMainBar(
        title: appBarTitle,
        showBack: showBack,
        onBack: () {
          if (location == '/add-product') {
            context.go('/wardrobe');
          } else {
            context.canPop() ? context.pop() : context.go('/');
          }
        },
      ),
      body: child,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/wardrobe');
              break;
            case 2:
              context.go('/styles');
              break;
          }
        },
      ),
    );
  }
}
