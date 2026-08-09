import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../models/property.dart';
import '../services/property_service.dart';

/// Add / edit a property. Used by the dashboard's "إضافة عقار" FAB and the
/// edit button on each card.
class PropertyFormScreen extends StatefulWidget {
  final Property? property;
  const PropertyFormScreen({super.key, this.property});

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late final bool _isEdit;

  // Controllers
  late final TextEditingController _projectName;
  late final TextEditingController _buildingLabel;
  late final TextEditingController _areaSqm;
  late final TextEditingController _bedrooms;
  late final TextEditingController _bathrooms;
  late final TextEditingController _price;
  late final TextEditingController _description;

  // Enum/selectable state
  late UnitType _unitType;
  late String _floor;
  PropertyOrientation? _orientation;
  late PropertyFinishing _finishingStatus;
  PriceNote? _priceNote;
  late bool _hasReception;
  late bool _hasKitchen;
  late bool _isPublished;

  // Images
  late List<String> _existingUrls;
  final List<String> _removedUrls = [];
  final List<_PickedImage> _newImages = [];

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.property;
    _isEdit = p != null;

    _projectName = TextEditingController(text: p?.projectName ?? '');
    _buildingLabel = TextEditingController(text: p?.buildingLabel ?? '');
    _areaSqm = TextEditingController(
        text: p != null ? _fmtNum(p.areaSqm) : '');
    _bedrooms = TextEditingController(
        text: p != null ? p.bedrooms.toString() : '');
    _bathrooms = TextEditingController(
        text: p != null ? p.bathrooms.toString() : '');
    _price = TextEditingController(text: p != null ? _fmtNum(p.price) : '');
    _description = TextEditingController(text: p?.description ?? '');

    _unitType = p?.unitType ?? UnitType.apartment;
    _floor = p?.floor ?? floorOptions[1];
    _orientation = p?.orientation;
    _finishingStatus = p?.finishingStatus ?? PropertyFinishing.shell;
    _priceNote = p?.priceNote;
    _hasReception = p?.hasReception ?? true;
    _hasKitchen = p?.hasKitchen ?? true;
    _isPublished = p?.isPublished ?? true;

