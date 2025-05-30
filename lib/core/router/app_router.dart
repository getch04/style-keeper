import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/features/home/presentation/home_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'main',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/wardrobe',
        name: 'wardrobe',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Wardrobe Screen'))),
      ),
      GoRoute(
        path: '/add-product',
        name: 'add-product',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Add Product Screen'))),
      ),
      GoRoute(
        path: '/styles',
        name: 'styles',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Styles Screen'))),
      ),
      GoRoute(
        path: '/create-style',
        name: 'create-style',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Create Style Screen'))),
      ),
    ],
  );
}
