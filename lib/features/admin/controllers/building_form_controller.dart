import 'package:flutter/material.dart';

import '../../../core/utils/image_url_helper.dart';
import '../../../models/apartment.dart';
import '../models/admin_building.dart';
import '../services/building_service.dart';

/// Streamlined BuildingFormController:
/// Manages Name, Area, Description (containing price, area, details), Media URLs, and Published status.
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
  late final TextEditingController mainImageUrl;
  final List<TextEditingController> extraImageControllers = [];
  late final TextEditingController videoUrl;

  // Selectable state
  late String area;

  bool saving = false;

  void _init() {
    final b = building;
    isEdit = b != null && b.id != null && b.id!.isNotEmpty;

    name = TextEditingController(text: isEdit ? (b?.name ?? '') : '');
    description = TextEditingController(text: isEdit ? (b?.description ?? '') : '');
    final allImages = b?.imageUrls ?? const <String>[];
    mainImageUrl = TextEditingController(
        text: isEdit && allImages.isNotEmpty ? allImages.first : '');
    if (isEdit && allImages.length > 1) {
      for (final url in allImages.sublist(1)) {
        extraImageControllers.add(TextEditingController(text: url));
      }
    }
    videoUrl = TextEditingController(text: isEdit ? (b?.videoUrl ?? '') : '');

    area = b?.area ?? _initialArea ?? 'المستثمرين';
  }

  // ── Validators ─────────────────────────────────────────────────────

  String? requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;

  // ── Field setters ──────────────────────────────────────────────────

  void setArea(String? v) {
    if (v != null) {
      area = v;
      notifyListeners();
    }
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
      final parsedVideoUrl =
          videoUrl.text.trim().isEmpty ? null : videoUrl.text.trim();

      final bld = AdminBuilding(
        id: building?.id,
        name: name.text.trim(),
        description: description.text.trim(),
        area: area,
        areaSqm: null,
        startingPrice: 0,
        totalFloors: 1,
        totalUnits: 1,
        availableUnits: 1,
        finishingStatus: FinishingStatus.semiFinished,
        amenities: const [],
        imageUrls: parsedImageUrls,
        videoUrl: parsedVideoUrl,
        isPublished: true,
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

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    mainImageUrl.dispose();
    for (final ctrl in extraImageControllers) {
      ctrl.dispose();
    }
    videoUrl.dispose();
    super.dispose();
  }
}
