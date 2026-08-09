import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/data/mappers/building_mapper.dart';
import 'package:the_5th_real_estate/features/admin/models/admin_building.dart';
import 'package:the_5th_real_estate/models/apartment.dart';

void main() {
  group('adminBuildingToBuilding', () {
    test('maps all core fields onto the public Building', () {
      final admin = AdminBuilding(
        id: 'bld_fire',
        name: 'عمارة المستثمرين الفاخرة',
        description: 'وصف العمارة',
        area: 'المستثمرين',
        areaSqm: 300,
        buildingStructure: 'أرضي + أول + تاني',
        orientation: 'دبل فيس',
        layoutNote: 'الدور ينفع شقتين',
        startingPrice: 3200000,
        totalFloors: 5,
        totalUnits: 10,
        availableUnits: 4,
        finishingStatus: FinishingStatus.semiFinished,
        isUnderConstruction: true,
        deliveryDate: DateTime(2026, 6),
        constructionProgress: 0.75,
        whatsappNumber: '+201000000001',
        amenities: ['مصعد', 'حراسة'],
        imageUrls: ['cover.jpg', 'gallery.jpg'],
        isPublished: true,
      );

      final b = adminBuildingToBuilding(admin);

      expect(b.id, 'bld_fire');
      expect(b.name, 'عمارة المستثمرين الفاخرة');
      expect(b.description, 'وصف العمارة');
      expect(b.area, 'المستثمرين');
      expect(b.areaSqm, 300);
      expect(b.buildingStructure, 'أرضي + أول + تاني');
      expect(b.orientation, 'دبل فيس');
      expect(b.layoutNote, 'الدور ينفع شقتين');
      expect(b.startingPrice, 3200000);
      expect(b.totalFloors, 5);
      expect(b.totalUnits, 10);
      expect(b.availableUnits, 4);
      expect(b.finishingStatus, FinishingStatus.semiFinished);
      expect(b.isUnderConstruction, true);
      expect(b.deliveryDate, DateTime(2026, 6));
      expect(b.constructionProgress, 0.75);
      expect(b.whatsappNumber, '+201000000001');
      expect(b.amenities, ['مصعد', 'حراسة']);
      expect(b.imageUrls, ['cover.jpg', 'gallery.jpg']);
      expect(b.coverImageUrl, 'cover.jpg');
    });

    test('admin-added buildings have no construction milestones', () {
      final b = adminBuildingToBuilding(
        AdminBuilding(
          name: 'x',
          description: '',
          area: 'أ',
          startingPrice: 100,
          totalFloors: 3,
          totalUnits: 6,
          availableUnits: 2,
          finishingStatus: FinishingStatus.semiFinished,
          whatsappNumber: '+20',
        ),
      );
      expect(b.milestones, isEmpty);
    });
  });
}
