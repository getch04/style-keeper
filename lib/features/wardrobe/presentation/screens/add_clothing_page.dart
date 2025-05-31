import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/choose_sample_page.dart';
import 'package:style_keeper/shared/widgets/notice_dialog.dart';

class AddClothingPage extends StatelessWidget {
  const AddClothingPage({super.key});

  void _showNoticeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => NoticeDialog(
        title: 'Notice',
        message:
            'Please note that before taking a photo, place the element on a white background and set its standard position. For your convenience, we have developed several templates.',
        onContinue: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ChooseSamplePage(),
            ),
          );
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Photo picker
          GestureDetector(
            onTap: () => _showNoticeDialog(context),
            child: DottedBorder(
              color: AppColors.yellow,
              strokeWidth: 2,
              borderType: BorderType.RRect,
              radius: const Radius.circular(24),
              dashPattern: const [12, 8],
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppImages.imageAdd,
                        width: 64,
                        color: AppColors.yellow,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Add photo',
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Input fields
          _buildInput('Name of clothing'),
          const SizedBox(height: 18),
          _buildInput('Brand'),
          const SizedBox(height: 18),
          _buildInput('Place of purchase'),
          const SizedBox(height: 18),
          _buildInput('Price'),
          const SizedBox(height: 32),
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null, // Disabled
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow.withOpacity(0.25),
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              child: const Text('Save and continue'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String hint) {
    return TextField(
      enabled: false, // For pixel-perfect mockup, set to true for real use
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFBDBDBD),
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
