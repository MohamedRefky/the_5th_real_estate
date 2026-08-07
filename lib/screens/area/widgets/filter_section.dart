import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Ultra-premium filter section displayed at the top of the Area Screen.
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

  int get _activeFilterCount {
    int count = 0;
    if (_priceRange.start > 0 || _priceRange.end < 10000000) count++;
    if (_selectedFloor != null) count++;
    if (_selectedFinishing != null) count++;
    if (_selectedRooms != null) count++;
    if (_selectedBathrooms != null) count++;
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
    ));
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 10000000);
      _selectedFloor = null;
      _selectedFinishing = null;
      _selectedRooms = null;
      _selectedBathrooms = null;
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
          const SizedBox(height: 12),

          // ── Price Range ───────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السعر (جنيه)',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
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
          const SizedBox(height: 8),
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

          const SizedBox(height: 20),

          // ── Chip Filters Row ──────────────────────────────────
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Floor
              _buildDropdownChip(
                label: 'الدور',
                icon: Icons.layers_rounded,
                value: _selectedFloor?.toString(),
                items: List.generate(6, (i) => i)
                    .map((f) => DropdownMenuItem(
                          value: f.toString(),
                          child: Text(f == 0 ? 'أرضي' : 'الدور $f'),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() =>
                      _selectedFloor = val != null ? int.parse(val) : null);
                  _applyFilters();
                },
              ),

              // Finishing Status
              _buildDropdownChip(
                label: 'التشطيب',
                icon: Icons.format_paint_rounded,
                value: _selectedFinishing,
                items: const [
                  DropdownMenuItem(
                      value: 'finished', child: Text('تشطيب كامل')),
                  DropdownMenuItem(
                      value: 'semiFinished', child: Text('نصف تشطيب')),
                  DropdownMenuItem(
                      value: 'unfinished', child: Text('بدون تشطيب')),
                ],
                onChanged: (val) {
                  setState(() => _selectedFinishing = val);
                  _applyFilters();
                },
              ),

              // Rooms
              _buildDropdownChip(
                label: 'الغرف',
                icon: Icons.bed_rounded,
                value: _selectedRooms?.toString(),
                items: List.generate(5, (i) => i + 1)
                    .map((r) => DropdownMenuItem(
                          value: r.toString(),
                          child: Text('$r غرف'),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() =>
                      _selectedRooms = val != null ? int.parse(val) : null);
                  _applyFilters();
                },
              ),

              // Bathrooms
              _buildDropdownChip(
                label: 'الحمامات',
                icon: Icons.bathtub_rounded,
                value: _selectedBathrooms?.toString(),
                items: List.generate(4, (i) => i + 1)
                    .map((b) => DropdownMenuItem(
                          value: b.toString(),
                          child: Text('$b حمام'),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() => _selectedBathrooms =
                      val != null ? int.parse(val) : null);
                  _applyFilters();
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

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

  Widget _buildDropdownChip({
    required String label,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = value != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accentLight : AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.accent : AppColors.divider,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            size: 20,
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
          ),
          isDense: true,
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text('الكل',
                  style: TextStyle(color: AppColors.textHint, fontSize: 13)),
            ),
            ...items,
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    }
    return '${(price / 1000).toStringAsFixed(0)}K';
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

  const FilterValues({
    this.minPrice = 0,
    this.maxPrice = 10000000,
    this.floor,
    this.finishingStatus,
    this.rooms,
    this.bathrooms,
  });
}
