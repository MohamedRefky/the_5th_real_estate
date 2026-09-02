import 'package:flutter/material.dart';

import '../../../../data/filters/building_filter.dart';
import '../../../../data/public_building_repository.dart';
import '../../../../models/building.dart';

/// Holds all list/search/status-filter state for the Buildings Area Screen.
///
/// Extracted from `BuildingsAreaScreen` so the screen only renders widgets
/// while the data flow lives here and stays unit-testable.
class BuildingsAreaController extends ChangeNotifier {
  BuildingsAreaController(
    this.areaName, {
    this.areas,
    PublicBuildingRepository? repository,
  }) : _repository = repository ?? PublicBuildingRepository.instance;

  final String areaName;

  /// When set, loads buildings across all these areas (combined box).
  final List<String>? areas;
  final PublicBuildingRepository _repository;

  List<Building> _allBuildings = [];
  List<Building> _filteredBuildings = [];
  bool _loading = true;
  String _searchQuery = '';
  String _selectedStatus = BuildingStatus.all;
  RangeValues _priceRange = const RangeValues(0, 40000000);

  List<Building> get filteredBuildings => _filteredBuildings;
  bool get loading => _loading;
  String get searchQuery => _searchQuery;
  String get selectedStatus => _selectedStatus;
  RangeValues get priceRange => _priceRange;

  /// Loads the area's buildings (Firestore + local fallback) and applies the
  /// current filters.
  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      final targetAreas = areas;
      if (targetAreas != null) {
        final results = await Future.wait(
          targetAreas.map((a) => _repository.byArea(a)),
        );
        final seen = <String>{};
        _allBuildings = [
          for (final list in results)
            for (final b in list)
              if (seen.add(b.id)) b,
        ];
      } else {
        _allBuildings = await _repository.byArea(areaName);
      }
    } finally {
      _loading = false;
    }
    _applyFilter();
  }

  /// Search bar input.
  void onSearchChanged(String value) {
    _searchQuery = value;
    _applyFilter();
  }

  /// Selects a status pill (الكل / جاهز للتسليم / تحت الإنشاء).
  void selectStatus(String status) {
    _selectedStatus = status;
    _applyFilter();
  }

  /// Sets price range (0 to 40,000,000).
  void setPriceRange(RangeValues values) {
    _priceRange = values;
    _applyFilter();
  }

  /// Resets all filters.
  void resetFilters() {
    _searchQuery = '';
    _selectedStatus = BuildingStatus.all;
    _priceRange = const RangeValues(0, 40000000);
    _applyFilter();
  }

  void _applyFilter() {
    _filteredBuildings = filterBuildings(
      source: _allBuildings,
      searchQuery: _searchQuery,
      status: _selectedStatus,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
    );
    notifyListeners();
  }
}
