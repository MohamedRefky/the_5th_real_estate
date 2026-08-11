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

/// Renders a number as Arabic words, e.g. `1800000` → `1 مليون و 800 ألف`.
String _formatArabicWords(double value) {
  final int amount = value.round();

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

  if (parts.isEmpty) return '$amount';
  return parts.join(' و ');
}

/// Accent preview box showing the final amount in Arabic words.
class AmountPreviewBox extends StatelessWidget {
  final String text;

  const AmountPreviewBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              text,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Smart Price Input Field for the Egyptian-pound price, always entered in
/// millions (e.g. `18` or `3.5`). The stored value is the number × 1,000,000.
class PriceInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const PriceInputField({
    super.key,
    required this.controller,
    this.label = 'السعر بالجنيه (بالمليون)',
    this.validator,
  });

  @override
  State<PriceInputField> createState() => _PriceInputFieldState();
}

class _PriceInputFieldState extends State<PriceInputField> {
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
      _displayController.text = _fmtNum(val / 1000000);
    } else {
      _displayController.text = '';
    }
  }

  void _onDisplayChanged() {
    _syncToTarget();
  }

  void _syncToTarget() {
    final text = _displayController.text.trim();
    final double? val = double.tryParse(text);
    if (val == null || val <= 0) {
      widget.controller.text = '';
    } else {
      widget.controller.text = _fmtNum(val * 1000000);
    }
    if (mounted) setState(() {});
  }

  String _fmtNum(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final targetText = widget.controller.text;
    final double? targetVal = double.tryParse(targetText.trim());
    final arabicText = (targetVal == null || targetVal <= 0)
        ? ''
        : _formatArabicWords(targetVal);

    const inputHint = 'أدخل المبلغ بالمليون (مثال: 18 أو 3.5)';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
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
          AmountPreviewBox(text: 'المبلغ النهائي: $arabicText جنيه'),
        ],
      ],
    );
  }
}

/// Dollar price field with a live Arabic preview of the final amount.
class UsdPriceInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const UsdPriceInputField({
    super.key,
    required this.controller,
    this.label = 'السعر بالدولار (اختياري)',
    this.validator,
  });

  @override
  State<UsdPriceInputField> createState() => _UsdPriceInputFieldState();
}

class _UsdPriceInputFieldState extends State<UsdPriceInputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.controller.text.trim();
    final double? val = double.tryParse(text);
    final arabicText = (val == null || val <= 0)
        ? ''
        : _formatArabicWords(val);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        FormTextField(
          widget.controller,
          'أدخل السعر بالدولار',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: widget.validator,
          prefixIcon: Icons.attach_money_rounded,
        ),
        if (arabicText.isNotEmpty) ...[
          const SizedBox(height: 8),
          AmountPreviewBox(text: 'المبلغ النهائي: $arabicText دولار'),
        ],
      ],
    );
  }
}
