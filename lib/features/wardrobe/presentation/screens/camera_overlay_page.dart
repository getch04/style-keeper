import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';

class CameraOverlayPage extends StatefulWidget {
  const CameraOverlayPage({super.key});

  @override
  State<CameraOverlayPage> createState() => _CameraOverlayPageState();
}

class _CameraOverlayPageState extends State<CameraOverlayPage> {
  CameraController? _controller;
  int selectedIndex = 1;
  bool _isCameraInitialized = false;

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
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview background
          Positioned.fill(
            child: _isCameraInitialized && _controller != null
                ? CameraPreview(_controller!)
                : Container(color: Colors.black),
          ),
          // Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),
          // Centered camera area with template overlay
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.width * 0.85,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _isCameraInitialized && _controller != null
                          ? CameraPreview(_controller!)
                          : Container(color: Colors.black),
                      SvgPicture.asset(
                        icons[selectedIndex],
                        width: MediaQuery.of(context).size.width * 0.7,
                        color: Colors.white.withOpacity(0.7),
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.arrowBack,
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    const Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Sample label
                  const Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sample',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  // Template selection row
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: icons.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final isSelected = selectedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.yellow
                                    : Colors.black,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                icons[index],
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Shutter row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.grey[400]!, width: 2),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.blackNoCloth,
                            width: 28,
                            height: 28,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      const SizedBox(width: 36),
                      GestureDetector(
                        onTap: () async {
                          if (_controller != null &&
                              _controller!.value.isInitialized) {
                            await _controller!.takePicture();
                            // TODO: handle image
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
