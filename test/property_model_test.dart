import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/features/admin/models/property.dart';

void main() {
  group('Property', () {
    test('facadeImageUrl/detailImageUrls derive from imageUrls', () {
      final p = Property(
        projectName: 'شقة',
        unitType: UnitType.apartment,
        floor: 'أول',
        areaSqm: 120,
        bedrooms: 2,
        bathrooms: 2,
        hasReception: true,
        hasKitchen: true,
        finishingStatus: PropertyFinishing.semi,
        price: 1200000,
        imageUrls: ['https://a/facade.jpg', 'https://a/r1.jpg', 'https://a/r2.jpg'],
      );

      expect(p.facadeImageUrl, 'https://a/facade.jpg');
      expect(p.detailImageUrls, ['https://a/r1.jpg', 'https://a/r2.jpg']);
    });

    test('toFirestore stores facade and detail images in separate fields', () {
      final p = Property(
        projectName: 'شقة',
        unitType: UnitType.apartment,
        floor: 'أول',
        areaSqm: 120,
        bedrooms: 2,
        bathrooms: 2,
        hasReception: true,
        hasKitchen: true,
        finishingStatus: PropertyFinishing.semi,
        price: 1200000,
        imageUrls: ['https://a/facade.jpg', 'https://a/r1.jpg', 'https://a/r2.jpg'],
      );

      final map = p.toFirestore();
      expect(map['imageUrls'], [
        'https://a/facade.jpg',
        'https://a/r1.jpg',
        'https://a/r2.jpg',
      ]);
      expect(map['facadeImageUrl'], 'https://a/facade.jpg');
      expect(map['detailImageUrls'], ['https://a/r1.jpg', 'https://a/r2.jpg']);
      expect(map['imageUrl'], 'https://a/facade.jpg');
    });

    test('fromFirestore reads facade before details (website cover order)', () {
      final p = Property.fromFirestore('doc_1', {
        'projectName': 'شقة',
        'area': 'الأندلس 1 و 2',
        'facadeImageUrl': 'https://a/facade.jpg',
        'detailImageUrls': ['https://a/r1.jpg', 'https://a/r2.jpg'],
        'price': 1000000,
      });

      expect(p.imageUrls, ['https://a/facade.jpg', 'https://a/r1.jpg', 'https://a/r2.jpg']);
      expect(p.facadeImageUrl, 'https://a/facade.jpg');
      expect(p.detailImageUrls, ['https://a/r1.jpg', 'https://a/r2.jpg']);
    });

    test('fromFirestore handles legacy combined imageUrls plus split fields', () {
      final p = Property.fromFirestore('doc_2', {
        'projectName': 'شقة',
        'area': 'جاردينيا',
        'imageUrls': ['https://a/r1.jpg', 'https://a/r2.jpg'],
        'facadeImageUrl': 'https://a/facade.jpg',
        'price': 1000000,
      });

      expect(p.imageUrls, ['https://a/facade.jpg', 'https://a/r1.jpg', 'https://a/r2.jpg']);
    });
  });
}
