import '../models/apartment.dart';
import '../models/building.dart';

/// Neighborhood constants. All apartment and building data is loaded live
/// from Firebase Firestore; dummy mock data lists are empty.
class DummyData {
  DummyData._();

  /// All available neighborhood names.
  static const List<String> areas = [
    'المستثمرين',
    'الأندلس',
    'جاردينيا',
    'بيت الوطن',
    'النرجس الجديدة',
  ];

  /// Mock building listings (empty — only Firestore data is loaded).
  static final List<Building> buildings = const [];

  /// Mock apartment listings (empty — only Firestore data is loaded).
  static final List<Apartment> apartments = const [];

  static List<Apartment> getByArea(String area) => const [];
  static List<Building> getBuildingsByArea(String area) => const [];
  static Apartment? getById(String id) => null;
  static Building? getBuildingById(String id) => null;
}
