import '../../features/admin/models/property.dart'
    as admin show PriceNote, Property, PropertyFinishing, PropertyOrientation, UnitType;
import '../../models/apartment.dart';

/// Converts an admin `Property` (Firestore `properties` doc) onto the public
/// [Apartment] model used across the website.
///
/// Extracted from `PublicPropertyRepository` so the mapping is a pure,
/// testable function living in the data layer.
Apartment propertyToApartment(admin.Property p) {
  return Apartment(
    id: p.id ?? '',
    title: p.buildingLabel != null && p.buildingLabel!.isNotEmpty
        ? '${p.projectName} — ${p.buildingLabel}'
        : p.projectName,
    description:
        p.description ?? '${p.projectName} — ${p.unitType.label} ${p.floor}',
    freeDescription: p.description,
    area: p.area,
    unitType: _unitType(p.unitType),
    price: p.price,
    priceNotes: p.priceNote == null ? const {} : {_priceNote(p.priceNote!)},
    floor: _floorIndex(p.floor),
    totalFloors: 1,
    areaSqm: p.areaSqm,
    rooms: p.bedrooms,
    bathrooms: p.bathrooms,
    reception: p.hasReception ? 'ريسبشن' : 'بدون ريسبشن',
    hasSeparateKitchen: p.hasKitchen,
    finishingStatus: _finishing(p.finishingStatus),
    orientation: _orientation(p.orientation),
    isUnderConstruction: false,
    whatsappNumber: defaultAdminWhatsapp,
    imageUrls: p.imageUrls,
    amenities: const [],
    createdAt: p.createdAt,
    updatedAt: p.updatedAt,
  );
}

/// WhatsApp number used for admin-added listings (editable later).
const String defaultAdminWhatsapp = '+201000000001';

UnitType _unitType(admin.UnitType t) {
  for (final e in UnitType.values) {
    if (e.label == t.label) return e;
  }
  if (t.label == 'عماره') return UnitType.building;
  return UnitType.apartment;
}

PriceNote _priceNote(admin.PriceNote n) {
  for (final e in PriceNote.values) {
    if (e.label == n.label) return e;
  }
  if (n.label == 'بالعداد') return PriceNote.installment;
  return PriceNote.cash;
}

FinishingStatus _finishing(admin.PropertyFinishing f) {
  switch (f.label) {
    case 'سوبر لوكس':
    case 'تشطيب كامل':
      return FinishingStatus.superLux;
    case 'نص تشطيب':
    case '٣_٤ تشطيب':
      return FinishingStatus.semiFinished;
    default:
      return FinishingStatus.semiFinished;
  }
}

ApartmentOrientation _orientation(admin.PropertyOrientation? o) {
  for (final e in ApartmentOrientation.values) {
    if (e.label == o?.label) return e;
  }
  return ApartmentOrientation.front;
}

int _floorIndex(String floor) {
  switch (floor) {
    case 'بيزمنت':
      return -1;
    case 'أرضي':
      return 0;
    case 'أول':
      return 1;
    case 'تاني':
      return 2;
    case 'تالت':
      return 3;
    case 'رابع':
      return 4;
    case 'خامس':
      return 5;
    case 'روف':
      return 6;
    default:
      return 0;
  }
}
