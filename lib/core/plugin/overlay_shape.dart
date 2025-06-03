import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OverlayShape extends StatelessWidget {
  const OverlayShape({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var size = media.size;
    // Calculate square size based on screen width
    double squareSize = media.orientation == Orientation.portrait
        ? size.shortestSide * .8 // 90% of screen width in portrait
        : size.longestSide * .5; // 50% in landscape

    double radius = 0.064 * squareSize; // Proportional corner radius

    return Stack(
      children: [
        // Square border outline
        Align(
            alignment: Alignment.center,
            child: Container(
              width: squareSize,
              height: squareSize,
              decoration: ShapeDecoration(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                  side: const BorderSide(width: 1, color: Colors.white),
                ),
              ),
            )),
        Align(
          alignment: Alignment.center,
          child: // LET'S ADD THE SELECTED SAMPLE SVG HERE,
              SvgPicture.asset(
            imagePath,
            width: squareSize * 0.55,
            color: Colors.white.withOpacity(0.7),
            fit: BoxFit.contain,
          ),
        ),
        // Overlay mask
        ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: squareSize,
                    height: squareSize,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
