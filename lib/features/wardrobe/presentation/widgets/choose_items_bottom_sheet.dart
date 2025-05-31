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
            Column(
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
                        fontSize: 22,
                        color: Colors.black,
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
                const SizedBox(height: 10),
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
                              color: isActive ? AppColors.yellow : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          if (isActive)
                            Container(
                              height: 3,
                              width: MediaQuery.of(context).size.width * 0.22,
                              color: AppColors.yellow,
                            ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 18),
                // Content
                Expanded(
                  child: selectedTab == 1
                      ? ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          itemCount: 3,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            // Dummy data for looks
                            final lookTitles = [
                              'Summer vibes 2002',
                              'Look #1',
                              'New season 2021',
                            ];
                            final lookItems = [12, 3, 2];
                            final isSelected = selectedItems.contains(index);
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Checkbox
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            selectedItems.remove(index);
                                          } else {
                                            selectedItems.add(index);
                                          }
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        isSelected
                                            ? AppImages.circleCheck
                                            : AppImages.circleUncheck,
                                        width: 28,
                                        height: 28,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 18, horizontal: 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  lookTitles[index],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                '${lookItems[index]} items',
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: List.generate(
                                                3,
                                                (imgIdx) => Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          imgIdx < 2 ? 12 : 0),
                                                  child: const ImagePlaceholer(
                                                    width: 140,
                                                    height: 100,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : GridView.builder(
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
                      'Add ${selectedItems.length} Items',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
