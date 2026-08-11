import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/property_form_controller.dart';
import '../models/property.dart';
import '../widgets/property_form_widgets.dart';

/// Add / edit a unit (apartment, villa, duplex or studio). Used by the
/// dashboard's "إضافة عقار" flow and the edit button on each unit card.
///
/// [initialUnitType] comes from the dashboard type chooser so new units are
/// created as the right kind without a manual type pick.
///
/// All form state + save logic lives in [PropertyFormController]; this screen
/// only composes the shared form widgets.
class PropertyFormScreen extends StatefulWidget {
  final Property? property;
  final UnitType? initialUnitType;
  final String? initialArea;

  const PropertyFormScreen({
    super.key,
    this.property,
    this.initialUnitType,
    this.initialArea,
  });

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  late final PropertyFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PropertyFormController(
      widget.property,
      initialUnitType: widget.initialUnitType,
      initialArea: widget.initialArea,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    try {
      final ok = await _controller.save();
      if (!mounted) return;
      if (ok) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل الحفظ: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Unit types selectable in the units form. Buildings have their own form
  /// and collection, so they are excluded — except when editing a legacy doc
  /// that was originally stored as a building.
  List<UnitType> _unitTypeOptions(UnitType current) {
    final options = [
      for (final t in UnitType.values)
        if (t != UnitType.building) t,
    ];
    if (current == UnitType.building) options.add(UnitType.building);
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => Text(
            _controller.isEdit ? 'تعديل العقار' : 'إضافة عقار',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Form(
                key: _controller.formKey,
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    final c = _controller;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FormSectionTitle('بيانات أساسية'),
                        FormTextField(
                          c.projectName,
                          'اسم المشروع',
                          validator: c.requiredValidator,
                        ),
                        const SizedBox(height: 12),
                        FormDropdown<String>(
                          label: 'الحي/المنطقة',
                          value: c.area,
                          items: areaOptions,
                          labelOf: (v) => v,
                          onChanged: c.setArea,
                        ),
                        const SizedBox(height: 12),
                        FormTextField(c.buildingLabel, 'رقم العمارة (اختياري)'),
                        const SizedBox(height: 20),
                        const FormSectionTitle('تفاصيل الوحدة'),
                        const SizedBox(height: 12),
                        FormDropdown<UnitType>(
                          label: 'نوع الوحدة',
                          value: c.unitType,
                          items: _unitTypeOptions(c.unitType),
                          labelOf: (v) => v.label,
                          onChanged: c.setUnitType,
                        ),
                        const SizedBox(height: 12),
                        FormDropdown<String?>(
                          label: 'الدور',
                          value: c.floor,
                          items: floorOptions,
                          labelOf: (v) => v ?? '',
                          hint: 'اختر الدور...',
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'يرجى اختيار الدور'
                              : null,
                          onChanged: c.setFloor,
                        ),
                        const SizedBox(height: 12),
                        FormDropdown<PropertyOrientation?>(
                          label: 'الاتجاه (اختياري)',
                          value: c.orientation,
                          items: PropertyOrientation.values,
                          labelOf: (v) => v?.label ?? 'بدون',
                          hint: 'بدون',
                          onChanged: c.setOrientation,
                        ),
                        const SizedBox(height: 12),
                        FormDropdown<PropertyFinishing?>(
                          label: 'التشطيب',
                          value: c.finishingStatus,
                          items: PropertyFinishing.values,
                          labelOf: (v) => v?.label ?? '',
                          hint: 'اختر حالة التشطيب...',
                          validator: (v) =>
                              v == null ? 'يرجى اختيار حالة التشطيب' : null,
                          onChanged: c.setFinishingStatus,
                        ),
                        const SizedBox(height: 12),
                        FormDropdown<PriceNote?>(
                          label: 'نوع السعر (اختياري)',
                          value: c.priceNote,
                          items: PriceNote.values,
                          labelOf: (v) => v?.label ?? 'بدون',
                          hint: 'بدون',
                          onChanged: c.setPriceNote,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FormTextField(
                                c.areaSqm,
                                'المساحة (م²)',
                                keyboardType: TextInputType.number,
                                validator: c.numberValidator,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FormTextField(
                                c.bedrooms,
                                'عدد الغرف',
                                keyboardType: TextInputType.number,
                                validator: c.numberValidator,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FormTextField(
                          c.bathrooms,
                          'عدد الحمامات',
                          keyboardType: TextInputType.number,
                          validator: c.numberValidator,
                        ),
                        const SizedBox(height: 12),
                        PriceInputField(
                          controller: c.price,
                          label: 'السعر بالجنيه',
                          validator: c.numberValidator,
                        ),
                        const SizedBox(height: 12),
                        UsdPriceInputField(
                          controller: c.priceUsd,
                          validator: c.optionalNumberValidator,
                        ),
                        const SizedBox(height: 16),
                        FormSwitchRow(
                          label: 'يوجد ريسبشن',
                          value: c.hasReception,
                          onChanged: c.setHasReception,
                        ),
                        FormSwitchRow(
                          label: 'يوجد مطبخ',
                          value: c.hasKitchen,
                          onChanged: c.setHasKitchen,
                        ),
                        const SizedBox(height: 20),
                        const FormSectionTitle('الوصف والوسائط'),
                        const SizedBox(height: 12),
                        FormTextField(
                          c.description,
                          'وصف إضافي (اختياري)',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        FormTextField(
                          c.mainImageUrl,
                          'رابط صورة الواجهة الرئيسية (صورة الغلاف)',
                          prefixIcon: Icons.photo_size_select_actual_rounded,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'صور التفاصيل الإضافية (اختياري)',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: c.addExtraImageField,
                              icon: const Icon(Icons.add_photo_alternate_rounded,
                                  size: 18),
                              label: const Text('إضافة صورة'),
                            ),
                          ],
                        ),
                        if (c.extraImageControllers.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              'اضغط على "+ إضافة صورة" لإضافة صورة تفاصيل للشقة.',
                              style: TextStyle(
                                  color: AppColors.textHint, fontSize: 12),
                            ),
                          ),
                        for (int i = 0;
                            i < c.extraImageControllers.length;
                            i++) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: FormTextField(
                                  c.extraImageControllers[i],
                                  'رابط صورة التفاصيل (${i + 1})',
                                  prefixIcon: Icons.collections_rounded,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip: 'حذف الصورة',
                                icon: const Icon(Icons.delete_outline_rounded,
                                    color: AppColors.error),
                                onPressed: () => c.removeExtraImageField(i),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        FormTextField(
                          c.videoUrl,
                          'رابط فيديو المعاينة (اختياري)',
                          prefixIcon: Icons.video_library_rounded,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final saving = _controller.saving;
          return Container(
            color: AppColors.surface,
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: FilledButton(
                onPressed: saving ? null : _handleSave,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textOnPrimary,
                        ),
                      )
                    : Text(
                        _controller.isEdit ? 'حفظ التعديلات' : 'إضافة العقار',
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
