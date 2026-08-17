import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/building_form_controller.dart';
import '../models/admin_building.dart';
import '../models/property.dart' show areaOptions;
import '../widgets/property_form_widgets.dart';

/// Add / edit a whole building (عمارة). Reached from the dashboard's type
/// chooser; writes go to the `buildings/{area}/units` collection.
class BuildingFormScreen extends StatefulWidget {
  final AdminBuilding? building;
  final String? initialArea;

  const BuildingFormScreen({super.key, this.building, this.initialArea});

  @override
  State<BuildingFormScreen> createState() => _BuildingFormScreenState();
}

class _BuildingFormScreenState extends State<BuildingFormScreen> {
  late final BuildingFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BuildingFormController(widget.building, initialArea: widget.initialArea);
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
            _controller.isEdit ? 'تعديل العمارة' : 'إضافة عمارة',
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
                          c.name,
                          'اسم العمارة والحرف (مثال: عمارة جاردنيا هايتس 3 حرف أ)',
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
                        const SizedBox(height: 20),
                        const FormSectionTitle('الوصف التفصيلي (السعر والمساحة وباقي البيانات)'),
                        const SizedBox(height: 12),
                        FormTextField(
                          c.description,
                          'اكتب هنا كافة تفاصيل العمارة (السعر، المساحة، هيكل المبنى، عدد الأدوار، حالة التشطيب، إلخ...)',
                          maxLines: 6,
                          validator: c.requiredValidator,
                        ),
                        const SizedBox(height: 20),
                        const FormSectionTitle('الوسائط والميديا'),
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
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.accent,
                                backgroundColor: AppColors.accentLight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: AppColors.accentLine),
                                ),
                              ),
                              icon: const Icon(
                                Icons.add_photo_alternate_rounded,
                                size: 18,
                                color: AppColors.accent,
                              ),
                              label: const Text(
                                'إضافة صورة',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (c.extraImageControllers.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              'اضغط على "+ إضافة صورة" لإضافة صورة تفاصيل للعمارة.',
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
                    : Text(_controller.isEdit ? 'حفظ التعديلات' : 'إضافة العمارة'),
              ),
            ),
          );
        },
      ),
    );
  }
}
