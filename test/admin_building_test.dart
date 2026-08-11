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
      expect(map['facadeImageUrl'], 'a.jpg');
      expect(map['detailImageUrls'], ['b.jpg']);

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
      expect(parsed.imageUrls, ['https://a.jpg', 'https://b.jpg']);
      expect(parsed.facadeImageUrl, 'https://a.jpg');
      expect(parsed.detailImageUrls, ['https://b.jpg']);
      expect(parsed.isPublished, false);
    });

    test('fromFirestore parses split facade/detail image fields', () {
      final parsed = AdminBuilding.fromFirestore('doc_3', {
        'name': 'x',
        'description': '',
        'area': 'جاردينيا',
        'startingPrice': 100,
        'totalFloors': 5,
        'totalUnits': 10,
        'availableUnits': 4,
        'whatsappNumber': '+20',
        'facadeImageUrl': 'https://a/facade.jpg',
        'detailImageUrls': [
          'https://a/room1.jpg',
          'https://a/room2.jpg',
        ],
      });
      expect(parsed.imageUrls, [
        'https://a/facade.jpg',
        'https://a/room1.jpg',
        'https://a/room2.jpg',
      ]);
      expect(parsed.facadeImageUrl, 'https://a/facade.jpg');
      expect(parsed.detailImageUrls, ['https://a/room1.jpg', 'https://a/room2.jpg']);
    });

    test('fromFirestore falls back to projectName when name is missing', () {
      final parsed = AdminBuilding.fromFirestore('doc_4', {
        'projectName': 'عمارة جاردنيا هايتس 3',
        'description': 'عمارة كاملة',
        'area': 'جاردينيا',
        'price': 18500000,
        'totalFloors': 3,
        'totalUnits': 6,
        'availableUnits': 2,
        'whatsappNumber': '+20',
      });
      expect(parsed.name, 'عمارة جاردنيا هايتس 3');
      expect(parsed.description, 'عمارة كاملة');
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
