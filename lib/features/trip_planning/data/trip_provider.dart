import 'package:flutter/material.dart';
import 'package:style_keeper/features/styles/data/models/looks_list_model.dart';
import 'package:style_keeper/features/trip_planning/data/models/trip_model.dart';
import 'package:style_keeper/features/trip_planning/data/trip_db_service.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';

class TripProvider extends ChangeNotifier {
  final TripDbService _dbService;
  List<TripModel> _trips = [];
  bool _isLoading = false;
  String? _newTripName;
  String? _newTripDuration;
  String? _newTripImagePath;
  List<ClothingItem> _temporaryItems = [];
  List<LooksListModel> _temporaryCompletedLooks = [];

  // Edit mode fields
  bool editTripMode = false;
  String? tripIdToBeEdited;

  TripProvider(this._dbService);

  // Getters
  List<TripModel> get trips => _trips;
  bool get isLoading => _isLoading;
  String? get newTripName => _newTripName;
  String? get newTripDuration => _newTripDuration;
  String? get newTripImagePath => _newTripImagePath;
  List<ClothingItem> get temporaryItems => _temporaryItems;

  // Edit mode management
  void updateEditTripMode(bool value, String? tripId) {
    editTripMode = value;
    tripIdToBeEdited = tripId;
    notifyListeners();
  }

  void clearEditTripMode() {
    editTripMode = false;
    tripIdToBeEdited = null;
    notifyListeners();
  }

  // Load all trips
  Future<void> loadTrips() async {
    print("===========loadTrips===========");
    _isLoading = true;
    notifyListeners();
    try {
      _trips = await _dbService.getAllTrips();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new trip
  Future<void> createTrip() async {
    final trip = await _dbService.createTrip(
      name: _newTripName ?? '',
      duration: _newTripDuration ?? '',
      imagePath: _newTripImagePath ?? '',
      items: _temporaryItems,
      completedLooks: _temporaryCompletedLooks,
    );
    _trips = [..._trips, trip];
    clearForm();
    notifyListeners();
  }

  // Update a trip
  Future<void> updateTrip(TripModel trip) async {
    final updatedTrip = await _dbService.updateTrip(trip);
    _trips =
        _trips.map((t) => t.id == updatedTrip.id ? updatedTrip : t).toList();
    notifyListeners();
  }

  // Delete a trip
  Future<void> deleteTrip(String id) async {
    await _dbService.deleteTrip(id);
    _trips = _trips.where((t) => t.id != id).toList();
    notifyListeners();
  }

  // Form management
  void setNewTripName(String? name) {
    _newTripName = name;
    notifyListeners();
  }

  void setNewTripDuration(String? duration) {
    _newTripDuration = duration;
    notifyListeners();
  }

  void setNewTripImagePath(String? path) {
    _newTripImagePath = path;
    notifyListeners();
  }

  void addTemporaryItem(ClothingItem item) {
    _temporaryItems = [..._temporaryItems, item];
    notifyListeners();
  }

  void removeTemporaryItem(String itemId) {
    _temporaryItems =
        _temporaryItems.where((item) => item.id != itemId).toList();
    notifyListeners();
  }

  void addTemporaryCompletedLook(LooksListModel look) {
    _temporaryCompletedLooks = [..._temporaryCompletedLooks, look];
    notifyListeners();
  }

  void removeTemporaryCompletedLook(String lookId) {
    _temporaryCompletedLooks =
        _temporaryCompletedLooks.where((look) => look.id != lookId).toList();
    notifyListeners();
  }

  void clearTemporaryItems() {
    _temporaryItems = [];
    notifyListeners();
  }

  void clearTemporaryCompletedLooks() {
    _temporaryCompletedLooks = [];
    notifyListeners();
  }

  void clearForm() {
    _newTripName = null;
    _newTripDuration = null;
    _newTripImagePath = null;
    clearTemporaryItems();
    clearTemporaryCompletedLooks();
    notifyListeners();
  }
}
