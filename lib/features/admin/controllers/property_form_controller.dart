import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/picked_image.dart';
import '../models/property.dart';
import '../services/property_service.dart';
import 'image_edit_controller.dart';

/// Holds all state for the add/edit unit form: text controllers, enum
/// selections, image management and the save flow.
///
/// Extracted from `PropertyFormScreen` so the form logic is testable and the
/// screen only composes widgets.
class PropertyFormController extends ChangeNotifier
    implements ImageEditController {
  PropertyFormController(this.property, {UnitType? initialUnitType}) {
    _initialUnitType = initialUnitType;
    _init();
  }

  final Property? property;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  UnitType? _initialUnitType;

  late final bool isEdit;

  // Text controllers
  late final TextEditingController projectName;
  late final TextEditingController buildingLabel;
  late final TextEditingController areaSqm;
  late final TextEditingController bedrooms;
  late final TextEditingController bathrooms;
  late final TextEditingController price;
  late final TextEditingController description;

  // Enum/selectable state
  late UnitType unitType;
  late String floor;
  late String area;
  PropertyOrientation? orientation;
  late PropertyFinishing finishingStatus;
  PriceNote? priceNote;
  late bool hasReception;
  late bool hasKitchen;
  late bool isPublished;

  // Images
  late List<String> existingUrls;
  final List<String> removedUrls = [];
  @override
  final List<PickedImage> newImages = [];

  bool saving = false;

  void _init() {
    final p = property;
    isEdit = p != null;

    projectName = TextEditingController(text: p?.projectName ?? '');
    buildingLabel = TextEditingController(text: p?.buildingLabel ?? '');
    areaSqm = TextEditingController(text: p != null ? _fmtNum(p.areaSqm) : '');
    bedrooms = TextEditingController(
        text: p != null ? p.bedrooms.toString() : '');
    bathrooms = TextEditingController(
        text: p != null ? p.bathrooms.toString() : '');
    price = TextEditingController(text: p != null ? _fmtNum(p.price) : '');
    description = TextEditingController(text: p?.description ?? '');

    unitType = p?.unitType ?? _initialUnitType ?? UnitType.apartment;
    floor = p?.floor ?? floorOptions[1];
    area = p?.area ?? areaOptions.first;
    orientation = p?.orientation;
    finishingStatus = p?.finishingStatus ?? PropertyFinishing.shell;
    priceNote = p?.priceNote;
    hasReception = p?.hasReception ?? true;
    hasKitchen = p?.hasKitchen ?? true;
    isPublished = p?.isPublished ?? true;

    existingUrls = p?.imageUrls ?? [];
  }

  String _fmtNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  // ── Derived ────────────────────────────────────────────────────────

  @override
  List<String> get visibleExistingUrls =>
      existingUrls.where((u) => !removedUrls.contains(u)).toList();

  int get visibleImageCount => visibleExistingUrls.length + newImages.length;

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

  void setUnitType(UnitType v) {
    unitType = v;
    notifyListeners();
  }

  void setFloor(String v) {
    floor = v;
    notifyListeners();
  }

  void setArea(String v) {
    area = v;
    notifyListeners();
  }

  void setOrientation(PropertyOrientation? v) {
    orientation = v;
    notifyListeners();
  }

  void setFinishingStatus(PropertyFinishing v) {
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

  // ── Images ─────────────────────────────────────────────────────────

  @override
  Future<void> pickImages() async {
    final picked = await _picker.pickMultiImage(limit: 10 - newImages.length);
    if (picked.isEmpty) return;
    final loaded = <PickedImage>[];
    for (final file in picked) {
      loaded.add(PickedImage(file, await file.readAsBytes()));
    }
    newImages.addAll(loaded);
    notifyListeners();
  }

  @override
  void removeExisting(String url) {
    removedUrls.add(url);
    notifyListeners();
  }

  @override
  void removeNew(PickedImage image) {
    newImages.remove(image);
    notifyListeners();
  }

  // ── Save ───────────────────────────────────────────────────────────

  /// Validates and saves. Returns true on success; rethrows on failure.
  Future<bool> save() async {
    if (!formKey.currentState!.validate()) return false;
    saving = true;
    notifyListeners();
    try {
      final prop = Property(
        id: property?.id,
        projectName: projectName.text.trim(),
        buildingLabel: buildingLabel.text.trim().isEmpty
            ? null
            : buildingLabel.text.trim(),
        unitType: unitType,
        floor: floor,
        area: area,
        orientation: orientation,
        areaSqm: double.parse(areaSqm.text.trim()),
        bedrooms: int.parse(bedrooms.text.trim()),
        bathrooms: int.parse(bathrooms.text.trim()),
        hasReception: hasReception,
        hasKitchen: hasKitchen,
        finishingStatus: finishingStatus,
        price: double.parse(price.text.trim()),
        priceNote: priceNote,
        description: description.text.trim().isEmpty
            ? null
            : description.text.trim(),
        imageUrls: existingUrls,
        isPublished: isPublished,
      );

      final service = PropertyService.instance;
      if (isEdit) {
        await service.update(
          property!.id!,
          prop,
          newImages.map((i) => i.file).toList(),
          removedUrls,
        );
      } else {
        await service.create(
          prop,
          newImages.map((i) => i.file).toList(),
        );
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
    super.dispose();
  }
}
