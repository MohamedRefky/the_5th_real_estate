import '../../models/building.dart';

/// Status labels used by the buildings area screen.
class BuildingStatus {
  BuildingStatus._();

  static const String all = 'الكل';
  static const String ready = 'جاهز للتسليم';
  static const String underConstruction = 'تحت الإنشاء';
}

/// Pure filtering logic for building listings.
///
/// Extracted from the Buildings Area Screen so filtering lives in the logic
/// layer and stays unit-testable without Flutter.
List<Building> filterBuildings({
  required List<Building> source,
  String searchQuery = '',
  String status = BuildingStatus.all,
}) {
  return source.where((bld) {
    // Search query keyword filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      final nameMatch = bld.name.toLowerCase().contains(query);
      final descMatch = bld.description.toLowerCase().contains(query);
      if (!nameMatch && !descMatch) return false;
    }

    // Status filter
    if (status == BuildingStatus.underConstruction && !bld.isUnderConstruction) {
      return false;
    }
    if (status == BuildingStatus.ready && bld.isUnderConstruction) {
      return false;
    }
    return true;
  }).toList();
}
