import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Accent-colored section title inside the property form.
class FormSectionTitle extends StatelessWidget {
  final String title;

  const FormSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.accent,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

/// Shared input decoration for admin form fields.
InputDecoration propertyInputDecoration(
  String label, {
  IconData? prefixIcon,
  Widget? suffixIcon,
  Color fillColor = AppColors.surface,
}) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: AppColors.textSecondary),
    floatingLabelStyle: const TextStyle(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    prefixIcon: prefixIcon == null
        ? null
        : Icon(prefixIcon, color: AppColors.accent),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: fillColor,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
    ),
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

/// Text field styled for the admin forms (property form + login).
class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Color fillColor;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  const FormTextField(
    this.controller,
    this.label, {
    super.key,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor = AppColors.surface,
    this.obscureText = false,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      cursorColor: AppColors.textPrimary,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: propertyInputDecoration(
        label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: fillColor,
      ),
    );
  }
}

/// Dropdown styled for the property form.
class FormDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final String? Function(T?)? validator;

  const FormDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      validator: validator,
      hint: Text(
        hint ?? 'اختر $label...',
        style: const TextStyle(color: AppColors.textHint),
      ),
      isExpanded: true,
      dropdownColor: AppColors.surface,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: propertyInputDecoration(label),
      items: items
          .map((v) => DropdownMenuItem<T>(
                value: v,
                child: Text(labelOf(v)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}

/// Label + switch toggle row.
class FormSwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const FormSwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
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
}

/// Smart Price Input Field with unit selector (مليون / ألف / جنيه).
/// Allows typing simple numbers like `18` or `3.5` or `115` when "مليون" is selected.
class PriceInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const PriceInputField({
    super.key,
    required this.controller,
    this.label = 'السعر (ج.م)',
    this.validator,
  });

  @override
  State<PriceInputField> createState() => _PriceInputFieldState();
}

class _PriceInputFieldState extends State<PriceInputField> {
  // Unit options: 'million' (default), 'thousand', 'egp'
  String _selectedUnit = 'million';
  late final TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController();
    _initFromController();
    _displayController.addListener(_onDisplayChanged);
  }

  @override
  void dispose() {
    _displayController.removeListener(_onDisplayChanged);
    _displayController.dispose();
    super.dispose();
  }

  void _initFromController() {
    final rawText = widget.controller.text.trim();
    final double? val = double.tryParse(rawText);
    if (val != null && val > 0) {
      if (val >= 1000000 && (val % 1000 == 0)) {
        _selectedUnit = 'million';
        _displayController.text = _fmtNum(val / 1000000);
      } else if (val >= 1000 && (val % 100 == 0)) {
        _selectedUnit = 'thousand';
        _displayController.text = _fmtNum(val / 1000);
      } else {
        _selectedUnit = 'egp';
        _displayController.text = _fmtNum(val);
      }
    } else {
      _selectedUnit = 'million';
      _displayController.text = '';
    }
  }

  void _onDisplayChanged() {
    _syncToTarget();
  }

  void _changeUnit(String unit) {
    setState(() {
      _selectedUnit = unit;
    });
    _syncToTarget();
  }

  void _syncToTarget() {
    final text = _displayController.text.trim();
    final double? val = double.tryParse(text);
    if (val == null || val <= 0) {
      widget.controller.text = '';
    } else {
      double total = val;
      if (_selectedUnit == 'million') {
        total = val * 1000000;
      } else if (_selectedUnit == 'thousand') {
        total = val * 1000;
      }
      widget.controller.text = _fmtNum(total);
    }
    if (mounted) setState(() {});
  }

  String _fmtNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  String _formatArabicText(String input) {
    final double? val = double.tryParse(input.trim());
    if (val == null || val <= 0) return '';
    final int amount = val.round();

    final int millions = amount ~/ 1000000;
    final int remainder = amount % 1000000;
    final int thousands = remainder ~/ 1000;
    final int rest = remainder % 1000;

    final List<String> parts = [];
    if (millions > 0) {
      if (millions == 1) {
        parts.add('مليون');
      } else if (millions == 2) {
        parts.add('مليونان');
      } else if (millions >= 3 && millions <= 10) {
        parts.add('$millions ملايين');
      } else {
        parts.add('$millions مليون');
      }
    }

    if (thousands > 0) {
      if (thousands == 1) {
        parts.add('ألف');
      } else if (thousands == 2) {
        parts.add('ألفان');
      } else if (thousands >= 3 && thousands <= 10) {
        parts.add('$thousands آلاف');
      } else {
        parts.add('$thousands ألف');
      }
    }

    if (rest > 0) {
      parts.add('$rest');
    }

    if (parts.isEmpty) {
      return '$amount جنيه';
    }

    return '${parts.join(' و ')} جنيه';
  }

  @override
  Widget build(BuildContext context) {
    final targetText = widget.controller.text;
    final arabicText = _formatArabicText(targetText);

    String inputHint = 'أدخل المبلغ بالمليون (مثال: 18 أو 3.5 أو 115)';
    if (_selectedUnit == 'thousand') {
      inputHint = 'أدخل المبلغ بالألف (مثال: 500 أو 750)';
    } else if (_selectedUnit == 'egp') {
      inputHint = 'أدخل المبلغ الكامل بالجنيه (مثال: 3500000)';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            _unitChip('💰 بالمليون', 'million'),
            const SizedBox(width: 6),
            _unitChip('💵 بالألف', 'thousand'),
            const SizedBox(width: 6),
            _unitChip('🔢 جنيه', 'egp'),
          ],
        ),
        const SizedBox(height: 8),
        FormTextField(
          _displayController,
          inputHint,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (v) {
            final targetVal = widget.controller.text;
            if (widget.validator != null) {
              return widget.validator!(targetVal);
            }
            return null;
          },
          prefixIcon: Icons.payments_rounded,
        ),
        if (arabicText.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    size: 18, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'المبلغ النهائي: $arabicText',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _unitChip(String label, String unitKey) {
    final isSelected = _selectedUnit == unitKey;
    return InkWell(
      onTap: () => _changeUnit(unitKey),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
