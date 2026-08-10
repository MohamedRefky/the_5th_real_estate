import 'package:flutter/material.dart';

import '../../../core/utils/image_url_helper.dart';
import '../../../data/mappers/property_mapper.dart';
import '../../../models/apartment.dart';
import '../models/admin_building.dart';
import '../services/building_service.dart';

/// Holds all state for the streamlined add/edit building form:
/// Name, Area, Price, AreaSqm, Description, Media URLs, and Published status.
class BuildingFormController extends ChangeNotifier {
  BuildingFormController(this.building, {String? initialArea}) {
    _initialArea = initialArea;
    _init();
  }

  final AdminBuilding? building;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? _initialArea;

  late final bool isEdit;

  // Text controllers
  late final TextEditingController name;
  late final TextEditingController description;
  late final TextEditingController areaSqm;
  late final TextEditingController startingPrice;
  late final TextEditingController imageUrls;
  late final TextEditingController videoUrl;

  // Selectable state
  late String area;
  late bool isPublished;

  bool saving = false;

  void _init() {
    final b = building;
    isEdit = b != null && b.id != null && b.id!.isNotEmpty;

    name = TextEditingController(text: isEdit ? (b?.name ?? '') : '');
    description = TextEditingController(text: isEdit ? (b?.description ?? '') : '');
    final initialAreaSqm = b?.areaSqm;
    areaSqm = TextEditingController(
        text: (isEdit && initialAreaSqm != null) ? _fmtNum(initialAreaSqm) : '');
    startingPrice = TextEditingController(
        text: (isEdit && b != null) ? _fmtNum(b.startingPrice) : '');
    imageUrls = TextEditingController(
        text: isEdit ? (b?.imageUrls.join('\n') ?? '') : '');
    videoUrl = TextEditingController(text: isEdit ? (b?.videoUrl ?? '') : '');

    area = b?.area ?? _initialArea ?? 'المستثمرين';
    isPublished = b?.isPublished ?? true;
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

  String? optionalNumberValidator(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return numberValidator(v);
  }

  // ── Field setters ──────────────────────────────────────────────────

  void setArea(String? v) {
    if (v != null) {
      area = v;
      notifyListeners();
    }
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
      final parsedImageUrls = imageUrls.text
          .split(RegExp(r'[\n,]'))
          .map((s) => sanitizeImageUrl(s.trim()))
          .where((s) => s.isNotEmpty)
          .toList();
      final parsedVideoUrl =
          videoUrl.text.trim().isEmpty ? null : videoUrl.text.trim();

      final bld = AdminBuilding(
        id: building?.id,
        name: name.text.trim(),
        description: description.text.trim(),
        area: area,
        areaSqm: _optionalDouble(areaSqm.text),
        startingPrice: double.parse(startingPrice.text.trim()),
        totalFloors: 1,
        totalUnits: 1,
        availableUnits: 1,
        finishingStatus: FinishingStatus.semiFinished,
        whatsappNumber: defaultAdminWhatsapp,
        amenities: const [],
        imageUrls: parsedImageUrls,
        videoUrl: parsedVideoUrl,
        isPublished: isPublished,
      );

      final service = BuildingService.instance;
      if (isEdit) {
        await service.update(
          building!.id!,
          bld,
          const [],
          const [],
        );
      } else {
        await service.create(bld, const []);
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

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    areaSqm.dispose();
    startingPrice.dispose();
    imageUrls.dispose();
    videoUrl.dispose();
    super.dispose();
  }
}
