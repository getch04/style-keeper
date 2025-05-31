import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/presentation/camera_overlay_page.dart';
import 'package:style_keeper/shared/widgets/app_wide_button.dart';

class ChooseSamplePage extends StatefulWidget {
  const ChooseSamplePage({super.key});

  @override
  State<ChooseSamplePage> createState() => _ChooseSamplePageState();
}

class _ChooseSamplePageState extends State<ChooseSamplePage> {
  int selectedIndex = 1;

  final List<String> icons = [
    AppImages.blackNoCloth,
    AppImages.blackSuri,
    AppImages.blackTshirt,
    AppImages.blackCaport,
    AppImages.blackGurd,
    AppImages.blackKemis,
    AppImages.blackLongTshirt,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 82),
            const Text(
              'Choose sample',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: icons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.yellow : Colors.black,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            icons[index],
                            width: 64,
                            height: 64,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  AppWideButton(
                    text: 'Next step',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CameraOverlayPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  AppWideButton(
                    backgroundColor: AppColors.darkGray,
                    text: 'Back',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
