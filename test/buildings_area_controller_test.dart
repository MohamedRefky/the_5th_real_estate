import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/data/filters/building_filter.dart';
import 'package:the_5th_real_estate/features/website/building_area/controllers/buildings_area_controller.dart';

void main() {
  group('BuildingsAreaController', () {
    test('loads buildings for the area', () async {
      final c = BuildingsAreaController('المستثمرين');
      await c.load();
      expect(c.filteredBuildings, isNotEmpty);
      c.dispose();
    });

    test('search narrows the results', () async {
      final c = BuildingsAreaController('المستثمرين');
      await c.load();
      final before = c.filteredBuildings.length;

      c.onSearchChanged('zzz_not_found_zzz');
      expect(c.filteredBuildings, isEmpty);

      c.onSearchChanged('');
      expect(c.filteredBuildings.length, before);
      c.dispose();
    });

    test('status pills filter and notify', () async {
      final c = BuildingsAreaController('المستثمرين');
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
