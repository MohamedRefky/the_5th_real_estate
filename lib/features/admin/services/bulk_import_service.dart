import 'dart:convert';

import '../models/admin_building.dart';
import '../models/property.dart';
import 'building_service.dart';
import 'property_service.dart';

class BulkImportReport<T> {
  final List<T> validItems;
  final List<String> errors;
  final int totalParsed;

  const BulkImportReport({
    required this.validItems,
    required this.errors,
    required this.totalParsed,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get isValid => validItems.isNotEmpty;
}

class BulkImportService {
  BulkImportService._();
  static final BulkImportService instance = BulkImportService._();

  /// Parse and validate JSON string for Properties (Apartments / Units).
  BulkImportReport<Property> parsePropertiesJson(String rawJson) {
    final validItems = <Property>[];
    final errors = <String>[];
    int totalParsed = 0;

    dynamic jsonObject;
    try {
      jsonObject = jsonDecode(rawJson);
    } catch (e) {
      return BulkImportReport(
        validItems: [],
        errors: ['كود JSON غير صالح: $e'],
        totalParsed: 0,
      );
    }

    final List list = jsonObject is List ? jsonObject : [jsonObject];
    totalParsed = list.length;

    for (int index = 0; index < list.length; index++) {
      final item = list[index];
      final itemNum = index + 1;

      if (item is! Map) {
        errors.add('العنصر رقم $itemNum ليس كائن JSON (Map)');
        continue;
      }

      final Map<String, dynamic> map = Map<String, dynamic>.from(item);

      // Validate projectName
      final name = (map['projectName'] as String?)?.trim() ??
          (map['name'] as String?)?.trim() ??
          (map['title'] as String?)?.trim();
      if (name == null || name.isEmpty) {
        errors.add('العنصر رقم $itemNum: حقل اسم المشروع أو الشقة (projectName) مطلوب');
        continue;
      }

      // Validate area
      final area = (map['area'] as String?)?.trim() ??
          (map['neighborhood'] as String?)?.trim();
      if (area == null || area.isEmpty) {
        errors.add('العنصر رقم $itemNum ($name): حقل المنطقة / الحي (area) مطلوب');
        continue;
      }

      // Validate price
      final priceNum = (map['price'] as num?) ??
          (map['startingPrice'] as num?) ??
          (map['totalPrice'] as num?);
      if (priceNum == null || priceNum <= 0) {
        errors.add('العنصر رقم $itemNum ($name): السعر (price) مطلوب ويجب أن يكون أكبر من 0');
        continue;
      }

      try {
        final property = Property.fromFirestore(
          'bulk_$index',
          map,
          fallbackArea: area,
        );
        validItems.add(property);
      } catch (e) {
        errors.add('العنصر رقم $itemNum ($name): خطأ في تحويل البيانات: $e');
      }
    }

    return BulkImportReport(
      validItems: validItems,
      errors: errors,
      totalParsed: totalParsed,
    );
  }

  /// Parse and validate JSON string for Buildings (العمارات).
  BulkImportReport<AdminBuilding> parseBuildingsJson(String rawJson) {
    final validItems = <AdminBuilding>[];
    final errors = <String>[];
    int totalParsed = 0;

    dynamic jsonObject;
    try {
      jsonObject = jsonDecode(rawJson);
    } catch (e) {
      return BulkImportReport(
        validItems: [],
        errors: ['كود JSON غير صالح: $e'],
        totalParsed: 0,
      );
    }

    final List list = jsonObject is List ? jsonObject : [jsonObject];
    totalParsed = list.length;

    for (int index = 0; index < list.length; index++) {
      final item = list[index];
      final itemNum = index + 1;

      if (item is! Map) {
        errors.add('العنصر رقم $itemNum ليس كائن JSON (Map)');
        continue;
      }

      final Map<String, dynamic> map = Map<String, dynamic>.from(item);

      final name = (map['name'] as String?)?.trim() ??
          (map['projectName'] as String?)?.trim();
      if (name == null || name.isEmpty) {
        errors.add('العنصر رقم $itemNum: حقل اسم العمارة (name) مطلوب');
        continue;
      }

      final area = (map['area'] as String?)?.trim();
      if (area == null || area.isEmpty) {
        errors.add('العنصر رقم $itemNum ($name): حقل المنطقة / الحي (area) مطلوب');
        continue;
      }

      final priceNum = (map['startingPrice'] as num?) ??
          (map['price'] as num?);
      if (priceNum == null || priceNum <= 0) {
        errors.add('العنصر رقم $itemNum ($name): السعر الابتدائي (startingPrice) مطلوب');
        continue;
      }

      try {
        final building = AdminBuilding.fromFirestore(
          'bulk_$index',
          map,
          fallbackArea: area,
        );
        validItems.add(building);
      } catch (e) {
        errors.add('العنصر رقم $itemNum ($name): خطأ في تحويل البيانات: $e');
      }
    }

    return BulkImportReport(
      validItems: validItems,
      errors: errors,
      totalParsed: totalParsed,
    );
  }

  /// Bulk import Properties into Firestore.
  ///
  /// When [overrideArea] is provided every item is stored inside that area's
  /// folder (`properties/{area}/units`) regardless of its own `area` field.
  /// Pass null to keep each item's own area (default behavior).
  Future<void> uploadPropertiesInBulk(
    List<Property> properties, {
    String? overrideArea,
    void Function(int current, int total)? onProgress,
  }) async {
    final total = properties.length;
    for (int i = 0; i < total; i++) {
      final item = properties[i];
      final target = overrideArea != null && overrideArea.trim().isNotEmpty
          ? item.copyWith(area: overrideArea.trim())
          : item;
      await PropertyService.instance.create(target);
      if (onProgress != null) {
        onProgress(i + 1, total);
      }
    }
  }

  /// Bulk import Buildings into Firestore.
  ///
  /// When [overrideArea] is provided every item is stored inside that area's
  /// folder (`buildings/{area}/units`) regardless of its own `area` field.
  /// Pass null to keep each item's own area (default behavior).
  Future<void> uploadBuildingsInBulk(
    List<AdminBuilding> buildings, {
    String? overrideArea,
    void Function(int current, int total)? onProgress,
  }) async {
    final total = buildings.length;
    for (int i = 0; i < total; i++) {
      final item = buildings[i];
      final target = overrideArea != null && overrideArea.trim().isNotEmpty
          ? item.copyWith(area: overrideArea.trim())
          : item;
      await BuildingService.instance.create(target, []);
      if (onProgress != null) {
        onProgress(i + 1, total);
      }
    }
  }
}
