import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/app_main_page.dart';
import 'package:style_keeper/features/home/presentation/home_page.dart';
import 'package:style_keeper/features/styles/presentation/screens/create_style_page.dart';
import 'package:style_keeper/features/styles/presentation/screens/styles_page.dart';
import 'package:style_keeper/features/trip_planning/presentation/screens/add_trip_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/add_clothing_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/add_shopping_item_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/camera_overlay_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/wardrobe_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/clothing_detail_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/new_shopping_list_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/shopping_list_detail_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'main',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: HomePage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${HomePage.name}',
        name: HomePage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: HomePage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${WardrobePage.name}',
        name: WardrobePage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: WardrobePage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${AddClothingPage.name}',
        name: AddClothingPage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: AddClothingPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${StylesPage.name}',
        name: StylesPage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: StylesPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${CreateStylePage.name}',
        name: CreateStylePage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: CreateStylePage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${NewShoppingListPage.name}',
        name: NewShoppingListPage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: NewShoppingListPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/clothing-detail',
        name: 'clothing-detail',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: ClothingDetailPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${ShoppingListDetailPage.name}',
        name: ShoppingListDetailPage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: ShoppingListDetailPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${AddTripPage.name}',
        name: AddTripPage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: AddTripPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      // GoRoute(
      //   path: '/${ChooseSamplePage.name}',
      //   name: ChooseSamplePage.name,
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //     key: state.pageKey,
      //     child: const ChooseSamplePage(),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //       return FadeTransition(opacity: animation, child: child);
      //     },
      //   ),
      // ),
      GoRoute(
        path: '/${CameraOverlayPage.name}',
        name: CameraOverlayPage.name,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CameraOverlayPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/${CameraPreviewPage.name}',
        name: CameraPreviewPage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CameraPreviewPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/${AddShoppingItemPage.name}',
        name: AddShoppingItemPage.name,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: AddShoppingItemPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );
}
