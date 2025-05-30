import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:style_keeper/core/constants/app_images.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red.shade300,
      body: Center(
        child: SvgPicture.asset(
          AppImages.whiteLongTshirt,
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
