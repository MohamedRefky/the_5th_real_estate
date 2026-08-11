import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/data/filters/building_filter.dart';
import 'package:the_5th_real_estate/data/public_building_repository.dart';
import 'package:the_5th_real_estate/features/website/building_area/controllers/buildings_area_controller.dart';
import 'package:the_5th_real_estate/models/apartment.dart';
import 'package:the_5th_real_estate/models/building.dart';

class _FakeBuildingRepository extends PublicBuildingRepository {
  final List<Building> buildings;

  _FakeBuildingRepository(this.buildings);

  @override
  Future<List<Building>> byArea(String area) async {
    return buildings.where((b) => b.area == area).toList();
  }
}

Building _bldg(
  String id, {
  String area = 'المستثمرين',
  String name = 'عمارة',
  bool underConstruction = false,
}) {
  return Building(
    id: id,
    name: name,
    description: 'وصف',
    area: area,
    startingPrice: 8000000,
    totalFloors: 5,
    totalUnits: 10,
    availableUnits: 2,
    finishingStatus: FinishingStatus.superLux,
    isUnderConstruction: underConstruction,
    whatsappNumber: '+201000000000',
  );
}

void main() {
  group('BuildingsAreaController', () {
    test('loads buildings for the area', () async {
      final repo = _FakeBuildingRepository([
        _bldg('b1'),
        _bldg('b2', area: 'جاردينيا'),
      ]);
      final c = BuildingsAreaController('المستثمرين', repository: repo);
      await c.load();
      expect(c.filteredBuildings, isNotEmpty);
      c.dispose();
    });

    test('search narrows the results', () async {
      final repo = _FakeBuildingRepository([
        _bldg('b1'),
        _bldg('b2', name: 'عمارة في جاردينيا'),
      ]);
      final c = BuildingsAreaController('المستثمرين', repository: repo);
      await c.load();
      final before = c.filteredBuildings.length;

      c.onSearchChanged('zzz_not_found_zzz');
      expect(c.filteredBuildings, isEmpty);

      c.onSearchChanged('');
      expect(c.filteredBuildings.length, before);
      c.dispose();
    });

    test('status pills filter and notify', () async {
      final repo = _FakeBuildingRepository([
        _bldg('b1'),
        _bldg('b2', underConstruction: true),
      ]);
      final c = BuildingsAreaController('المستثمرين', repository: repo);
      await c.load();
      final total = c.filteredBuildings.length;
      var notified = 0;
      c.addListener(() => notified++);

      c.selectStatus(BuildingStatus.underConstruction);
      expect(c.selectedStatus, BuildingStatus.underConstruction);
      expect(c.filteredBuildings.every((b) => b.isUnderConstruction), true);
      expect(notified, 1);

      c.selectStatus(BuildingStatus.all);
      expect(c.filteredBuildings.length, total);
      c.dispose();
    });
  });
}
