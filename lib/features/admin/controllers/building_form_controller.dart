import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/mappers/property_mapper.dart';
import '../../../models/apartment.dart';
import '../models/admin_building.dart';
import '../models/picked_image.dart';
import '../services/building_service.dart';
import 'image_edit_controller.dart';

/// Holds all state for the add/edit building form: text controllers, enum
/// selections, image management and the save flow.
///
/// Mirrors `PropertyFormController` but for the `buildings/{area}/units`
/// subcollections.
class BuildingFormController extends ChangeNotifier
    implements ImageEditController {
  BuildingFormController(this.building, {String? initialArea}) {
    _initialArea = initialArea;
    _init();
  }

  final AdminBuilding? building;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String? _initialArea;

  late final bool isEdit;

  // Text controllers
  late final TextEditingController name;
  late final TextEditingController description;
  late final TextEditingController areaSqm;
  late final TextEditingController buildingStructure;
  late final TextEditingController orientation;
  late final TextEditingController layoutNote;
  late final TextEditingController startingPrice;
  late final TextEditingController totalFloors;
  late final TextEditingController totalUnits;
  late final TextEditingController availableUnits;
  late final TextEditingController whatsappNumber;
  late final TextEditingController amenities;

  // Selectable state
  late String area;
  late FinishingStatus finishingStatus;
  late bool isUnderConstruction;
  DateTime? deliveryDate;
  double constructionProgress = 1.0;
  late bool isPublished;

  // Images
  late List<String> existingUrls;
  final List<String> removedUrls = [];
  @override
  final List<PickedImage> newImages = [];

  bool saving = false;

  void _init() {
    final b = building;
    isEdit = b != null && b.id != null && b.id!.isNotEmpty;

    name = TextEditingController(text: isEdit ? (b?.name ?? '') : '');
    description = TextEditingController(text: isEdit ? (b?.description ?? '') : '');
    final initialAreaSqm = b?.areaSqm;
    areaSqm = TextEditingController(
        text: (isEdit && initialAreaSqm != null) ? _fmtNum(initialAreaSqm) : '');
    buildingStructure =
        TextEditingController(text: isEdit ? (b?.buildingStructure ?? '') : '');
    orientation = TextEditingController(text: isEdit ? (b?.orientation ?? '') : '');
    layoutNote = TextEditingController(text: isEdit ? (b?.layoutNote ?? '') : '');
    startingPrice = TextEditingController(
        text: (isEdit && b != null) ? _fmtNum(b.startingPrice) : '');
    totalFloors = TextEditingController(
        text: (isEdit && b != null) ? b.totalFloors.toString() : '');
    totalUnits =
        TextEditingController(text: (isEdit && b != null) ? b.totalUnits.toString() : '');
    availableUnits = TextEditingController(
        text: (isEdit && b != null) ? b.availableUnits.toString() : '');
    whatsappNumber =
        TextEditingController(text: isEdit ? (b?.whatsappNumber ?? defaultAdminWhatsapp) : defaultAdminWhatsapp);
    amenities = TextEditingController(text: isEdit ? ((b?.amenities ?? []).join('، ')) : '');

    area = b?.area ?? _initialArea ?? 'المستثمرين';
    finishingStatus = b?.finishingStatus ?? FinishingStatus.semiFinished;
    isUnderConstruction = b?.isUnderConstruction ?? false;
    deliveryDate = b?.deliveryDate;
    constructionProgress = b?.constructionProgress ?? 1.0;
    isPublished = b?.isPublished ?? true;

    existingUrls = b?.imageUrls ?? [];
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

  String? optionalNumberValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return numberValidator(v);
  }

  // ── Field setters ──────────────────────────────────────────────────

  void setArea(String v) {
    area = v;
    notifyListeners();
  }

  void setFinishingStatus(FinishingStatus v) {
    finishingStatus = v;
    notifyListeners();
  }

  void setIsUnderConstruction(bool v) {
    isUnderConstruction = v;
    notifyListeners();
  }

  void setDeliveryDate(DateTime v) {
    deliveryDate = v;
    notifyListeners();
  }

  void clearDeliveryDate() {
    deliveryDate = null;
    notifyListeners();
  }

  void setConstructionProgress(double v) {
    constructionProgress = v;
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
      final am = amenities.text
          .split(RegExp(r'[,،]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final bld = AdminBuilding(
        id: building?.id,
        name: name.text.trim(),
        description: description.text.trim(),
        area: area,
        areaSqm: _optionalDouble(areaSqm.text),
        buildingStructure: _optionalText(buildingStructure),
        orientation: _optionalText(orientation),
        layoutNote: _optionalText(layoutNote),
        startingPrice: double.parse(startingPrice.text.trim()),
        totalFloors: int.parse(totalFloors.text.trim()),
        totalUnits: int.parse(totalUnits.text.trim()),
        availableUnits: int.parse(availableUnits.text.trim()),
        finishingStatus: finishingStatus,
        isUnderConstruction: isUnderConstruction,
        deliveryDate: deliveryDate,
        constructionProgress: constructionProgress,
        whatsappNumber: whatsappNumber.text.trim(),
        amenities: am,
        imageUrls: existingUrls,
        isPublished: isPublished,
      );

      final service = BuildingService.instance;
      if (isEdit) {
        await service.update(
          building!.id!,
          bld,
          newImages.map((i) => i.file).toList(),
          removedUrls,
        );
      } else {
        await service.create(bld, newImages.map((i) => i.file).toList());
      }
      return true;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  double? _optionalDouble(String text) {
    final val = double.tryParse(text.trim());
    return (val == null || val <= 0) ? null : val;
  }

  String? _optionalText(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    areaSqm.dispose();
    buildingStructure.dispose();
    orientation.dispose();
    layoutNote.dispose();
    startingPrice.dispose();
    totalFloors.dispose();
    totalUnits.dispose();
    availableUnits.dispose();
    whatsappNumber.dispose();
    amenities.dispose();
    super.dispose();
  }
}
