import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/camera_overlay_page.dart';
import 'package:style_keeper/shared/widgets/notice_dialog.dart';

class AddPhotoSection extends StatelessWidget {
  final String label;
  // final VoidCallback? onTap;
  final String? imagePath;
  final String returnTo;

  const AddPhotoSection({
    super.key,
    this.label = 'Add photo',
    // this.onTap,
    this.imagePath,
    required this.returnTo,
  });

  void _showNoticeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => NoticeDialog(
        onContinue: () {
          context.push('/${CameraOverlayPage.name}', extra: {
            'returnTo': returnTo,
          });
        },
        onCancel: () {
          GoRouter.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showNoticeDialog(context),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: DottedBorder(
            color: AppColors.yellow,
            strokeWidth: 2,
            borderType: BorderType.RRect,
            radius: const Radius.circular(24),
            dashPattern: const [12, 8],
            child: Center(
              child: imagePath == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImages.imageAdd,
                          width: 64,
                          color: AppColors.yellow,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          label,
                          style: const TextStyle(
                            color: AppColors.yellow,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        imagePath!,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
