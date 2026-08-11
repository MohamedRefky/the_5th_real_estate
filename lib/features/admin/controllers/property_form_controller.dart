import 'package:flutter/material.dart';

import '../../../core/utils/image_url_helper.dart';
import '../models/property.dart';
import '../services/property_service.dart';

/// Holds all state for the add/edit unit form: text controllers, enum
/// selections, URL inputs and the save flow.
class PropertyFormController extends ChangeNotifier {
  PropertyFormController(this.property,
      {UnitType? initialUnitType, String? initialArea}) {
    _initialUnitType = initialUnitType;
    _initialArea = initialArea;
    _init();
  }

  final Property? property;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  UnitType? _initialUnitType;
  String? _initialArea;

  late final bool isEdit;

  // Text controllers
  late final TextEditingController projectName;
  late final TextEditingController buildingLabel;
  late final TextEditingController areaSqm;
  late final TextEditingController bedrooms;
  late final TextEditingController bathrooms;
  late final TextEditingController price;
  late final TextEditingController description;
  late final TextEditingController mainImageUrl;
  late final TextEditingController additionalImageUrls;
  late final TextEditingController videoUrl;

  // Enum/selectable state
  late UnitType unitType;
  String? floor;
  late String area;
  PropertyOrientation? orientation;
  PropertyFinishing? finishingStatus;
  PriceNote? priceNote;
  late bool hasReception;
  late bool hasKitchen;
  late bool isPublished;

  bool saving = false;

  void _init() {
    final p = property;
    isEdit = p != null && p.id != null && p.id!.isNotEmpty;

    projectName = TextEditingController(text: isEdit ? (p?.projectName ?? '') : '');
    buildingLabel = TextEditingController(text: isEdit ? (p?.buildingLabel ?? '') : '');
    areaSqm = TextEditingController(
        text: (isEdit && p != null) ? _fmtNum(p.areaSqm) : '');
    bedrooms = TextEditingController(
        text: (isEdit && p != null) ? p.bedrooms.toString() : '');
    bathrooms = TextEditingController(
        text: (isEdit && p != null) ? p.bathrooms.toString() : '');
    price = TextEditingController(
        text: (isEdit && p != null) ? _fmtNum(p.price) : '');
    description = TextEditingController(text: isEdit ? (p?.description ?? '') : '');
    
    final allImages = p?.imageUrls ?? const <String>[];
    mainImageUrl = TextEditingController(
        text: isEdit && allImages.isNotEmpty ? allImages.first : '');
    additionalImageUrls = TextEditingController(
        text: isEdit && allImages.length > 1 ? allImages.sublist(1).join('\n') : '');
    videoUrl = TextEditingController(text: isEdit ? (p?.videoUrl ?? '') : '');

    unitType = p?.unitType ?? _initialUnitType ?? UnitType.apartment;
    floor = isEdit ? p?.floor : null;
    area = p?.area ?? _initialArea ?? areaOptions.first;
    orientation = p?.orientation;
    finishingStatus = isEdit ? p?.finishingStatus : null;
    priceNote = p?.priceNote;
    hasReception = p?.hasReception ?? true;
    hasKitchen = p?.hasKitchen ?? true;
    isPublished = p?.isPublished ?? true;
  }

  String _fmtNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  // ── Validators ─────────────────────────────────────────────────────

  String? requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;

  String? numberValidator(String? v, {bool allowZero = false}) {
    final val = double.tryParse(v ?? '');
    if (val == null) return 'أدخل رقماً صحيحاً';
    if (!allowZero && val <= 0) return 'أدخل رقماً أكبر من صفر';
    return null;
  }

  // ── Field setters ──────────────────────────────────────────────────

  void setUnitType(UnitType? v) {
    if (v != null) {
      unitType = v;
      notifyListeners();
    }
  }

  void setFloor(String? v) {
    floor = v;
    notifyListeners();
  }

  void setArea(String? v) {
    if (v != null) {
      area = v;
      notifyListeners();
    }
  }

  void setOrientation(PropertyOrientation? v) {
    orientation = v;
    notifyListeners();
  }

  void setFinishingStatus(PropertyFinishing? v) {
    finishingStatus = v;
    notifyListeners();
  }

  void setPriceNote(PriceNote? v) {
    priceNote = v;
    notifyListeners();
  }

  void setHasReception(bool v) {
    hasReception = v;
    notifyListeners();
  }

  void setHasKitchen(bool v) {
    hasKitchen = v;
    notifyListeners();
  }

  void setIsPublished(bool v) {
    isPublished = v;
    notifyListeners();
  }

  // ── Save ───────────────────────────────────────────────────────────

  /// Validates and saves. Returns true on success; rethrows on failure.
  Future<bool> save() async {
    if (!formKey.currentState!.validate()) return false;
    saving = true;
    notifyListeners();
    try {
      final mainUrl = sanitizeImageUrl(mainImageUrl.text.trim());
      final extraUrls = additionalImageUrls.text
          .split(RegExp(r'[\n,]'))
          .map((s) => sanitizeImageUrl(s.trim()))
          .where((s) => s.isNotEmpty)
          .toList();
      final parsedImageUrls = <String>[
        if (mainUrl.isNotEmpty) mainUrl,
        ...extraUrls,
      ];
      final parsedVideoUrl =
          videoUrl.text.trim().isEmpty ? null : videoUrl.text.trim();

      final prop = Property(
        id: property?.id,
        projectName: projectName.text.trim(),
        buildingLabel: buildingLabel.text.trim().isEmpty
            ? null
            : buildingLabel.text.trim(),
        unitType: unitType,
        floor: floor ?? 'أرضي',
        area: area,
        orientation: orientation,
        areaSqm: double.parse(areaSqm.text.trim()),
        bedrooms: int.parse(bedrooms.text.trim()),
        bathrooms: int.parse(bathrooms.text.trim()),
        hasReception: hasReception,
        hasKitchen: hasKitchen,
        finishingStatus: finishingStatus ?? PropertyFinishing.shell,
        price: double.parse(price.text.trim()),
        priceNote: priceNote,
        description: description.text.trim().isEmpty
            ? null
            : description.text.trim(),
        imageUrls: parsedImageUrls,
        videoUrl: parsedVideoUrl,
        isPublished: isPublished,
      );

      final service = PropertyService.instance;
      if (isEdit) {
        await service.update(property!.id!, prop);
      } else {
        await service.create(prop);
      }
      return true;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    projectName.dispose();
    buildingLabel.dispose();
    areaSqm.dispose();
    bedrooms.dispose();
    bathrooms.dispose();
    price.dispose();
    description.dispose();
    mainImageUrl.dispose();
    additionalImageUrls.dispose();
    videoUrl.dispose();
    super.dispose();
  }
}
