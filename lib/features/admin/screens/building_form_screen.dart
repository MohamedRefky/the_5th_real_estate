import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/apartment.dart';
import '../controllers/building_form_controller.dart';
import '../models/admin_building.dart';
import '../widgets/property_form_widgets.dart';
import '../widgets/property_images_editor.dart';

/// Add / edit a whole building (عمارة). Reached from the dashboard's type
/// chooser; writes go to the `buildings/{area}/units` collection.
///
/// All form state + save logic lives in [BuildingFormController]; this screen
/// only composes the shared form widgets.
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

  Future<void> _pickDeliveryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _controller.deliveryDate ?? DateTime.now().add(
            const Duration(days: 365),
          ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'موعد التسليم المتوقع',
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            surface: AppColors.surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) _controller.setDeliveryDate(picked);
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
                          items: const [
                            'المستثمرين',
                            'الأندلس',
                            'جاردينيا',
                            'بيت الوطن',
                            'النرجس الجديدة',
                          ],
                          labelOf: (v) => v,
                          onChanged: c.setArea,
                        ),
                        const SizedBox(height: 12),
                        FormTextField(
                          c.areaSqm,
                          'مساحة المبنى (م²) — اختياري',
                          keyboardType: TextInputType.number,
                          validator: c.optionalNumberValidator,
                        ),
                        const SizedBox(height: 20),
                        const FormSectionTitle('تفاصيل العمارة'),
                        const SizedBox(height: 12),
                        FormTextField(c.buildingStructure, 'هيكل المبنى (مثال: بيزمنت + أرضي + أول)'),
                        const SizedBox(height: 12),
                        FormTextField(c.orientation, 'الاتجاه/الواجهة (مثال: دبل فيس)'),
                        const SizedBox(height: 12),
                        FormTextField(c.layoutNote, 'ملاحظة التخطيط (مثال: الدور ينفع شقتين)'),
                        const SizedBox(height: 12),
                        FormDropdown<FinishingStatus?>(
                          label: 'التشطيب',
                          value: c.finishingStatus,
                          items: FinishingStatus.values,
                          labelOf: (v) => v?.label ?? '',
                          hint: 'اختر حالة التشطيب...',
                          validator: (v) =>
                              v == null ? 'يرجى اختيار حالة التشطيب' : null,
                          onChanged: c.setFinishingStatus,
                        ),
                        const SizedBox(height: 12),
                        PriceInputField(
                          controller: c.startingPrice,
                          label: 'السعر الأولي (ج.م)',
                          validator: c.numberValidator,
                        ),
                        const SizedBox(height: 12),
                        FormTextField(
                          c.totalFloors,
                          'عدد الأدوار',
                          keyboardType: TextInputType.number,
                          validator: c.numberValidator,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FormTextField(
                                c.totalUnits,
                                'عدد الوحدات',
                                keyboardType: TextInputType.number,
                                validator: c.numberValidator,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FormTextField(
                                c.availableUnits,
                                'الوحدات المتاحة',
                                keyboardType: TextInputType.number,
                                validator: c.numberValidator,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FormSwitchRow(
                          label: 'تحت الإنشاء',
                          value: c.isUnderConstruction,
                          onChanged: c.setIsUnderConstruction,
                        ),
                        if (c.isUnderConstruction) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _pickDeliveryDate,
                                  icon: const Icon(
                                    Icons.event_rounded,
                                    color: AppColors.accent,
                                  ),
                                  label: Text(
                                    c.deliveryDate == null
                                        ? 'اختر موعد التسليم'
                                        : 'التسليم: ${c.deliveryDate!.year}/${c.deliveryDate!.month}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              if (c.deliveryDate != null)
                                IconButton(
                                  tooltip: 'إلغاء الموعد',
                                  onPressed: c.clearDeliveryDate,
                                  icon: const Icon(
                                    Icons.clear_rounded,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'نسبة التنفيذ: ${(c.constructionProgress * 100).round()}٪',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Slider(
                            value: c.constructionProgress,
                            onChanged: c.setConstructionProgress,
                            activeColor: AppColors.accent,
                          ),
                        ],
                        const SizedBox(height: 16),
                        FormTextField(
                          c.whatsappNumber,
                          'رقم الواتساب',
                          keyboardType: TextInputType.phone,
                          validator: c.requiredValidator,
                        ),
                        const SizedBox(height: 12),
                        FormTextField(
                          c.amenities,
                          'المميزات (افصل بينها بفاصلة)',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
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
                          'وصف العمارة والمشروع',
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
                    : Text(_controller.isEdit ? 'حفظ التعديلات' : 'إضافة العمارة'),
              ),
            ),
          );
        },
      ),
    );
  }
}
