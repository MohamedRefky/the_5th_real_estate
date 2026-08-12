import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/data/mappers/property_mapper.dart';
import 'package:the_5th_real_estate/features/admin/models/property.dart'
    as admin;
import 'package:the_5th_real_estate/models/apartment.dart';

admin.Property _property({
  String? id = 'doc1',
  String projectName = 'جاردنيا هايتس',
  String? buildingLabel = 'حرف ت',
  admin.UnitType unitType = admin.UnitType.apartment,
  String floor = 'أول',
  admin.PropertyOrientation? orientation = admin.PropertyOrientation.front,
  double areaSqm = 150,
  int bedrooms = 3,
  int bathrooms = 2,
  bool hasReception = true,
  bool hasKitchen = true,
  admin.PropertyFinishing finishingStatus = admin.PropertyFinishing.superLux,
  double price = 1000000,
  admin.PriceNote? priceNote = admin.PriceNote.cash,
  String? description = 'شقة فاخرة',
  List<String> imageUrls = const ['https://img/1.jpg'],
  String area = 'المستثمرين',
}) {
  return admin.Property(
    id: id,
    projectName: projectName,
    buildingLabel: buildingLabel,
    unitType: unitType,
    floor: floor,
    orientation: orientation,
    areaSqm: areaSqm,
    bedrooms: bedrooms,
    bathrooms: bathrooms,
    hasReception: hasReception,
    hasKitchen: hasKitchen,
    finishingStatus: finishingStatus,
    price: price,
    priceNote: priceNote,
    description: description,
    imageUrls: imageUrls,
    area: area,
  );
}

void main() {
  test('maps core fields onto Apartment', () {
    final apt = propertyToApartment(_property());

    expect(apt.id, 'doc1');
    expect(apt.title, 'جاردنيا هايتس — حرف ت');
    expect(apt.area, 'المستثمرين');
    expect(apt.price, 1000000);
    expect(apt.areaSqm, 150);
    expect(apt.rooms, 3);
    expect(apt.bathrooms, 2);
    expect(apt.hasSeparateKitchen, true);
    expect(apt.reception, 'ريسبشن');
    expect(apt.imageUrls, ['https://img/1.jpg']);
    expect(apt.whatsappNumber, defaultAdminWhatsapp);
  });

  test('builds title from project name only when buildingLabel is empty', () {
    final apt = propertyToApartment(_property(buildingLabel: null));
    expect(apt.title, 'جاردنيا هايتس');
  });

  test('maps unit types including building (عماره)', () {
    expect(
      propertyToApartment(_property(unitType: admin.UnitType.building)).unitType,
      UnitType.building,
    );
    expect(
      propertyToApartment(_property(unitType: admin.UnitType.duplex)).unitType,
      UnitType.duplex,
    );
    expect(
      propertyToApartment(_property(unitType: admin.UnitType.villa)).unitType,
      UnitType.villa,
    );
    expect(
      propertyToApartment(_property(unitType: admin.UnitType.studio)).unitType,
      UnitType.studio,
    );
  });

  test('maps finishing statuses', () {
    expect(
      propertyToApartment(
        _property(finishingStatus: admin.PropertyFinishing.superLux),
      ).finishingStatus,
      FinishingStatus.superLux,
    );
    expect(
      propertyToApartment(
        _property(finishingStatus: admin.PropertyFinishing.finished),
      ).finishingStatus,
      FinishingStatus.superLux,
    );
    expect(
      propertyToApartment(
        _property(finishingStatus: admin.PropertyFinishing.semi),
      ).finishingStatus,
      FinishingStatus.semiFinished,
    );
  });

  test('maps orientation', () {
    expect(
      propertyToApartment(
        _property(orientation: admin.PropertyOrientation.rear),
      ).orientation,
      ApartmentOrientation.rear,
    );
    expect(
      propertyToApartment(_property(orientation: null)).orientation,
      isNull,
    );
  });

  test('maps price notes', () {
    final meter = propertyToApartment(
      _property(priceNote: admin.PriceNote.meter),
    );
    expect(meter.priceNotes, isEmpty);
    expect(meter.priceNote, 'بالعداد');
    expect(meter.formattedPriceNotes, 'بالعداد');

    final cash = propertyToApartment(
      _property(priceNote: admin.PriceNote.cash),
    );
    expect(cash.priceNotes, isEmpty);
    expect(cash.formattedPriceNotes, 'كاش');

    expect(
      propertyToApartment(_property(priceNote: null)).formattedPriceNotes,
      isNull,
    );
  });

  test('maps floor labels to indices', () {
    final cases = {
      'بيزمنت': -1,
      'أرضي': 0,
      'أول': 1,
      'تاني': 2,
      'تالت': 3,
      'رابع': 4,
      'خامس': 5,
      'روف': 6,
      'غير معروف': 0,
    };
    cases.forEach((label, index) {
      expect(
        propertyToApartment(_property(floor: label)).floor,
        index,
        reason: 'floor label "$label"',
      );
    });
  });
}
