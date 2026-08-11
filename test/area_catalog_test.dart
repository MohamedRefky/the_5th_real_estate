import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/features/admin/data/area_catalog.dart';
import 'package:the_5th_real_estate/features/admin/models/property.dart'
    show areaOptions;

void main() {
  test('every areaOption is present in adminAreaGroups', () {
    final catalogAreas = {
      for (final g in adminAreaGroups) ...g.areas,
    };
    for (final area in areaOptions) {
      expect(
        catalogAreas,
        contains(area),
        reason: 'المنطقة "$area" غير موجودة في adminAreaGroups',
      );
    }
  });

  test('adminAreaGroups contains no duplicate area names', () {
    final seen = <String>{};
    for (final g in adminAreaGroups) {
      for (final area in g.areas) {
        expect(seen.add(area), isTrue,
            reason: 'المنطقة "$area" مكررة في adminAreaGroups');
      }
    }
  });
}
