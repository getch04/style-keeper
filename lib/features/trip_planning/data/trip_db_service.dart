import 'package:hive/hive.dart';
import 'package:style_keeper/features/trip_planning/data/models/trip_model.dart';
import 'package:style_keeper/features/wardrobe/data/models/clothing_item.dart';
import 'package:uuid/uuid.dart';

class TripDbService {
  static const String _boxName = 'trips';
  late Box<TripModel> _box;
  final _uuid = const Uuid();

  Future<void> init() async {
    _box = await Hive.openBox<TripModel>(_boxName);
  }

  // Create a new trip
  Future<TripModel> createTrip({
    required String name,
    required String duration,
    required String imagePath,
    List<ClothingItem> items = const [],
  }) async {
    final now = DateTime.now();
    final trip = TripModel(
      id: _uuid.v4(),
      name: name,
      duration: duration,
      imagePath: imagePath,
      items: items,
      createdAt: now,
      updatedAt: now,
    );
    await _box.put(trip.id, trip);
    return trip;
  }

  // Get all trips
  Future<List<TripModel>> getAllTrips() async {
    print("===========getAllTrips===========");
    print(_box.values.toList());
    return _box.values.toList();
  }

  // Get a trip by ID
  Future<TripModel?> getTrip(String id) async {
    return _box.get(id);
  }

  // Update a trip
  Future<TripModel> updateTrip(TripModel trip) async {
    final updatedTrip = trip.copyWith(updatedAt: DateTime.now());
    await _box.put(updatedTrip.id, updatedTrip);
    return updatedTrip;
  }

  // Delete a trip
  Future<void> deleteTrip(String id) async {
    await _box.delete(id);
  }
}
