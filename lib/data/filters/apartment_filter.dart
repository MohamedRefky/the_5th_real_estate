import '../../models/apartment.dart';
import '../../models/filter_values.dart';

/// Pure filtering logic for apartment listings.
///
/// Extracted from the Area Screen so filtering lives in the logic layer and
/// stays unit-testable without Flutter.
List<Apartment> filterApartments({
  required List<Apartment> source,
  required FilterValues filters,
  String searchQuery = '',
}) {
  return source.where((apt) {
    // Search query keyword filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      final titleMatch = apt.title.toLowerCase().contains(query);
      final descMatch = apt.description.toLowerCase().contains(query);
      if (!titleMatch && !descMatch) return false;
    }

    // Price range
    if (apt.price < filters.minPrice || apt.price > filters.maxPrice) {
      return false;
    }
    // Floor
    if (filters.floors.isNotEmpty && !filters.floors.contains(apt.floor)) {
      return false;
    }
    // Finishing status
    if (filters.finishingStatuses.isNotEmpty &&
        !filters.finishingStatuses.contains(apt.finishingStatus.name)) {
      return false;
    }
    // Orientation (أمامي، خلفي، جانبي)
    if (filters.orientations.isNotEmpty &&
        (apt.orientation == null ||
            !filters.orientations.contains(apt.orientation))) {
      return false;
    }
    // Rooms
    if (filters.rooms.isNotEmpty && !filters.rooms.contains(apt.rooms)) {
      return false;
    }
    // Bathrooms
    if (filters.bathrooms.isNotEmpty &&
        !filters.bathrooms.contains(apt.bathrooms)) {
      return false;
    }
    // Area (sqm) — matches any of the selected ranges.
    if (filters.areaRanges.isNotEmpty) {
      final matchesArea = filters.areaRanges
          .any((r) => apt.areaSqm >= r.$1 && apt.areaSqm <= r.$2);
      if (!matchesArea) return false;
    }
    return true;
  }).toList();
}
