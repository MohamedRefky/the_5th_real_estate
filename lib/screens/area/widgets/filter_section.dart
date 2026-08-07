import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Filter section displayed at the top of the Area Screen.
///
/// Provides filter controls for:
/// - Price range (min / max)
/// - Floor number
/// - Finishing status (finished / semi / unfinished)
/// - Area in sqm (min / max)
/// - Number of rooms
/// - Number of bathrooms
///
/// All filter values are passed back via [onFiltersChanged].
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header (always visible) ────────────────────────────
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: AppColors.accent,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'فلترة النتائج',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary,
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
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 8),

          // ── Price Range ───────────────────────────────────────
          Text('السعر (جنيه)', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 10000000,
            divisions: 100,
            activeColor: AppColors.accent,
            inactiveColor: AppColors.divider,
            labels: RangeLabels(
              _formatPrice(_priceRange.start),
              _formatPrice(_priceRange.end),
            ),
            onChanged: (values) {
              setState(() => _priceRange = values);
              _applyFilters();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatPrice(_priceRange.start),
                style: theme.textTheme.bodySmall,
              ),
              Text(
                _formatPrice(_priceRange.end),
                style: theme.textTheme.bodySmall,
              ),
            ],
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
                  setState(() => _selectedFloor = val != null ? int.parse(val) : null);
                  _applyFilters();
                },
              ),

              // Finishing Status
              _buildDropdownChip(
                label: 'التشطيب',
                icon: Icons.format_paint_rounded,
                value: _selectedFinishing,
                items: const [
                  DropdownMenuItem(value: 'finished', child: Text('تشطيب كامل')),
                  DropdownMenuItem(value: 'semiFinished', child: Text('نصف تشطيب')),
                  DropdownMenuItem(value: 'unfinished', child: Text('بدون تشطيب')),
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
                  setState(() => _selectedRooms = val != null ? int.parse(val) : null);
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
                  setState(() => _selectedBathrooms = val != null ? int.parse(val) : null);
                  _applyFilters();
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Reset Button ──────────────────────────────────────
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: _resetFilters,
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: const Text('مسح الفلاتر'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a styled dropdown wrapped in a chip-like container.
  Widget _buildDropdownChip({
    required String label,
    required IconData icon,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: value != null ? AppColors.accentLight : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value != null ? AppColors.accent : AppColors.divider,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          icon: const Icon(Icons.arrow_drop_down, size: 20),
          isDense: true,
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text('الكل', style: TextStyle(color: AppColors.textHint)),
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
      return '${(price / 1000000).toStringAsFixed(1)} مليون';
    }
    return '${(price / 1000).toStringAsFixed(0)} ألف';
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
