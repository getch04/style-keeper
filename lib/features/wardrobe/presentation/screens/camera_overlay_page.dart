import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/core/plugin/flutter_camera_overlay.dart';
import 'package:style_keeper/core/plugin/overlay_shape.dart';
import 'package:style_keeper/features/styles/presentation/screens/add_looks_item_page.dart';
import 'package:style_keeper/features/styles/presentation/screens/create_style_page.dart';
import 'package:style_keeper/features/trip_planning/presentation/screens/add_trip_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/providers/selected_sample_provider.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/add_clothing_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/screens/add_shopping_item_page.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/new_shopping_list_page.dart';

class CameraOverlayPage extends StatefulWidget {
  static const String name = "camera-overlay";

  const CameraOverlayPage({
    super.key,
  });

  @override
  State<CameraOverlayPage> createState() => _CameraOverlayPageState();
}

class _CameraOverlayPageState extends State<CameraOverlayPage> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  String? returnTo;
  bool _isInitialized = false;
  XFile? _pickedImage;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
      returnTo = extra['returnTo'] as String?;
      _isInitialized = true;
    }
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller!.setDescription(cameras[0]);
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

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _pickedImage = XFile(pickedFile.path);
        });
      }
    } catch (e) {
      // Optionally show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _handleImageCapture(XFile file) async {
    if (!mounted) return;
    final selectedProvider =
        Provider.of<SelectedSampleProvider>(context, listen: false);
    final selectedIndex = selectedProvider.selectedIndex;
    final hasOverlay = selectedProvider.hasSelectedSample;

    // Load the captured image
    final bytes = await File(file.path).readAsBytes();
    final original = img.decodeImage(bytes);
    if (original == null) return;

    // Get screen and overlay sizes - EXACTLY match OverlayShape calculation
    final screenSize = MediaQuery.of(context).size;
    final squareSize =
        screenSize.shortestSide * 0.8; // EXACT match to OverlayShape

    // Calculate overlay position - EXACTLY match OverlayShape (centered)
    final squareLeft = (screenSize.width - squareSize) / 2;
    final squareTop =
        (screenSize.height - squareSize) / 2; // Centered vertically

    // Map overlay rect to image coordinates
    final imageAspectRatio = original.width / original.height;
    final screenAspectRatio = screenSize.width / screenSize.height;

    double previewWidth, previewHeight;
    double offsetX = 0, offsetY = 0;

    if (imageAspectRatio > screenAspectRatio) {
      // Image is wider - fit height, crop width
      previewHeight = screenSize.height;
      previewWidth = screenSize.height * imageAspectRatio;
      offsetX = (previewWidth - screenSize.width) / 2;
    } else {
      // Image is taller - fit width, crop height
      previewWidth = screenSize.width;
      previewHeight = screenSize.width / imageAspectRatio;
      offsetY = (previewHeight - screenSize.height) / 2;
    }

    // Convert overlay screen coordinates to image coordinates
    final scaleX = original.width / previewWidth;
    final scaleY = original.height / previewHeight;

    final cropX = ((squareLeft + offsetX) * scaleX).round();
    final cropY = ((squareTop + offsetY) * scaleY).round();
    final cropSize = (squareSize * scaleX).round(); // Use scaleX for square

    // Ensure crop rect is within image bounds
    final safeCropX = cropX.clamp(0, original.width - cropSize);
    final safeCropY = cropY.clamp(0, original.height - cropSize);
    final safeCropSize = cropSize
        .clamp(0, original.width - safeCropX)
        .clamp(0, original.height - safeCropY);

    final cropped = img.copyCrop(
      original,
      x: safeCropX,
      y: safeCropY,
      width: safeCropSize,
      height: safeCropSize,
    );
    final croppedPath = file.path.replaceFirst('.jpg', '_cropped.jpg');
    await File(croppedPath).writeAsBytes(img.encodeJpg(cropped));

    final extra = {
      'imagePath': croppedPath,
      'overlayIndex': selectedIndex,
      'overlayAsset': hasOverlay ? icons[selectedIndex] : null,
      'squareSize': squareSize,
    };

    // Reset picked image after use
    setState(() {
      _pickedImage = null;
    });

    // Route based on returnTo parameter
    switch (returnTo) {
      case AddShoppingItemPage.name:
        context.push('/${AddShoppingItemPage.name}', extra: extra);
        break;
      case AddClothingPage.name:
        context.push('/${AddClothingPage.name}', extra: extra);
        break;
      case CreateStylePage.name:
        context.push('/${CreateStylePage.name}', extra: extra);
        break;
      case AddLooksItemPage.name:
        context.push('/${AddLooksItemPage.name}', extra: extra);
        break;
      case AddTripPage.name:
        context.push('/${AddTripPage.name}', extra: extra);
        break;
      case NewShoppingListPage.name:
        context.push('/${NewShoppingListPage.name}', extra: extra);
        break;
      default:
        // Default to AddClothingPage if no returnTo specified
        context.push('/${AddClothingPage.name}', extra: extra);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double squareSize = screenWidth - 32;
    final selectedProvider = Provider.of<SelectedSampleProvider>(context);
    final selectedIndex = selectedProvider.selectedIndex;
    final hasOverlay = selectedProvider.hasSelectedSample;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Show picked image if available, else camera overlay
          _pickedImage != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(_pickedImage!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    OverlayShape(
                      imagePath: icons[selectedIndex],
                      showSample: selectedIndex != 0,
                    ),
                  ],
                )
              : (_isCameraInitialized && _controller != null
                  ? CameraOverlay(
                      _controller!.description,
                      _handleImageCapture,
                      imagePath: hasOverlay ? icons[selectedIndex] : icons[0],
                      showSample: selectedIndex != 0,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    )),

          // Back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: InkWell(
                onTap: () => context.pop(),
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
          // Shutter button (bottom center) and sample row
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sample label
                  const Padding(
                    padding: EdgeInsets.only(left: 32, bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sample',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  // Sample icon row
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 32),
                      itemCount: icons.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final isSelected = selectedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              _pickImageFromGallery();
                            } else {
                              Provider.of<SelectedSampleProvider>(context,
                                      listen: false)
                                  .setSelectedIndex(index);
                              if (_pickedImage == null) {
                                setState(() {
                                  _pickedImage = null;
                                });
                              } else {
                                setState(() {}); // Just update overlay
                              }
                            }
                          },
                          child: Container(
                            width: 75,
                            height: 80,
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
                  const SizedBox(height: 14),
                  // Shutter and gallery button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Only show gallery button if not already showing picked image
                      if (_pickedImage == null)
                        IconButton(
                          icon: const Icon(Icons.photo_library,
                              color: Colors.white),
                          iconSize: 48,
                          onPressed: _pickImageFromGallery,
                        ),
                      GestureDetector(
                        onTap: () async {
                          if (_pickedImage != null) {
                            _handleImageCapture(_pickedImage!);
                          } else if (_controller != null &&
                              _controller!.value.isInitialized) {
                            final XFile file = await _controller!.takePicture();
                            _handleImageCapture(file);
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: AppColors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 36,
                              height: 36,
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
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraPreviewPage extends StatelessWidget {
  static const String name = "camera-preview";

  const CameraPreviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final extraData = GoRouterState.of(context).extra! as Map<String, dynamic>;
    final imagePath = extraData['imagePath'] as String;
    final overlayIndex = extraData['overlayIndex'] as int;
    final overlayAsset = extraData['overlayAsset'] as String;
    final squareSize = extraData['squareSize'] as double;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 92),
          Center(
            child: SizedBox(
              width: squareSize,
              height: squareSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Image.file(
                      File(imagePath),
                      width: squareSize,
                      height: squareSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SvgPicture.asset(
                    overlayAsset,
                    width: squareSize * 0.55,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        '/${AddClothingPage.name}',
                        extra: {
                          'imagePath': imagePath,
                          'overlayIndex': overlayIndex,
                          'overlayAsset': overlayAsset,
                          'squareSize': squareSize,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Use this image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Retake image',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
