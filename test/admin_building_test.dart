import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/features/admin/models/admin_building.dart';
import 'package:the_5th_real_estate/models/apartment.dart';

void main() {
  group('AdminBuilding', () {
    test('toFirestore/fromFirestore round trip', () {
      final b = AdminBuilding(
        name: 'عمارة كاملة في جاردينيا',
        description: 'وصف',
        area: 'جاردينيا',
        areaSqm: 286,
        buildingStructure: 'بيزمنت + أرضي + أول',
        orientation: 'دبل فيس',
        layoutNote: 'الدور ينفع شقتين',
        startingPrice: 18500000,
        totalFloors: 3,
        totalUnits: 6,
        availableUnits: 2,
        finishingStatus: FinishingStatus.superLux,
        isUnderConstruction: true,
        deliveryDate: DateTime(2026, 6),
        constructionProgress: 0.75,
        whatsappNumber: '+201000000003',
        amenities: ['مصعد', 'حراسة'],
        imageUrls: ['a.jpg', 'b.jpg'],
        isPublished: false,
      );

      final map = b.toFirestore();
      expect(map['name'], 'عمارة كاملة في جاردينيا');
      expect(map['area'], 'جاردينيا');
      expect(map['finishingStatus'], 'superLux');
      expect(map['isPublished'], false);

      final parsed = AdminBuilding.fromFirestore('doc_1', map);
      expect(parsed.id, 'doc_1');
      expect(parsed.name, 'عمارة كاملة في جاردينيا');
      expect(parsed.area, 'جاردينيا');
      expect(parsed.areaSqm, 286);
      expect(parsed.buildingStructure, 'بيزمنت + أرضي + أول');
      expect(parsed.finishingStatus, FinishingStatus.superLux);
      expect(parsed.isUnderConstruction, true);
      expect(parsed.deliveryDate, DateTime(2026, 6));
      expect(parsed.constructionProgress, 0.75);
      expect(parsed.whatsappNumber, '+201000000003');
      expect(parsed.amenities, ['مصعد', 'حراسة']);
      expect(parsed.imageUrls, ['a.jpg', 'b.jpg']);
      expect(parsed.isPublished, false);
    });

    test('fromFirestore defaults missing fields', () {
      final parsed = AdminBuilding.fromFirestore('doc_2', {
        'name': 'x',
        'description': '',
        'area': 'المستثمرين',
        'startingPrice': 100,
        'totalFloors': 5,
        'totalUnits': 10,
        'availableUnits': 4,
        'whatsappNumber': '+20',
      });
      expect(parsed.finishingStatus, FinishingStatus.semiFinished);
      expect(parsed.isUnderConstruction, false);
      expect(parsed.isPublished, true);
      expect(parsed.constructionProgress, 1.0);
      expect(parsed.amenities, isEmpty);
      expect(parsed.deliveryDate, isNull);
    });

    test('formattedStartingPrice renders Arabic millions', () {
      expect(
        AdminBuilding(
          name: 'x',
          description: '',
          area: 'أ',
          startingPrice: 18500000,
          totalFloors: 3,
          totalUnits: 6,
          availableUnits: 2,
          finishingStatus: FinishingStatus.semiFinished,
          whatsappNumber: '+20',
        ).formattedStartingPrice,
        '18 مليون و 500 ألف جنيه',
      );
    });
  });
}
