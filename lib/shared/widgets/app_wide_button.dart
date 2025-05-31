import 'package:flutter/material.dart';
import 'package:style_keeper/core/constants/app_colors.dart';

class AppWideButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const AppWideButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.yellow,
    this.textColor = Colors.white,
    this.fontSize = 12,
    this.fontWeight = FontWeight.bold,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(vertical: 20),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
          textStyle: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
