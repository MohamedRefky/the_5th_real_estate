import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/data/public_property_repository.dart';
import 'package:the_5th_real_estate/features/website/area/controllers/area_controller.dart';
import 'package:the_5th_real_estate/models/apartment.dart';
import 'package:the_5th_real_estate/models/filter_values.dart';

class _FakePropertyRepository extends PublicPropertyRepository {
  final List<Apartment> apartments;

  _FakePropertyRepository(this.apartments);

  @override
  Future<List<Apartment>> byArea(String area, {bool forceRefresh = true}) async {
    return apartments
        .where((apt) =>
            apt.area == area ||
            (apt.area == 'الأندلس' && area == 'الأندلس 1 و 2'))
        .toList();
  }
}

Apartment _apt(String id, {String area = 'المستثمرين', String title = 'شقة'}) {
  return Apartment(
    id: id,
    title: title,
    description: 'وصف',
    area: area,
    price: 2000000,
    floor: 0,
    totalFloors: 4,
    areaSqm: 140,
    rooms: 3,
    bathrooms: 2,
    finishingStatus: FinishingStatus.superLux,
    whatsappNumber: '+201000000000',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AreaController', () {
    test('loads apartments for the area from local data', () async {
      final repo = _FakePropertyRepository([
        _apt('a1'),
        _apt('a2', area: 'جاردينيا', title: 'شقة أخرى'),
      ]);
      final c = AreaController('المستثمرين', repository: repo);
      expect(c.loading, true);
      await c.load();
      expect(c.loading, false);
      expect(c.filteredApartments, isNotEmpty);
      c.dispose();
    });

    test('search narrows the results and notifies listeners', () async {
      final repo = _FakePropertyRepository([
        _apt('a1'),
        _apt('a2', title: 'شقة للبيع في المستثمرين'),
      ]);
      final c = AreaController('المستثمرين', repository: repo);
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
      final repo = _FakePropertyRepository([
        _apt('a1'),
        _apt('a2', title: 'شقة للبيع في المستثمرين'),
      ]);
      final c = AreaController('المستثمرين', repository: repo);
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
