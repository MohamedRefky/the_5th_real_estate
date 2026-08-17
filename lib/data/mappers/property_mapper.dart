import '../../features/admin/models/property.dart'
    as admin show Property, PropertyFinishing, PropertyOrientation, UnitType;
import '../../models/apartment.dart';

/// Converts an admin `Property` (Firestore `properties` doc) onto the public
/// [Apartment] model used across the website.
///
/// Extracted from `PublicPropertyRepository` so the mapping is a pure,
/// testable function living in the data layer.
Apartment propertyToApartment(admin.Property p) {
  return Apartment(
    id: p.id ?? '',
    title: p.projectName,
    description:
        p.description ?? '${p.projectName} — ${p.unitType.label} ${p.floor}',
    freeDescription: null,
    area: p.area,
    unitType: _unitType(p.unitType),
    price: p.price,
    priceNote: p.priceNote?.label,
    priceNotes: const {},
    floor: _floorIndex(p.floor),
    floorString: p.floor,
    totalFloors: null,
    areaSqm: p.areaSqm,
    rooms: p.bedrooms,
    bathrooms: p.bathrooms,
    reception: p.hasReception ? 'ريسبشن' : 'بدون ريسبشن',
    hasSeparateKitchen: p.hasKitchen,
    finishingStatus: _finishing(p.finishingStatus),
    orientation: _orientation(p.orientation),
    isUnderConstruction: false,
    imageUrls: p.imageUrls,
    videoUrl: p.videoUrl,
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

FinishingStatus _finishing(admin.PropertyFinishing f) {
  switch (f.label) {
    case 'سوبر لوكس':
    case 'تشطيب كامل':
      return FinishingStatus.superLux;
    case 'نص تشطيب':
    case 'نصف تشطيب':
    case '٣_٤ تشطيب':
      return FinishingStatus.semiFinished;
    case 'بدون تشطيب':
    case 'تحت الإنشاء':
      return FinishingStatus.underConstruction;
    default:
      return FinishingStatus.semiFinished;
  }
}

ApartmentOrientation? _orientation(admin.PropertyOrientation? o) {
  if (o == null) return null;
  for (final e in ApartmentOrientation.values) {
    if (e.label == o.label) return e;
  }
  return null;
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
