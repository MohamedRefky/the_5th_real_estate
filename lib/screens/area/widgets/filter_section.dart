import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Ultra-Clear, Auto-Wrapping Inline Popover Filter Section.
///
/// Converts the main filter bar from a horizontal scrollable row into an auto-wrapping
/// flex layout (`Wrap`) so every single filter pill (including Price and Reset All)
/// wraps cleanly onto a second line when space runs out, ensuring zero hidden options!
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
  // Currently open inline popover key: 'floor', 'finishing', 'rooms', 'bathrooms', 'area', 'price', or null
  String? _activePopover;

  // Filter state
  RangeValues _priceRange = const RangeValues(0, 10000000);
  final Set<int> _selectedFloors = {};
  final Set<String> _selectedFinishingStatuses = {};
  final Set<int> _selectedRooms = {};
  final Set<int> _selectedBathrooms = {};
  final Set<(double, double)> _selectedAreaRanges = {};

  int get _activeFilterCount {
    int count = 0;
    if (_priceRange.start > 0 || _priceRange.end < 10000000) count++;
    if (_selectedFloors.isNotEmpty) count++;
    if (_selectedFinishingStatuses.isNotEmpty) count++;
    if (_selectedRooms.isNotEmpty) count++;
    if (_selectedBathrooms.isNotEmpty) count++;
    if (_selectedAreaRanges.isNotEmpty) count++;
    return count;
  }

  // ── Smart Truncated Selected Labels ──────────────────────────
  String get _floorLabel {
    if (_selectedFloors.isEmpty) return 'الدور';
    final list = _selectedFloors.map((f) {
      if (f == 0) return 'أرضي';
      if (f == 6) return 'روف';
      return '$f';
    }).toList();
    if (list.length <= 2) return 'الدور: ${list.join("، ")}';
    return 'الدور: ${list.take(2).join("، ")} (+${list.length - 2})';
  }

  String get _finishingLabel {
    if (_selectedFinishingStatuses.isEmpty) return 'التشطيب';
    final list = _selectedFinishingStatuses.map((s) {
      if (s == 'finished') return 'كامل';
      if (s == 'semiFinished') return 'نصف';
      return s;
    }).toList();
    if (list.length <= 2) return 'التشطيب: ${list.join("، ")}';
    return 'التشطيب: ${list.take(2).join("، ")} (+${list.length - 2})';
  }

  String get _roomsLabel {
    if (_selectedRooms.isEmpty) return 'الغرف';
    final list = _selectedRooms.toList();
    if (list.length <= 2) return 'الغرف: ${list.join("، ")}';
    return 'الغرف: ${list.take(2).join("، ")} (+${list.length - 2})';
  }

  String get _bathroomsLabel {
    if (_selectedBathrooms.isEmpty) return 'الحمامات';
    final list = _selectedBathrooms.toList();
    if (list.length <= 2) return 'الحمامات: ${list.join("، ")}';
    return 'الحمامات: ${list.take(2).join("، ")} (+${list.length - 2})';
  }

  String get _areaLabel {
    if (_selectedAreaRanges.isEmpty) return 'المساحة';
    final list =
        _selectedAreaRanges.map((r) => _formatAreaRange(r)).toList();
    if (list.length <= 1) return 'المساحة: ${list.first}';
    return 'المساحة: ${list.first} (+${list.length - 1})';
  }

  String get _priceLabel {
    final hasPriceFilter =
        _priceRange.start > 0 || _priceRange.end < 10000000;
    if (!hasPriceFilter) return 'السعر';
    return 'السعر: ${_formatPrice(_priceRange.start)}-${_formatPrice(_priceRange.end)}';
  }

  void _togglePopover(String name) {
    setState(() {
      if (_activePopover == name) {
        _activePopover = null;
      } else {
        _activePopover = name;
      }
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(FilterValues(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      floors: _selectedFloors,
      finishingStatuses: _selectedFinishingStatuses,
      rooms: _selectedRooms,
      bathrooms: _selectedBathrooms,
      areaRanges: _selectedAreaRanges,
    ));
  }

  void _resetFilters() {
    setState(() {
      _activePopover = null;
      _priceRange = const RangeValues(0, 10000000);
      _selectedFloors.clear();
      _selectedFinishingStatuses.clear();
      _selectedRooms.clear();
      _selectedBathrooms.clear();
      _selectedAreaRanges.clear();
    });
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _activeFilterCount > 0
              ? AppColors.accent
              : AppColors.divider.withValues(alpha: 0.7),
          width: _activeFilterCount > 0 ? 1.2 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: _activeFilterCount > 0
                ? AppColors.accent.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Auto-Wrapping Filter Pill Bar (Wraps to line 2 if full!) ──
          Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // ── Explicit "فلترة النتائج" Header Badge ────────────
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.tune_rounded,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'فلترة النتائج',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w900,
                          fontSize: 13.5,
                        ),
                      ),
                      if (_activeFilterCount > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$_activeFilterCount',
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 1. Floor Pill
                _FilterPill(
                  label: _floorLabel,
                  badgeText: _selectedFloors.isEmpty
                      ? null
                      : '${_selectedFloors.length}',
                  icon: Icons.layers_rounded,
                  isOpen: _activePopover == 'floor',
                  isSelected: _selectedFloors.isNotEmpty,
                  onTap: () => _togglePopover('floor'),
                ),

                // 2. Finishing Pill
                _FilterPill(
                  label: _finishingLabel,
                  badgeText: _selectedFinishingStatuses.isEmpty
                      ? null
                      : '${_selectedFinishingStatuses.length}',
                  icon: Icons.format_paint_rounded,
                  isOpen: _activePopover == 'finishing',
                  isSelected: _selectedFinishingStatuses.isNotEmpty,
                  onTap: () => _togglePopover('finishing'),
                ),

                // 3. Rooms Pill
                _FilterPill(
                  label: _roomsLabel,
                  badgeText: _selectedRooms.isEmpty
                      ? null
                      : '${_selectedRooms.length}',
                  icon: Icons.bed_rounded,
                  isOpen: _activePopover == 'rooms',
                  isSelected: _selectedRooms.isNotEmpty,
                  onTap: () => _togglePopover('rooms'),
                ),

                // 4. Bathrooms Pill
                _FilterPill(
                  label: _bathroomsLabel,
                  badgeText: _selectedBathrooms.isEmpty
                      ? null
                      : '${_selectedBathrooms.length}',
                  icon: Icons.bathtub_rounded,
                  isOpen: _activePopover == 'bathrooms',
                  isSelected: _selectedBathrooms.isNotEmpty,
                  onTap: () => _togglePopover('bathrooms'),
                ),

                // 5. Area Pill
                _FilterPill(
                  label: _areaLabel,
                  badgeText: _selectedAreaRanges.isEmpty
                      ? null
                      : '${_selectedAreaRanges.length}',
                  icon: Icons.straighten_rounded,
                  isOpen: _activePopover == 'area',
                  isSelected: _selectedAreaRanges.isNotEmpty,
                  onTap: () => _togglePopover('area'),
                ),

                // 6. Price Pill
                _FilterPill(
                  label: _priceLabel,
                  icon: Icons.payments_rounded,
                  isOpen: _activePopover == 'price',
                  isSelected:
                      _priceRange.start > 0 || _priceRange.end < 10000000,
                  onTap: () => _togglePopover('price'),
                ),

                if (_activeFilterCount > 0)
                  InkWell(
                    onTap: _resetFilters,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.restart_alt_rounded,
                            size: 16,
                            color: AppColors.error,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'مسح الكل',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Auto-Wrapping Inline Dropdown Panel ─────────────────
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildInlinePopoverPanel(theme),
            crossFadeState: _activePopover != null
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Auto-Wrapping Inline Dropdown Panel
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildInlinePopoverPanel(ThemeData theme) {
    if (_activePopover == null) return const SizedBox.shrink();

    Widget optionsContent;

    switch (_activePopover) {
      case 'floor':
        optionsContent = _buildFloorOptions();
        break;
      case 'finishing':
        optionsContent = _buildFinishingOptions();
        break;
      case 'rooms':
        optionsContent = _buildRoomsOptions();
        break;
      case 'bathrooms':
        optionsContent = _buildBathroomsOptions();
        break;
      case 'area':
        optionsContent = _buildAreaOptions();
        break;
      case 'price':
        optionsContent = _buildPriceOptions(theme);
        break;
      default:
        optionsContent = const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border(
          top: BorderSide(color: AppColors.divider.withValues(alpha: 0.5)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: optionsContent),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => setState(() => _activePopover = null),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'تم',
                    style: TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloorOptions() {
    final floors = [
      ('أرضي', 0),
      ('الأول', 1),
      ('الثاني', 2),
      ('الثالث', 3),
      ('الرابع', 4),
      ('الخامس', 5),
      ('الروف', 6),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final (label, val) in floors)
          _ChoiceChip(
            label: label,
            selected: _selectedFloors.contains(val),
            onTap: () {
              setState(() {
                if (!_selectedFloors.add(val)) {
                  _selectedFloors.remove(val);
                }
              });
              _applyFilters();
            },
          ),
      ],
    );
  }

  Widget _buildFinishingOptions() {
    final options = [
      ('متشطب كامل', 'finished'),
      ('نصف تشطيب', 'semiFinished'),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final (label, val) in options)
          _ChoiceChip(
            label: label,
            selected: _selectedFinishingStatuses.contains(val),
            onTap: () {
              setState(() {
                if (!_selectedFinishingStatuses.add(val)) {
                  _selectedFinishingStatuses.remove(val);
                }
              });
              _applyFilters();
            },
          ),
      ],
    );
  }

  Widget _buildRoomsOptions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          _ChoiceChip(
            label: '$i غرف',
            selected: _selectedRooms.contains(i),
            onTap: () {
              setState(() {
                if (!_selectedRooms.add(i)) {
                  _selectedRooms.remove(i);
                }
              });
              _applyFilters();
            },
          ),
      ],
    );
  }

  Widget _buildBathroomsOptions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var i = 1; i <= 4; i++)
          _ChoiceChip(
            label: '$i حمام',
            selected: _selectedBathrooms.contains(i),
            onTap: () {
              setState(() {
                if (!_selectedBathrooms.add(i)) {
                  _selectedBathrooms.remove(i);
                }
              });
              _applyFilters();
            },
          ),
      ],
    );
  }

  Widget _buildAreaOptions() {
    final ranges = [
      ('أقل من 150م²', (0.0, 150.0)),
      ('150-200م²', (150.0, 200.0)),
      ('200-250م²', (250.0, 250.0)),
      ('250-300م²', (250.0, 300.0)),
      ('أكثر من 300م²', (300.0, 99999.0)),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final (label, val) in ranges)
          _ChoiceChip(
            label: label,
            selected: _selectedAreaRanges.contains(val),
            onTap: () {
              setState(() {
                if (!_selectedAreaRanges.add(val)) {
                  _selectedAreaRanges.remove(val);
                }
              });
              _applyFilters();
            },
          ),
      ],
    );
  }

  Widget _buildPriceOptions(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'السعر:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_formatPrice(_priceRange.start)} - ${_formatPrice(_priceRange.end)} جنيه',
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.divider,
            thumbColor: AppColors.accent,
          ),
          child: RangeSlider(
            values: _priceRange,
            min: 0,
            max: 10000000,
            divisions: 100,
            onChanged: (values) {
              setState(() => _priceRange = values);
              _applyFilters();
            },
          ),
        ),
      ],
    );
  }

  String _formatAreaRange((double, double) range) {
    if (range.$1 == 0.0) return '<150م²';
    if (range.$2 >= 99999.0) return '>300م²';
    return '${range.$1.toInt()}-${range.$2.toInt()}م²';
  }

  String _formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    }
    return '${(price / 1000).toStringAsFixed(0)}K';
  }
}

