import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/styles/data/models/looks_list_model.dart';
import 'package:style_keeper/features/styles/presentation/providers/looks_list_provider.dart';
import 'package:style_keeper/shared/widgets/image_placeholer.dart';

class StylesPage extends StatefulWidget {
  static const String name = "styles";
  const StylesPage({super.key});

  @override
  State<StylesPage> createState() => _StylesPageState();
}

class _StylesPageState extends State<StylesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  LooksListProvider? _provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_provider != null) {
        _provider!.loadLooksLists();
      }
    });
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _provider = Provider.of<LooksListProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Do not use context here; _provider is safe
    _provider = null;
    super.dispose();
  }

  List<LooksListModel> _filterLooksLists(List<LooksListModel> looksLists) {
    if (_searchQuery.isEmpty) return looksLists;
    return looksLists
        .where((l) => l.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SvgPicture.asset(
                      AppImages.search,
                      width: 16,
                      color: AppColors.darkGray,
                    ),
                  ),
                  prefixStyle: const TextStyle(
                    color: AppColors.darkGray,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: Consumer<LooksListProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final List<LooksListModel> filteredLooksLists =
                      _filterLooksLists(provider.looksLists);

                  if (filteredLooksLists.isEmpty) {
                    return const Center(
                      child: Text(
                        'No looks created yet',
                        style: TextStyle(
                          color: AppColors.darkGray,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView(
                    children: [
                      ...filteredLooksLists.map((looksList) => _StyleCollection(
                            title: looksList.name,
                            itemCount: looksList.items.length,
                            images: looksList.items
                                .take(3)
                                .map((item) => item.imagePath)
                                .toList(),
                            looksListId: looksList.id,
                          )),
                      const SizedBox(height: 80),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const CreateLookButton(),
    );
  }
}

class _StyleCollection extends StatelessWidget {
  final String title;
  final int itemCount;
  final List<String> images;
  final String looksListId;

  const _StyleCollection({
    required this.title,
    required this.itemCount,
    required this.images,
    required this.looksListId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final provider = context.read<LooksListProvider>();
        provider.updateEditLooksMode(true, looksListId);
        context.push('/create-style');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                Text(
                  '$itemCount items',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: images.map((image) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    height: 91,
                    width: 113,
                    child: image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(image),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const ImagePlaceholer(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateLookButton extends StatelessWidget {
  const CreateLookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: SizedBox(
        height: 50,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.yellow,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          onPressed: () {
            context.push('/create-style');
          },
          icon: SvgPicture.asset(
            AppImages.plus,
            width: 24,
            color: AppColors.white,
          ),
          label: const Text(
            'Add new TRIP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
