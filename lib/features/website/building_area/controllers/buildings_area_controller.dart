import 'package:flutter/foundation.dart';

import '../../../../data/dummy_data.dart';
import '../../../../data/filters/building_filter.dart';
import '../../../../models/building.dart';

/// Holds all list/search/status-filter state for the Buildings Area Screen.
///
/// Extracted from `BuildingsAreaScreen` so the screen only renders widgets
/// while the data flow lives here and stays unit-testable.
class BuildingsAreaController extends ChangeNotifier {
  BuildingsAreaController(this.areaName);

  final String areaName;

  List<Building> _filteredBuildings = [];
  String _searchQuery = '';
  String _selectedStatus = BuildingStatus.all;

  List<Building> get filteredBuildings => _filteredBuildings;
  String get searchQuery => _searchQuery;
  String get selectedStatus => _selectedStatus;

  /// Loads the area's buildings and applies the current filters.
  void load() {
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
    final all = DummyData.getBuildingsByArea(areaName);
    _filteredBuildings = filterBuildings(
      source: all,
      searchQuery: _searchQuery,
      status: _selectedStatus,
    );
    notifyListeners();
  }
}
