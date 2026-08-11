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
                          'اسم العمارة / المشروع',
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
                          c.imageUrls,
                          'روابط الصور (رابط كل صورة في سطر جديد)',
                          maxLines: 4,
                        ),
                        const SizedBox(height: 12),
                        FormTextField(
                          c.videoUrl,
                          'رابط الفيديو (اختياري)',
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
