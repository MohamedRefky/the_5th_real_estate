import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/property_form_controller.dart';
import '../models/property.dart';
import '../widgets/property_form_widgets.dart';
import '../widgets/property_images_editor.dart';

/// Add / edit a property. Used by the dashboard's "إضافة عقار" FAB and the
/// edit button on each card.
///
/// All form state + save logic lives in [PropertyFormController]; this screen
/// only composes the shared form widgets.
class PropertyFormScreen extends StatefulWidget {
  final Property? property;

  const PropertyFormScreen({super.key, this.property});

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  late final PropertyFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PropertyFormController(widget.property);
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
                          items: UnitType.values,
                          labelOf: (v) => v.label,
                          onChanged: c.setUnitType,
                        ),
                        const SizedBox(height: 12),
                        FormDropdown<String>(
                          label: 'الدور',
                          value: c.floor,
                          items: floorOptions,
                          labelOf: (v) => v,
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
                        FormDropdown<PropertyFinishing>(
                          label: 'التشطيب',
                          value: c.finishingStatus,
                          items: PropertyFinishing.values,
                          labelOf: (v) => v.label,
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
                        Row(
                          children: [
                            Expanded(
                              child: FormTextField(
                                c.bathrooms,
                                'عدد الحمامات',
                                keyboardType: TextInputType.number,
                                validator: c.numberValidator,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FormTextField(
                                c.price,
                                'السعر (ج.م)',
                                keyboardType: TextInputType.number,
                                validator: c.numberValidator,
                              ),
                            ),
                          ],
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
                        FormSwitchRow(
                          label: 'منشور على الموقع',
                          value: c.isPublished,
                          onChanged: c.setIsPublished,
                        ),
                        const SizedBox(height: 20),
                        const FormSectionTitle('الوصف'),
                        const SizedBox(height: 12),
                        FormTextField(
                          c.description,
                          'وصف إضافي (اختياري)',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 20),
                        FormSectionTitle('الصور (${c.visibleImageCount})'),
                        const SizedBox(height: 12),
                        PropertyImagesEditor(controller: c),
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
                    : Text(_controller.isEdit ? 'حفظ التعديلات' : 'إضافة العقار'),
              ),
            ),
          );
        },
      ),
    );
  }
}
