import 'package:flutter/foundation.dart';

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
    PublicBuildingRepository? repository,
  }) : _repository = repository ?? PublicBuildingRepository.instance;

  final String areaName;
  final PublicBuildingRepository _repository;

  List<Building> _allBuildings = [];
  List<Building> _filteredBuildings = [];
  bool _loading = true;
  String _searchQuery = '';
  String _selectedStatus = BuildingStatus.all;

  List<Building> get filteredBuildings => _filteredBuildings;
  bool get loading => _loading;
  String get searchQuery => _searchQuery;
  String get selectedStatus => _selectedStatus;

  /// Loads the area's buildings (Firestore + local fallback) and applies the
  /// current filters.
  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      _allBuildings = await _repository.byArea(areaName);
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

  void _applyFilter() {
    _filteredBuildings = filterBuildings(
      source: _allBuildings,
      searchQuery: _searchQuery,
      status: _selectedStatus,
    );
    notifyListeners();
  }
}
