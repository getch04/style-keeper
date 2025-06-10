import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/styles/presentation/providers/looks_list_provider.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/choose_items_bottom_sheet.dart';
import 'package:style_keeper/shared/widgets/add_photo_section.dart';

class CreateStylePage extends StatefulWidget {
  static const String name = "create-style";
  const CreateStylePage({super.key});

  @override
  State<CreateStylePage> createState() => _CreateStylePageState();
}

class _CreateStylePageState extends State<CreateStylePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;
  bool _isInitialized = false;
  String? _selectedSeason;
  String? _selectedWeather;
  final GlobalKey _seasonKey = GlobalKey();
  final GlobalKey _weatherKey = GlobalKey();
  bool _seasonMenuOpen = false;
  bool _weatherMenuOpen = false;
  List<ClothingItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    final provider = context.read<LooksListProvider>();
    if (provider.newListName != null) {
      _nameController.text = provider.newListName!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final provider = context.read<LooksListProvider>();
        // Always check for imagePath in GoRouter extra
        final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
        if (extra != null) {
          final imagePath = extra['imagePath'] as String?;
          if (imagePath != null) {
            provider.setNewListImagePath(imagePath);
          }
        }
        if (provider.editLooksMode && provider.looksListIdToBeEdited != null) {
          await _loadLooksList(provider.looksListIdToBeEdited!);
        }
        _isInitialized = true;
      });
    }
  }

  Future<void> _loadLooksList(String listId) async {
    final provider = context.read<LooksListProvider>();
    final looksList = await provider.getLooksList(listId);
    if (looksList != null) {
      setState(() {
        _nameController.text = looksList.name;
        provider.setNewListName(looksList.name);
        provider.setNewListImagePath(looksList.imagePath);
        provider.clearTemporaryItems();
        for (final item in looksList.items) {
          provider.addTemporaryItem(item);
        }
        _selectedItems = List<ClothingItem>.from(looksList.items);
        _selectedSeason = looksList.season;
        _selectedWeather = looksList.weather;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    context.read<LooksListProvider>().clearEditLooksMode();
    super.dispose();
  }

  Future<void> _saveLooksList() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _isSaving = true);

    try {
      final provider = context.read<LooksListProvider>();
      if (provider.editLooksMode && provider.looksListIdToBeEdited != null) {
        // Update existing list
        final looksList =
            await provider.getLooksList(provider.looksListIdToBeEdited!);
        if (looksList != null) {
          final updatedList = looksList.copyWith(
            name: _nameController.text,
            imagePath: provider.newListImagePath,
            items: _selectedItems,
            season: _selectedSeason,
            weather: _selectedWeather,
          );
          await provider.updateLooksList(updatedList);
        }
      } else {
        // Create new list
        await provider.createLooksList(
          name: _nameController.text,
          imagePath: provider.newListImagePath,
          // items: _selectedItems,
          season: _selectedSeason,
          weather: _selectedWeather,
        );
      }

      provider.clearTemporaryItems();
      provider.clearNewListForm();
      provider.clearEditLooksMode();
      if (mounted) {
        context.go('/styles');
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LooksListProvider>(
      builder: (context, provider, child) {
        final isEditing =
            provider.editLooksMode && provider.looksListIdToBeEdited != null;
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (provider.newListImagePath == null)
                  const AddPhotoSection(
                    returnTo: CreateStylePage.name,
                  ),
                if (provider.newListImagePath != null)
                  Container(
                    width: 400,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.file(
                              File(provider.newListImagePath!),
                              height: 180,
                              width: 180,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(width: 30),
                          GestureDetector(
                            onTap: () {
                              provider.setNewListImagePath(null);
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SvgPicture.asset(
                                  AppImages.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 22),
                TextField(
                  controller: _nameController,
                  onChanged: (value) => provider.setNewListName(value),
                  style: const TextStyle(
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Name of new look',
                    hintStyle: const TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Season Dropdown
                GestureDetector(
                  key: _seasonKey,
                  onTap: () async {
                    setState(() => _seasonMenuOpen = true);
                    final RenderBox renderBox = _seasonKey.currentContext!
                        .findRenderObject() as RenderBox;
                    final Offset offset = renderBox.localToGlobal(Offset.zero);
                    final double fieldWidth = renderBox.size.width;
                    final result = await showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        offset.dx,
                        offset.dy + renderBox.size.height,
                        offset.dx + renderBox.size.width,
                        offset.dy,
                      ),
                      items: [
                        PopupMenuItem<String>(
                          enabled: false,
                          child: SizedBox(
                            width: fieldWidth > 320 ? fieldWidth : 320,
                            child: const Text('Season',
                                style: TextStyle(
                                    color: Color(0xFFBDBDBD),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        ...[
                          'Winter',
                          'Spring',
                          'Summer',
                          'Autumn'
                        ].map((option) => PopupMenuItem<String>(
                              value: option,
                              child: SizedBox(
                                width: fieldWidth > 320 ? fieldWidth : 320,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(option,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500))),
                                    if (_selectedSeason == option)
                                      const Icon(Icons.check,
                                          color: Colors.black),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    );
                    setState(() => _seasonMenuOpen = false);
                    if (result != null && result != 'Season') {
                      setState(() => _selectedSeason = result);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedSeason ?? 'Season',
                            style: TextStyle(
                              color: _selectedSeason == null
                                  ? const Color(0xFFBDBDBD)
                                  : AppColors.darkGray,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: _seasonMenuOpen ? 0.25 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: SvgPicture.asset(
                            AppImages.dropdown,
                            width: 24,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Weather Dropdown
                GestureDetector(
                  key: _weatherKey,
                  onTap: () async {
                    setState(() => _weatherMenuOpen = true);
                    final RenderBox renderBox = _weatherKey.currentContext!
                        .findRenderObject() as RenderBox;
                    final Offset offset = renderBox.localToGlobal(Offset.zero);
                    final double fieldWidth = renderBox.size.width;
                    final result = await showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        offset.dx,
                        offset.dy + renderBox.size.height,
                        offset.dx + renderBox.size.width,
                        offset.dy,
                      ),
                      items: [
                        PopupMenuItem<String>(
                          enabled: false,
                          child: SizedBox(
                            width: fieldWidth > 320 ? fieldWidth : 320,
                            child: const Text('Weather',
                                style: TextStyle(
                                    color: Color(0xFFBDBDBD),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        ...[
                          'Sunny',
                          'Windy',
                          'Cloudy',
                          'Rainy',
                          'Stormy',
                          'Snowy'
                        ].map((option) => PopupMenuItem<String>(
                              value: option,
                              child: SizedBox(
                                width: fieldWidth > 320 ? fieldWidth : 320,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(option,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500))),
                                    if (_selectedWeather == option)
                                      const Icon(Icons.check,
                                          color: Colors.black),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    );
                    setState(() => _weatherMenuOpen = false);
                    if (result != null && result != 'Weather') {
                      setState(() => _selectedWeather = result);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedWeather ?? 'Weather',
                            style: TextStyle(
                              color: _selectedWeather == null
                                  ? const Color(0xFFBDBDBD)
                                  : AppColors.darkGray,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: _weatherMenuOpen ? 0.25 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: SvgPicture.asset(
                            AppImages.dropdown,
                            width: 24,
                            color: AppColors.darkGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'List items:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result =
                              await showModalBottomSheet<List<ClothingItem>>(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: const ChooseItemsBottomSheet(),
                            ),
                          );
                          if (result != null && result.isNotEmpty) {
                            setState(() {
                              _selectedItems = result;
                            });
                            // Also update provider's temporaryItems for compatibility
                            final provider = context.read<LooksListProvider>();
                            provider.clearTemporaryItems();
                            for (final item in result) {
                              provider.addTemporaryItem(item);
                            }
                          }
                        },
                        icon: SvgPicture.asset(AppImages.plus,
                            width: 22, height: 22, color: AppColors.white),
                        label: const Text(
                          'Add items',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (_selectedItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'No items added yet',
                        style: TextStyle(
                          color: AppColors.lightGray,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ..._selectedItems.map((item) => _LookListItem(
                      item: item,
                      onDelete: () {
                        setState(() {
                          _selectedItems.removeWhere((i) => i.id == item.id);
                        });
                        final provider = context.read<LooksListProvider>();
                        provider.removeTemporaryItem(item.id);
                      },
                    )),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveLooksList,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow.withOpacity(
                        _isSaving ? 0.25 : 1,
                      ),
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            isEditing ? 'Save Changes' : 'Save and continue'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LookListItem extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback onDelete;

  const _LookListItem({
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Delete icon
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: onDelete,
              child: SvgPicture.asset(
                AppImages.delete,
                width: 24,
                height: 24,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(item.imagePath),
              height: 80,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Description and price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.darkGray,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.price}',
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Eye icon
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: SvgPicture.asset(
              AppImages.look,
              width: 24,
              height: 24,
              color: AppColors.lightGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectOptionSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selected;
  const _SelectOptionSheet(
      {required this.title, required this.options, this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFBDBDBD),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          ...options.map((option) => ListTile(
                title: Text(
                  option,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                trailing: selected == option
                    ? const Icon(Icons.check, color: Colors.black)
                    : null,
                onTap: () => Navigator.of(context).pop(option),
              )),
        ],
      ),
    );
  }
}