    _existingUrls = p?.imageUrls ?? [];
  }

  String _fmtNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  @override
  void dispose() {
    _projectName.dispose();
    _buildingLabel.dispose();
    _areaSqm.dispose();
    _bedrooms.dispose();
    _bathrooms.dispose();
    _price.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(limit: 10 - _newImages.length);
    if (picked.isEmpty) return;
    final loaded = <_PickedImage>[];
    for (final file in picked) {
      loaded.add(_PickedImage(file, await file.readAsBytes()));
    }
    setState(() => _newImages.addAll(loaded));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final property = Property(
        id: widget.property?.id,
        projectName: _projectName.text.trim(),
        buildingLabel: _buildingLabel.text.trim().isEmpty
            ? null
            : _buildingLabel.text.trim(),
        unitType: _unitType,
        floor: _floor,
        orientation: _orientation,
        areaSqm: double.parse(_areaSqm.text.trim()),
        bedrooms: int.parse(_bedrooms.text.trim()),
        bathrooms: int.parse(_bathrooms.text.trim()),
        hasReception: _hasReception,
        hasKitchen: _hasKitchen,
        finishingStatus: _finishingStatus,
        price: double.parse(_price.text.trim()),
        priceNote: _priceNote,
        description: _description.text.trim().isEmpty
            ? null
            : _description.text.trim(),
        imageUrls: _existingUrls,
        isPublished: _isPublished,
      );

      final service = PropertyService.instance;
      if (_isEdit) {
        await service.update(
          widget.property!.id!,
          property,
          _newImages.map((i) => i.file).toList(),
          _removedUrls,
        );
      } else {
        await service.create(
          property,
          _newImages.map((i) => i.file).toList(),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل الحفظ: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;

  String? _number(String? v, {bool allowZero = false}) {
    final val = double.tryParse(v ?? '');
    if (val == null) return 'أدخل رقماً صحيحاً';
    if (!allowZero && val <= 0) return 'أدخل رقماً أكبر من صفر';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          _isEdit ? 'تعديل العقار' : 'إضافة عقار',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionTitle('بيانات أساسية'),
                    _textField(_projectName, 'اسم المشروع', validator: _required),
                    const SizedBox(height: 12),
                    _textField(_buildingLabel, 'رقم العمارة (اختياري)'),
                    const SizedBox(height: 20),
                    _sectionTitle('تفاصيل الوحدة'),
                    const SizedBox(height: 12),
                    _dropdown<UnitType>(
                      label: 'نوع الوحدة',
                      value: _unitType,
                      items: UnitType.values,
                      labelOf: (v) => v.label,
                      onChanged: (v) => setState(() => _unitType = v),
                    ),
                    const SizedBox(height: 12),
                    _dropdown<String>(
                      label: 'الدور',
                      value: _floor,
                      items: floorOptions,
                      labelOf: (v) => v,
                      onChanged: (v) => setState(() => _floor = v),
                    ),
                    const SizedBox(height: 12),
                    _dropdown<PropertyOrientation?>(
                      label: 'الاتجاه (اختياري)',
                      value: _orientation,
                      items: PropertyOrientation.values,
                      labelOf: (v) => v?.label ?? 'بدون',
                      hint: 'بدون',
                      onChanged: (v) => setState(() => _orientation = v),
                    ),
                    const SizedBox(height: 12),
                    _dropdown<PropertyFinishing>(
                      label: 'التشطيب',
                      value: _finishingStatus,
                      items: PropertyFinishing.values,
                      labelOf: (v) => v.label,
                      onChanged: (v) => setState(() => _finishingStatus = v),
                    ),
                    const SizedBox(height: 12),
                    _dropdown<PriceNote?>(
                      label: 'نوع السعر (اختياري)',
                      value: _priceNote,
                      items: PriceNote.values,
                      labelOf: (v) => v?.label ?? 'بدون',
                      hint: 'بدون',
                      onChanged: (v) => setState(() => _priceNote = v),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            _areaSqm,
                            'المساحة (م²)',
                            keyboardType: TextInputType.number,
                            validator: _number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            _bedrooms,
                            'عدد الغرف',
                            keyboardType: TextInputType.number,
                            validator: _number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            _bathrooms,
                            'عدد الحمامات',
                            keyboardType: TextInputType.number,
                            validator: _number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            _price,
                            'السعر (ج.م)',
                            keyboardType: TextInputType.number,
                            validator: _number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _switchRow('يوجد ريسبشن', _hasReception,
                        (v) => setState(() => _hasReception = v)),
                    _switchRow('يوجد مطبخ', _hasKitchen,
                        (v) => setState(() => _hasKitchen = v)),
                    _switchRow('منشور على الموقع', _isPublished,
                        (v) => setState(() => _isPublished = v)),
                    const SizedBox(height: 20),
                    _sectionTitle('الوصف'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _description,
                      maxLines: 4,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: _inputDecoration('وصف إضافي (اختياري)'),
                    ),
                    const SizedBox(height: 20),
                    _sectionTitle('الصور ($_visibleImageCount)'),
                    const SizedBox(height: 12),
                    _buildImagesSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  int get _visibleImageCount =>
      _existingUrls.where((u) => !_removedUrls.contains(u)).length +
      _newImages.length;

  Widget _buildBottomBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textOnPrimary,
                  ),
                )
              : Text(_isEdit ? 'حفظ التعديلات' : 'إضافة العقار'),
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    final visible = _existingUrls
        .where((u) => !_removedUrls.contains(u))
        .toList();
    final children = <Widget>[];

    for (final url in visible) {
      children.add(_imageTile(
        Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(url, fit: BoxFit.cover),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: _removeBadge(
                onTap: () => setState(() => _removedUrls.add(url)),
              ),
            ),
          ],
        ),
      ));
    }

    for (final img in _newImages) {
      children.add(_imageTile(
        Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(img.bytes, fit: BoxFit.cover),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: _removeBadge(
                onTap: () => setState(() => _newImages.remove(img)),
              ),
            ),
          ],
        ),
      ));
    }

    if (children.length < 10) {
      children.add(_imageTile(
        InkWell(
          onTap: _pickImages,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.divider,
                style: BorderStyle.solid,
              ),
            ),
            child: const Icon(Icons.add_a_photo_rounded,
                color: AppColors.accent, size: 28),
          ),
        ),
      ));
    }

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: children,
    );
  }

  Widget _imageTile(Widget child) {
    return AspectRatio(
      aspectRatio: 1,
      child: child,
    );
  }

  Widget _removeBadge({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: AppColors.error,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close_rounded,
            size: 14, color: AppColors.textOnPrimary),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.accent,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _inputDecoration(label),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) labelOf,
    required ValueChanged<T> onChanged,
    String? hint,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      hint: hint == null
          ? null
          : Text(hint, style: const TextStyle(color: AppColors.textHint)),
      isExpanded: true,
      dropdownColor: AppColors.surface,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: _inputDecoration(label),
      items: items
          .map((v) => DropdownMenuItem<T>(
                value: v,
                child: Text(labelOf(v)),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Switch(
            value: value,
            activeTrackColor: AppColors.accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
    );
  }
}

class _PickedImage {
  final XFile file;
  final Uint8List bytes;
  _PickedImage(this.file, this.bytes);
}
