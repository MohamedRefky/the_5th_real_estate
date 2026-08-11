import '../models/apartment.dart';
import '../models/building.dart';

/// Neighborhood constants. All apartment and building data is loaded live
/// from Firebase Firestore; dummy mock data lists are empty.
class DummyData {
  DummyData._();

  /// All available neighborhood names.
  static const List<String> areas = [
    'المستثمرين',
    'الأندلس 1 و 2',
    'الأندلس عائلي',
    'جاردينيا',
    'بيت الوطن',
    'النرجس الجديدة',
    'النرجس عمارات',
    'النرجس فيلات',
    'البنفسج عمارات',
    'البنفسج فيلات',
    'الياسمين الزوجي فيلات',
    'الياسمين الفردي فيلات',
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

/// Neighborhoods shown as their own cards in the "عمارات" section.
const List<String> buildingMainAreas = [
  'المستثمرين',
  'الأندلس 1 و 2',
  'الأندلس عائلي',
  'جاردينيا',
  'بيت الوطن',
  'النرجس الجديدة',
];

/// Remaining neighborhoods grouped under the "أحياء أخرى متنوعة" card.
const List<String> buildingOtherAreas = [
  'النرجس عمارات',
  'النرجس فيلات',
  'البنفسج عمارات',
  'البنفسج فيلات',
  'الياسمين الزوجي فيلات',
  'الياسمين الفردي فيلات',
];

/// Label for the combined "other areas" box in the buildings section.
const String buildingOtherAreasLabel = 'أحياء أخرى متنوعة';