// ═══════════════════════════════════════════════════════════════════
// Pill Button Widget
// ═══════════════════════════════════════════════════════════════════

class _FilterPill extends StatelessWidget {
  final String label;
  final String? badgeText;
  final IconData icon;
  final bool isOpen;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    this.badgeText,
    required this.icon,
    required this.isOpen,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = isOpen || isSelected;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? AppColors.accent : AppColors.divider,
            width: active ? 1.2 : 0.8,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? AppColors.textOnPrimary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: active ? FontWeight.bold : FontWeight.w600,
                color: active
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
              ),
            ),
            if (badgeText != null) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 4),
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 180),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color:
                    active ? AppColors.textOnPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Choice Chip
// ═══════════════════════════════════════════════════════════════════

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.divider,
            width: selected ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(
                Icons.check_rounded,
                size: 14,
                color: AppColors.textOnPrimary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
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
  final Set<int> floors;
  final Set<String> finishingStatuses;
  final Set<int> rooms;
  final Set<int> bathrooms;
  final Set<(double, double)> areaRanges;

  const FilterValues({
    this.minPrice = 0,
    this.maxPrice = 10000000,
    this.floors = const {},
    this.finishingStatuses = const {},
    this.rooms = const {},
    this.bathrooms = const {},
    this.areaRanges = const {},
  });
}
