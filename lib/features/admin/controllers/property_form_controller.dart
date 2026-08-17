import 'package:flutter/material.dart';

import '../../../core/utils/image_url_helper.dart';
import '../models/property.dart';
import '../services/property_service.dart';

/// Holds all state for the add/edit unit form: text controllers, enum
/// selections, URL inputs and the save flow.
class PropertyFormController extends ChangeNotifier {
  PropertyFormController(
    this.property, {
    UnitType? initialUnitType,
    String? initialArea,
  }) {
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
  late final TextEditingController areaSqm;
  late final TextEditingController bedrooms;
  late final TextEditingController bathrooms;
  late final TextEditingController price;
  late final TextEditingController priceUsd;
  late final TextEditingController description;
  late final TextEditingController mainImageUrl;
  final List<TextEditingController> extraImageControllers = [];
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

    projectName = TextEditingController(
      text: isEdit ? (p?.projectName ?? '') : '',
    );
    areaSqm = TextEditingController(
      text: (isEdit && p != null) ? _fmtNum(p.areaSqm) : '',
    );
    bedrooms = TextEditingController(
      text: (isEdit && p != null) ? p.bedrooms.toString() : '',
    );
    bathrooms = TextEditingController(
      text: (isEdit && p != null) ? p.bathrooms.toString() : '',
    );
    price = TextEditingController(
      text: (isEdit && p != null) ? _fmtNum(p.price) : '',
    );
    priceUsd = TextEditingController(
      text: (isEdit && p != null && p.priceUsd != null)
          ? _fmtNum(p.priceUsd!)
          : '',
    );
    description = TextEditingController(
      text: isEdit ? (p?.description ?? '') : '',
    );

    final allImages = p?.imageUrls ?? const <String>[];
    mainImageUrl = TextEditingController(
      text: isEdit && allImages.isNotEmpty ? allImages.first : '',
    );
    if (isEdit && allImages.length > 1) {
      for (final url in allImages.sublist(1)) {
        extraImageControllers.add(TextEditingController(text: url));
      }
    }
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

  double? _parseOptionalDouble(String text) {
    final val = _safeParseDouble(text, -1);
    if (val <= 0) return null;
    return val;
  }

  double _safeParseDouble(String text, [double fallback = 0.0]) {
    var s = text.trim();
    if (s.isEmpty) return fallback;
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < 10; i++) {
      s = s.replaceAll(eastern[i], western[i]);
    }
    s = s.replaceAll(',', '').replaceAll(' ', '');
    return double.tryParse(s) ?? fallback;
  }

  int _safeParseInt(String text, [int fallback = 0]) {
    return _safeParseDouble(text, fallback.toDouble()).round();
  }

  // ── Validators ─────────────────────────────────────────────────────

  String? requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;

  String? numberValidator(String? v, {bool allowZero = false}) {
    final val = double.tryParse(v ?? '');
    if (val == null) return 'أدخل رقماً صحيحاً';
    if (!allowZero && val <= 0) return 'أدخل رقماً أكبر من صفر';
    return null;
  }

  /// Allows an empty value but still validates numbers when filled.
  String? optionalNumberValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return numberValidator(v);
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

  void addExtraImageField([String initialText = '']) {
    extraImageControllers.add(TextEditingController(text: initialText));
    notifyListeners();
  }

  void removeExtraImageField(int index) {
    if (index >= 0 && index < extraImageControllers.length) {
      extraImageControllers[index].dispose();
      extraImageControllers.removeAt(index);
      notifyListeners();
    }
  }

  // ── Save ───────────────────────────────────────────────────────────

  /// Validates and saves. Returns true on success; rethrows on failure.
  Future<bool> save() async {
    if (!formKey.currentState!.validate()) return false;
    saving = true;
    notifyListeners();
    try {
      final mainUrl = sanitizeImageUrl(mainImageUrl.text.trim());
      final extraUrls = extraImageControllers
          .map((ctrl) => sanitizeImageUrl(ctrl.text.trim()))
          .where((s) => s.isNotEmpty)
          .toList();
      final parsedImageUrls = <String>[
        if (mainUrl.isNotEmpty) mainUrl,
        ...extraUrls,
      ];
      final parsedVideoUrl = videoUrl.text.trim().isEmpty
          ? null
          : videoUrl.text.trim();

      final prop = Property(
        id: property?.id,
        projectName: projectName.text.trim(),
        unitType: unitType,
        floor: floor ?? 'أرضي',
        area: area,
        orientation: orientation,
        areaSqm: _safeParseDouble(areaSqm.text),
        bedrooms: _safeParseInt(bedrooms.text),
        bathrooms: _safeParseInt(bathrooms.text),
        hasReception: hasReception,
        hasKitchen: hasKitchen,
        finishingStatus: finishingStatus ?? PropertyFinishing.shell,
        price: _safeParseDouble(price.text),
        priceNote: priceNote,
        priceUsd: _parseOptionalDouble(priceUsd.text),
        description: description.text.trim().isEmpty
            ? null
            : description.text.trim(),
        imageUrls: parsedImageUrls,
        videoUrl: parsedVideoUrl,
        isPublished: isPublished,
      );

      final service = PropertyService.instance;
      if (isEdit && property?.id != null && property!.id!.isNotEmpty) {
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
    areaSqm.dispose();
    bedrooms.dispose();
    bathrooms.dispose();
    price.dispose();
    priceUsd.dispose();
    description.dispose();
    mainImageUrl.dispose();
    for (final ctrl in extraImageControllers) {
      ctrl.dispose();
    }
    videoUrl.dispose();
    super.dispose();
  }
}
