import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/data/public_property_repository.dart';
import 'package:the_5th_real_estate/features/area/controllers/area_controller.dart';
import 'package:the_5th_real_estate/models/filter_values.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AreaController', () {
    test('loads apartments for the area from local data', () async {
      PublicPropertyRepository.instance.invalidate();
      final c = AreaController('المستثمرين');
      expect(c.loading, true);
      await c.load();
      expect(c.loading, false);
      expect(c.filteredApartments, isNotEmpty);
      c.dispose();
    });

    test('search narrows the results and notifies listeners', () async {
      PublicPropertyRepository.instance.invalidate();
      final c = AreaController('المستثمرين');
      await c.load();
      final before = c.filteredApartments.length;

      var notified = 0;
      c.addListener(() => notified++);
      c.onSearchChanged('zzz_not_found_zzz');
      expect(c.filteredApartments, isEmpty);
      expect(notified, 1);

      c.resetFilters();
      expect(c.searchQuery, '');
      expect(c.filteredApartments.length, before);
      c.dispose();
    });

    test('applyFilters narrows results and reset restores them', () async {
      PublicPropertyRepository.instance.invalidate();
      final c = AreaController('المستثمرين');
      await c.load();
      final before = c.filteredApartments.length;

      c.applyFilters(const FilterValues(finishingStatuses: {'zzz'}));
      expect(c.filteredApartments, isEmpty);

      c.resetFilters();
      expect(c.filteredApartments.length, before);
      c.dispose();
    });
  });
}
