import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/styles/data/models/looks_list_model.dart';
import 'package:style_keeper/features/styles/presentation/providers/looks_list_provider.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class CompletedLooksList extends StatefulWidget {
  final Function(List<int>) onSelectionChanged;
  final List<int> initialSelectedItems;

  const CompletedLooksList({
    super.key,
    required this.onSelectionChanged,
    this.initialSelectedItems = const [],
  });

  @override
  State<CompletedLooksList> createState() => _CompletedLooksListState();
}

class _CompletedLooksListState extends State<CompletedLooksList> {
  late Set<int> selectedItems;
  LooksListProvider? _provider;

  @override
  void initState() {
    super.initState();
    selectedItems = Set.from(widget.initialSelectedItems);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_provider != null) {
        _provider!.loadLooksLists();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<LooksListProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LooksListProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.looksLists.isEmpty) {
          return const EmptyLooksState();
        }

        return LooksListView(
          looks: provider.looksLists,
          selectedItems: selectedItems,
          onItemSelected: (index) {
            setState(() {
              if (selectedItems.contains(index)) {
                selectedItems.remove(index);
              } else {
                selectedItems.add(index);
              }
              widget.onSelectionChanged(selectedItems.toList());
            });
          },
        );
      },
    );
  }
}

class EmptyLooksState extends StatelessWidget {
  const EmptyLooksState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.yellow.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppImages.wardrobe,
                width: 60,
                height: 60,
                color: AppColors.yellow,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No completed looks yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Create your first look by combining\ndifferent items from your wardrobe',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class LooksListView extends StatelessWidget {
  final List<LooksListModel> looks;
  final Set<int> selectedItems;
  final Function(int) onItemSelected;

  const LooksListView({
    super.key,
    required this.looks,
    required this.selectedItems,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: looks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final look = looks[index];
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
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: GestureDetector(
                  onTap: () => onItemSelected(index),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              look.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${look.items.length} items',
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
                          children: look.items.take(3).map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: item.imagePath.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        File(item.imagePath),
                                        width: 140,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const ImagePlaceholer(
                                      width: 140,
                                      height: 100,
                                    ),
                            );
                          }).toList(),
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
    );
  }
}
