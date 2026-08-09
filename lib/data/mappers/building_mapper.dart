import '../../features/admin/models/admin_building.dart';
import '../../models/building.dart';

/// Converts an admin [AdminBuilding] (Firestore `buildings/{area}/units` doc)
/// onto the public [Building] model used across the website.
///
/// The finishing status already uses the shared [FinishingStatus] enum so the
/// mapping is a straight copy with the milestones defaulted to empty.
Building adminBuildingToBuilding(AdminBuilding b) {
  return Building(
    id: b.id ?? '',
    name: b.name,
    description: b.description,
    area: b.area,
    areaSqm: b.areaSqm,
    buildingStructure: b.buildingStructure,
    orientation: b.orientation,
    layoutNote: b.layoutNote,
    startingPrice: b.startingPrice,
    totalFloors: b.totalFloors,
    totalUnits: b.totalUnits,
    availableUnits: b.availableUnits,
    finishingStatus: b.finishingStatus,
    isUnderConstruction: b.isUnderConstruction,
    deliveryDate: b.deliveryDate,
    constructionProgress: b.constructionProgress,
    milestones: const [],
    whatsappNumber: b.whatsappNumber,
    amenities: b.amenities,
    imageUrls: b.imageUrls,
    createdAt: b.createdAt,
    updatedAt: b.updatedAt,
  );
}
