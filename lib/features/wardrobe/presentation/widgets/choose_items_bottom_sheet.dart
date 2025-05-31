import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class ChooseItemsBottomSheet extends StatefulWidget {
  const ChooseItemsBottomSheet({super.key});

  @override
  State<ChooseItemsBottomSheet> createState() => _ChooseItemsBottomSheetState();
}

class _ChooseItemsBottomSheetState extends State<ChooseItemsBottomSheet>
    with SingleTickerProviderStateMixin {
  int selectedTab = 0;
  final List<String> tabs = ['All clothes', 'Completed looks', 'Recomendation'];
  final Set<int> selectedItems = {1, 2};

  @override
  Widget build(BuildContext context) {
    final double sheetHeight = MediaQuery.of(context).size.height * 0.9;
    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      const SizedBox(width: 15),
                      const Text(
                        'Choose items',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: SvgPicture.asset(
                          AppImages.close,
                          width: 28,
                          height: 28,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(tabs.length, (i) {
                      final isActive = selectedTab == i;
                      return GestureDetector(
                        onTap: () => setState(() => selectedTab = i),
                        child: Column(
                          children: [
                            Text(
                              tabs[i],
                              style: TextStyle(
                                color:
                                    isActive ? AppColors.yellow : Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                            if (isActive)
                              Container(
                                // margin: const EdgeInsets.only(top: 4),
                                height: 3,
                                width: MediaQuery.of(context).size.width * 0.2,
                                color: AppColors.yellow,
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  // Grid of items
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: 8,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final isSelected = selectedItems.contains(index);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedItems.remove(index);
                              } else {
                                selectedItems.add(index);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: ImagePlaceholer(
                                    height: 140,
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: SvgPicture.asset(
                                    isSelected
                                        ? AppImages.circleCheck
                                        : AppImages.circleUncheck,
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Sticky add button
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: selectedItems.isNotEmpty ? () {} : null,
                    icon: SvgPicture.asset(
                      AppImages.plus,
                      width: 22,
                      height: 22,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Add ${selectedItems.length} Items',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
