import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/data/filters/building_filter.dart';
import 'package:the_5th_real_estate/models/apartment.dart';
import 'package:the_5th_real_estate/models/building.dart';

Building _makeBuilding(
  String id, {
  required String name,
  String description = '',
  bool underConstruction = false,
}) {
  return Building(
    id: id,
    name: name,
    description: description,
    area: 'الأندلس',
    startingPrice: 1000000,
    totalFloors: 5,
    totalUnits: 10,
    availableUnits: 3,
    finishingStatus: FinishingStatus.superLux,
    isUnderConstruction: underConstruction,
    whatsappNumber: '+201000000001',
  );
}

void main() {
  final buildings = [
    _makeBuilding('1', name: 'برج النخيل', description: 'مشروع فاخر في الأندلس'),
    _makeBuilding(
      '2',
      name: 'برج البحر',
      description: 'under construction on the cornich',
      underConstruction: true,
    ),
    _makeBuilding('3', name: 'فيلا الورد', description: 'جاهز للتسليم بالحى الرابع'),
  ];

  group('filterBuildings', () {
    test('returns all when no filters are applied', () {
      final result = filterBuildings(source: buildings);
      expect(result.length, 3);
    });

    test('filters by search query on name', () {
      final result = filterBuildings(source: buildings, searchQuery: 'النخيل');
      expect(result.length, 1);
      expect(result.first.name, 'برج النخيل');
    });

    test('filters by search query on description', () {
      final result = filterBuildings(source: buildings, searchQuery: 'cornich');
      expect(result.length, 1);
      expect(result.first.name, 'برج البحر');
    });

    test('is case-insensitive', () {
      final result = filterBuildings(source: buildings, searchQuery: 'CORNICH');
      expect(result.length, 1);
      expect(result.first.name, 'برج البحر');
    });

    test('returns empty when nothing matches', () {
      final result =
          filterBuildings(source: buildings, searchQuery: 'zzz_not_found_zzz');
      expect(result, isEmpty);
    });

    test('filters by ready-for-delivery status', () {
      final result = filterBuildings(
        source: buildings,
        status: BuildingStatus.ready,
      );
      expect(result.length, 2);
      expect(result.every((b) => !b.isUnderConstruction), true);
    });

    test('filters by under-construction status', () {
      final result = filterBuildings(
        source: buildings,
        status: BuildingStatus.underConstruction,
      );
      expect(result.length, 1);
      expect(result.first.name, 'برج البحر');
    });

    test('combines search and status filters', () {
      final result = filterBuildings(
        source: buildings,
        searchQuery: 'برج',
        status: BuildingStatus.ready,
      );
      expect(result.length, 1);
      expect(result.first.name, 'برج النخيل');

      final underConstruction = filterBuildings(
        source: buildings,
        searchQuery: 'برج',
        status: BuildingStatus.underConstruction,
      );
      expect(underConstruction.length, 1);
      expect(underConstruction.first.name, 'برج البحر');
    });
  });
}
