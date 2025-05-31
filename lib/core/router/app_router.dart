import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/app_main_page.dart';
import 'package:style_keeper/features/home/presentation/home_page.dart';
import 'package:style_keeper/features/styles/presentation/create_style_page.dart';
import 'package:style_keeper/features/styles/presentation/styles_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/add_clothing_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/wardrobe_page.dart';

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
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: HomePage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/wardrobe',
        name: 'wardrobe',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: WardrobePage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/add-product',
        name: 'add-product',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: AddClothingPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/styles',
        name: 'styles',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: StylesPage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/create-style',
        name: 'create-style',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AppMainPage(child: CreateStylePage()),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    ],
  );
}
