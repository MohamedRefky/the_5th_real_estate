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

/// Smart Price Input Field with auto zero buttons (+000) and live Arabic text preview.
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
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onPriceChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onPriceChanged);
    super.dispose();
  }

  void _onPriceChanged() {
    if (mounted) setState(() {});
  }

  void _appendZeros() {
    final currentText = widget.controller.text.trim();
    if (currentText.isEmpty) {
      widget.controller.text = '1000';
    } else {
      widget.controller.text = '${currentText}000';
    }
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
  }

  void _setPreset(int amount) {
    widget.controller.text = amount.toString();
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
  }

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
    final arabicText = _formatArabicText(widget.controller.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormTextField(
          widget.controller,
          widget.label,
          keyboardType: TextInputType.number,
          validator: widget.validator,
          prefixIcon: Icons.payments_rounded,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            InkWell(
              onTap: _appendZeros,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, size: 14, color: AppColors.accent),
                    Text(
                      ' 000 (ثلاثة أصفار)',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _presetChip('1M', 1000000),
            _presetChip('2M', 2000000),
            _presetChip('3M', 3000000),
            _presetChip('5M', 5000000),
          ],
        ),
        if (arabicText.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    size: 16, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'المبلغ بالعربية: $arabicText',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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

  Widget _presetChip(String label, int amount) {
    return InkWell(
      onTap: () => _setPreset(amount),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
