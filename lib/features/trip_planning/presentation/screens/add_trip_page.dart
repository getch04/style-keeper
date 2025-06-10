import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:style_keeper/core/constants/app_colors.dart';
import 'package:style_keeper/core/constants/app_images.dart';
import 'package:style_keeper/features/trip_planning/data/models/trip_model.dart';
import 'package:style_keeper/features/trip_planning/data/trip_provider.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:style_keeper/features/wardrobe/presentation/widgets/choose_items_bottom_sheet.dart';
import 'package:style_keeper/shared/widgets/add_photo_section.dart';

class AddTripPage extends StatefulWidget {
  static const String name = 'add-trip';
  const AddTripPage({super.key});

  @override
  State<AddTripPage> createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  bool _isSaving = false;
  bool _isInitialized = false;
  List<ClothingItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    final provider = context.read<TripProvider>();
    if (provider.newTripName != null) {
      _nameController.text = provider.newTripName!;
    }
    if (provider.newTripDuration != null) {
      _durationController.text = provider.newTripDuration!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final provider = context.read<TripProvider>();
        // Always check for imagePath in GoRouter extra
        final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
        if (extra != null) {
          final imagePath = extra['imagePath'] as String?;
          if (imagePath != null) {
            provider.setNewTripImagePath(imagePath);
          }
        }
        // Prepopulate if in edit mode
        if (provider.editTripMode && provider.tripIdToBeEdited != null) {
          TripModel? trip;
          try {
            trip = provider.trips
                .firstWhere((t) => t.id == provider.tripIdToBeEdited);
          } catch (_) {
            trip = null;
          }
          if (trip != null) {
            _nameController.text = trip.name;
            _durationController.text = trip.duration;
            provider.setNewTripName(trip.name);
            provider.setNewTripDuration(trip.duration);
            provider.setNewTripImagePath(trip.imagePath);
            provider.clearTemporaryItems();
            for (final item in trip.items) {
              provider.addTemporaryItem(item);
            }
            _selectedItems = List<ClothingItem>.from(trip.items);
          }
        }
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveTrip() async {
    if (_nameController.text.isEmpty || _durationController.text.isEmpty)
      return;
    setState(() => _isSaving = true);
    try {
      final provider = context.read<TripProvider>();
      provider.setNewTripName(_nameController.text);
      provider.setNewTripDuration(_durationController.text);
      if (provider.editTripMode && provider.tripIdToBeEdited != null) {
        // Update existing trip
        TripModel? trip;
        try {
          trip = provider.trips
              .firstWhere((t) => t.id == provider.tripIdToBeEdited);
        } catch (_) {
          trip = null;
        }
        if (trip != null) {
          final updatedTrip = trip.copyWith(
            name: _nameController.text,
            duration: _durationController.text,
            imagePath: provider.newTripImagePath ?? trip.imagePath,
            items: _selectedItems,
            updatedAt: DateTime.now(),
          );
          await provider.updateTrip(updatedTrip);
        }
        provider.clearEditTripMode();
      } else {
        // Create new trip
        await provider.createTrip();
      }
      provider.clearForm();
      if (mounted) {
        context.go('/wardrobe');
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      const SizedBox(height: 20),
                      provider.newTripImagePath == null
                          ? const AddPhotoSection(returnTo: AddTripPage.name)
                          : Container(
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
                                        File(provider.newTripImagePath!),
                                        height: 180,
                                        width: 180,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    GestureDetector(
                                      onTap: () {
                                        provider.setNewTripImagePath(null);
                                      },
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            _buildInput(_nameController, 'List name',
                                onChanged: provider.setNewTripName),
                            const SizedBox(height: 16),
                            _buildInput(_durationController, 'Trip duration',
                                onChanged: provider.setNewTripDuration),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'List items:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result = await showModalBottomSheet<
                                    List<ClothingItem>>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.9,
                                    child: const ChooseItemsBottomSheet(),
                                  ),
                                );
                                if (result != null && result.isNotEmpty) {
                                  setState(() {
                                    _selectedItems = result;
                                  });
                                  // Also update provider's temporaryItems for compatibility
                                  final provider = context.read<TripProvider>();
                                  provider.clearTemporaryItems();
                                  for (final item in result) {
                                    provider.addTemporaryItem(item);
                                  }
                                }
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text(
                                'Add items',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellow,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No items added yet',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ..._selectedItems.map((item) => _TripItemTile(
                            item: item,
                            onDelete: () {
                              setState(() {
                                _selectedItems
                                    .removeWhere((i) => i.id == item.id);
                              });
                              final provider = context.read<TripProvider>();
                              provider.removeTemporaryItem(item.id);
                            },
                          )),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: Colors.white,
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
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save and continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput(TextEditingController controller, String hint,
      {Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: Colors.black,
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFBDBDBD),
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// Trip item tile for displaying selected items
class _TripItemTile extends StatelessWidget {
  final ClothingItem item;
  final VoidCallback onDelete;
  const _TripItemTile({required this.item, required this.onDelete});

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
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset(
                    AppImages.delete,
                    color: Colors.white,
                  ),
                ),
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
                    color: Colors.black,
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
        ],
      ),
    );
  }
}
