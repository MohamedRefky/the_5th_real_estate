import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Ultra-premium filter section displayed at the top of the Area Screen.
///
/// Each filter is grouped under a clear labelled header with selectable chips,
/// so it is always obvious which filter is which.
class FilterSection extends StatefulWidget {
  final void Function(FilterValues filters) onFiltersChanged;
  final VoidCallback onReset;

  const FilterSection({
    super.key,
    required this.onFiltersChanged,
    required this.onReset,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  bool _isExpanded = false;

  // Filter state
  RangeValues _priceRange = const RangeValues(0, 10000000);
  int? _selectedFloor;
  String? _selectedFinishing;
  int? _selectedRooms;
  int? _selectedBathrooms;
  (double, double)? _selectedAreaRange;

  int get _activeFilterCount {
    int count = 0;
    if (_priceRange.start > 0 || _priceRange.end < 10000000) count++;
    if (_selectedFloor != null) count++;
    if (_selectedFinishing != null) count++;
    if (_selectedRooms != null) count++;
    if (_selectedBathrooms != null) count++;
    if (_selectedAreaRange != null) count++;
    return count;
  }

  void _applyFilters() {
    widget.onFiltersChanged(FilterValues(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      floor: _selectedFloor,
      finishingStatus: _selectedFinishing,
      rooms: _selectedRooms,
      bathrooms: _selectedBathrooms,
      minArea: _selectedAreaRange?.$1,
      maxArea: _selectedAreaRange?.$2,
    ));
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 10000000);
      _selectedFloor = null;
      _selectedFinishing = null;
      _selectedRooms = null;
      _selectedBathrooms = null;
      _selectedAreaRange = null;
    });
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _activeFilterCount > 0
              ? AppColors.accent
              : AppColors.divider.withValues(alpha: 0.6),
          width: _activeFilterCount > 0 ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _activeFilterCount > 0
                ? AppColors.accent.withValues(alpha: 0.1)
                : AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header (always visible) ────────────────────────────
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.textOnPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'فلترة النتائج',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (_activeFilterCount > 0) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_activeFilterCount نشط',
                        style: const TextStyle(
                          color: AppColors.textOnPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expandable Filters ─────────────────────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildFilterContent(theme),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterContent(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: AppColors.divider.withValues(alpha: 0.5)),
          const SizedBox(height: 18),

          // ── Price Range ───────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _groupLabel(
                icon: Icons.payments_rounded,
                title: 'السعر (جنيه)',
              ),
              Text(
                '${_formatPrice(_priceRange.start)} - ${_formatPrice(_priceRange.end)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 10000000,
            divisions: 100,
            activeColor: AppColors.accent,
            inactiveColor: AppColors.divider,
            onChanged: (values) {
              setState(() => _priceRange = values);
              _applyFilters();
            },
          ),

          const SizedBox(height: 26),

          // ── Floor ─────────────────────────────────────────────
          _chipGroup<int>(
            icon: Icons.layers_rounded,
            title: 'الدور',
            selected: _selectedFloor,
            options: [
              ('أرضي', 0),
              ('الأول', 1),
              ('الثاني', 2),
              ('الثالث', 3),
              ('الرابع', 4),
              ('الخامس', 5),
              ('الرووف', 6),
            ],
            onChanged: (v) {
              setState(() => _selectedFloor = v);
              _applyFilters();
            },
          ),

          // ── Finishing Status ──────────────────────────────────
          _chipGroup<String>(
            icon: Icons.format_paint_rounded,
            title: 'التشطيب',
            selected: _selectedFinishing,
            options: [
              ('تشطيب كامل', 'finished'),
              ('تشطيب نص', 'semiFinished'),
            ],
            onChanged: (v) {
              setState(() => _selectedFinishing = v);
              _applyFilters();
            },
          ),

          // ── Rooms ─────────────────────────────────────────────
          _chipGroup<int>(
            icon: Icons.bed_rounded,
            title: 'الغرف',
            selected: _selectedRooms,
            options: [
              for (var i = 1; i <= 5; i++) ('$i غرف', i),
            ],
            onChanged: (v) {
              setState(() => _selectedRooms = v);
              _applyFilters();
            },
          ),

          // ── Bathrooms ─────────────────────────────────────────
          _chipGroup<int>(
            icon: Icons.bathtub_rounded,
            title: 'الحمامات',
            selected: _selectedBathrooms,
            options: [
              for (var i = 1; i <= 4; i++) ('$i حمام', i),
            ],
            onChanged: (v) {
              setState(() => _selectedBathrooms = v);
              _applyFilters();
            },
          ),

          // ── Area (sqm) ────────────────────────────────────────
          _chipGroup<(double, double)>(
            icon: Icons.straighten_rounded,
            title: 'المساحة',
            selected: _selectedAreaRange,
            options: [
              ('أقل من 150م²', (0, 150)),
              ('150 - 200م²', (150, 200)),
              ('200 - 250م²', (200, 250)),
              ('250 - 300م²', (250, 300)),
              ('أكثر من 300م²', (300, 99999)),
            ],
            onChanged: (v) {
              setState(() => _selectedAreaRange = v);
              _applyFilters();
            },
          ),

          const SizedBox(height: 4),

          // ── Reset Button ──────────────────────────────────────
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: const Text('مسح جميع الفلاتر'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupLabel({required IconData icon, required String title}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.accent),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _chipGroup<T>({
    required IconData icon,
    required String title,
    required List<(String, T)> options,
    required T? selected,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _groupLabel(icon: icon, title: title),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final (label, value) in options)
              _FilterChipButton(
                label: label,
                selected: selected == value,
                onTap: () => onChanged(selected == value ? null : value),
              ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    }
    return '${(price / 1000).toStringAsFixed(0)}K';
  }
}

/// A single selectable gold chip used inside each filter group.
class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.divider,
            width: selected ? 1.4 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(
                Icons.check_rounded,
                size: 15,
                color: AppColors.textOnPrimary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Holds the current filter values.
class FilterValues {
  final double minPrice;
  final double maxPrice;
  final int? floor;
  final String? finishingStatus;
  final int? rooms;
  final int? bathrooms;
  final double? minArea;
  final double? maxArea;

  const FilterValues({
    this.minPrice = 0,
    this.maxPrice = 10000000,
    this.floor,
    this.finishingStatus,
    this.rooms,
    this.bathrooms,
    this.minArea,
    this.maxArea,
  });
}
