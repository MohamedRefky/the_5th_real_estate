import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/features/admin/controllers/property_form_controller.dart';
import 'package:the_5th_real_estate/features/admin/models/property.dart';

void main() {
  group('PropertyFormController', () {
    test('initializes for a new property with defaults', () {
      final c = PropertyFormController(null);
      expect(c.isEdit, false);
      expect(c.projectName.text, '');
      expect(c.unitType, UnitType.apartment);
      expect(c.floor, isNull);
      expect(c.area, areaOptions.first);
      expect(c.finishingStatus, isNull);
      expect(c.hasReception, true);
      expect(c.hasKitchen, true);
      expect(c.isPublished, true);
      c.dispose();
    });

    test('initializes for an existing property', () {
      final p = Property(
        id: 'doc1',
        projectName: 'جاردنيا',
        unitType: UnitType.villa,
        floor: 'أرضي',
        areaSqm: 200,
        bedrooms: 4,
        bathrooms: 3,
        hasReception: false,
        hasKitchen: false,
        finishingStatus: PropertyFinishing.superLux,
        price: 2500000,
        area: 'جاردينيا',
      );
      final c = PropertyFormController(p);
      expect(c.isEdit, true);
      expect(c.projectName.text, 'جاردنيا');
      expect(c.unitType, UnitType.villa);
      expect(c.floor, 'أرضي');
      expect(c.area, 'جاردينيا');
      expect(c.areaSqm.text, '200');
      expect(c.price.text, '2500000');
      expect(c.hasReception, false);
      expect(c.hasKitchen, false);
      c.dispose();
    });

    test('validators', () {
      final c = PropertyFormController(null);
      expect(c.requiredValidator(''), 'هذا الحقل مطلوب');
      expect(c.requiredValidator('x'), isNull);
      expect(c.numberValidator('abc'), isNotNull);
      expect(c.numberValidator('0'), isNotNull);
      expect(c.numberValidator('10'), isNull);
      c.dispose();
    });

    test('setters update state and notify listeners', () {
      final c = PropertyFormController(null);
      var notified = 0;
      c.addListener(() => notified++);
      c.setUnitType(UnitType.duplex);
      c.setFloor('تاني');
      c.setArea('الأندلس 1 و 2');
      c.setHasKitchen(false);
      expect(c.unitType, UnitType.duplex);
      expect(c.floor, 'تاني');
      expect(c.area, 'الأندلس 1 و 2');
      expect(c.hasKitchen, false);
      expect(notified, 4);
      c.dispose();
    });

    test('initializes image URLs text field for an existing property', () {
      final p = Property(
        id: 'x',
        projectName: 'ن',
        unitType: UnitType.apartment,
        floor: 'أرضي',
        areaSqm: 100,
        bedrooms: 1,
        bathrooms: 1,
        hasReception: true,
        hasKitchen: true,
        finishingStatus: PropertyFinishing.shell,
        price: 1000,
        imageUrls: ['https://a/1.jpg', 'https://a/2.jpg'],
      );
      final c = PropertyFormController(p);
      expect(c.imageUrls.text, 'https://a/1.jpg\nhttps://a/2.jpg');
      c.dispose();
    });
  });
}
