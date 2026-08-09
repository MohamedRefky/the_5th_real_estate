import 'apartment.dart';

/// Holds the current apartment filter values.
///
/// Pure data — no Flutter dependency — so filtering logic can live outside
/// the UI layer.
class FilterValues {
  /// Default price bounds used when no price filter is active.
  static const double defaultMinPrice = 0;
  static const double defaultMaxPrice = 10000000;

  final double minPrice;
  final double maxPrice;
  final Set<UnitType> unitTypes;
  final Set<int> floors;
  final Set<String> finishingStatuses;
  final Set<ApartmentOrientation> orientations;
  final Set<int> rooms;
  final Set<int> bathrooms;
  final Set<(double, double)> areaRanges;

  const FilterValues({
    this.minPrice = defaultMinPrice,
    this.maxPrice = defaultMaxPrice,
    this.unitTypes = const {},
    this.floors = const {},
    this.finishingStatuses = const {},
    this.orientations = const {},
    this.rooms = const {},
    this.bathrooms = const {},
    this.areaRanges = const {},
  });
}
