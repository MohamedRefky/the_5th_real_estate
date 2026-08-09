import 'package:flutter/foundation.dart';

import '../../../data/filters/apartment_filter.dart';
import '../../../data/public_property_repository.dart';
import '../../../models/apartment.dart';
import '../../../models/filter_values.dart';

/// Holds all list/search/filter state for the Area Screen.
///
/// Extracted from `AreaScreen` so the screen only renders widgets while the
/// data flow lives here and stays unit-testable.
class AreaController extends ChangeNotifier {
  AreaController(
    this.areaName, {
    PublicPropertyRepository? repository,
  }) : _repository = repository ?? PublicPropertyRepository.instance;

  final String areaName;
  final PublicPropertyRepository _repository;

  List<Apartment> _allApartments = [];
  List<Apartment> _filteredApartments = [];
  String _searchQuery = '';
  bool _loading = true;

  List<Apartment> get filteredApartments => _filteredApartments;
  String get searchQuery => _searchQuery;
  bool get loading => _loading;

  /// Loads the area's apartments (local + published Firestore).
  Future<void> load() async {
    final all = await _repository.byArea(areaName);
    _allApartments = all;
    _filteredApartments = filterApartments(
      source: all,
      filters: const FilterValues(),
      searchQuery: _searchQuery,
    );
    _loading = false;
    notifyListeners();
  }

  /// Re-runs filtering with the given filter values.
  void applyFilters(FilterValues filters) {
    _filteredApartments = filterApartments(
      source: _allApartments,
      filters: filters,
      searchQuery: _searchQuery,
    );
    notifyListeners();
  }

  /// Search bar input; re-applies the default filters (matches prior screen).
  void onSearchChanged(String value) {
    _searchQuery = value;
    applyFilters(const FilterValues());
  }

  /// Clears the search query and resets filters to defaults.
  void resetFilters() {
    _searchQuery = '';
    applyFilters(const FilterValues());
  }
}
