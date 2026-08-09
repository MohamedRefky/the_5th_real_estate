import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/filters/filter_formatters.dart';
import '../../../models/apartment.dart';
import '../../../models/filter_values.dart';
import 'filter_choice_chip.dart';
import 'filter_pill.dart';

/// Ultra-Clear, Auto-Wrapping Inline Popover Filter Section.
///
/// Converts the main filter bar from a horizontal scrollable row into an
/// auto-wrapping flex layout (`Wrap`) so every single filter pill (including
/// Price and Reset All) wraps cleanly onto a second line when space runs out,
/// ensuring zero hidden options!
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
  // Currently open inline popover key: 'floor', 'finishing', 'orientation',
  // 'rooms', 'bathrooms', 'area', 'price', or null
  String? _activePopover;

  // Filter state
  RangeValues _priceRange = const RangeValues(
    FilterValues.defaultMinPrice,
    FilterValues.defaultMaxPrice,
  );
  final Set<int> _selectedFloors = {};
  final Set<String> _selectedFinishingStatuses = {};
  final Set<ApartmentOrientation> _selectedOrientations = {};
  final Set<int> _selectedRooms = {};
  final Set<int> _selectedBathrooms = {};
  final Set<(double, double)> _selectedAreaRanges = {};

  int get _activeFilterCount {
    int count = 0;
    if (_priceRange.start > 0 || _priceRange.end < 10000000) count++;
    if (_selectedFloors.isNotEmpty) count++;
    if (_selectedFinishingStatuses.isNotEmpty) count++;
    if (_selectedOrientations.isNotEmpty) count++;
    if (_selectedRooms.isNotEmpty) count++;
    if (_selectedBathrooms.isNotEmpty) count++;
    if (_selectedAreaRanges.isNotEmpty) count++;
    return count;
  }

  bool get _hasPriceFilter =>
      _priceRange.start > 0 || _priceRange.end < 10000000;

  // ── Smart Truncated Selected Labels ──────────────────────────
  String get _floorLabel => floorFilterLabel(_selectedFloors);

  String get _finishingLabel => finishingFilterLabel(_selectedFinishingStatuses);

  String get _orientationLabel => orientationFilterLabel(_selectedOrientations);

  String get _roomsLabel => roomsFilterLabel(_selectedRooms);

  String get _bathroomsLabel => bathroomsFilterLabel(_selectedBathrooms);

  String get _areaLabel => areaFilterLabel(_selectedAreaRanges);

  String get _priceLabel =>
      priceFilterLabel(min: _priceRange.start, max: _priceRange.end);

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
    widget.onFiltersChanged(
      FilterValues(
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
        floors: _selectedFloors,
        finishingStatuses: _selectedFinishingStatuses,
        orientations: _selectedOrientations,
        rooms: _selectedRooms,
        bathrooms: _selectedBathrooms,
        areaRanges: _selectedAreaRanges,
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _activePopover = null;
      _priceRange = const RangeValues(
        FilterValues.defaultMinPrice,
        FilterValues.defaultMaxPrice,
      );
      _selectedFloors.clear();
      _selectedFinishingStatuses.clear();
      _selectedOrientations.clear();
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                FilterPill(
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
                FilterPill(
                  label: _finishingLabel,
                  badgeText: _selectedFinishingStatuses.isEmpty
                      ? null
                      : '${_selectedFinishingStatuses.length}',
                  icon: Icons.format_paint_rounded,
                  isOpen: _activePopover == 'finishing',
                  isSelected: _selectedFinishingStatuses.isNotEmpty,
                  onTap: () => _togglePopover('finishing'),
                ),

                // 3. Orientation Pill (أمامي، خلفي، جانبي)
                FilterPill(
                  label: _orientationLabel,
                  badgeText: _selectedOrientations.isEmpty
                      ? null
                      : '${_selectedOrientations.length}',
                  icon: Icons.explore_rounded,
                  isOpen: _activePopover == 'orientation',
                  isSelected: _selectedOrientations.isNotEmpty,
                  onTap: () => _togglePopover('orientation'),
                ),

                // 4. Rooms Pill
                FilterPill(
                  label: _roomsLabel,
                  badgeText: _selectedRooms.isEmpty
                      ? null
                      : '${_selectedRooms.length}',
                  icon: Icons.bed_rounded,
                  isOpen: _activePopover == 'rooms',
                  isSelected: _selectedRooms.isNotEmpty,
                  onTap: () => _togglePopover('rooms'),
                ),

                // 5. Bathrooms Pill
                FilterPill(
                  label: _bathroomsLabel,
                  badgeText: _selectedBathrooms.isEmpty
                      ? null
                      : '${_selectedBathrooms.length}',
                  icon: Icons.bathtub_rounded,
                  isOpen: _activePopover == 'bathrooms',
                  isSelected: _selectedBathrooms.isNotEmpty,
                  onTap: () => _togglePopover('bathrooms'),
                ),

                // 6. Area Pill
                FilterPill(
                  label: _areaLabel,
                  badgeText: _selectedAreaRanges.isEmpty
                      ? null
                      : '${_selectedAreaRanges.length}',
                  icon: Icons.straighten_rounded,
                  isOpen: _activePopover == 'area',
                  isSelected: _selectedAreaRanges.isNotEmpty,
                  onTap: () => _togglePopover('area'),
                ),

                // 7. Price Pill
                FilterPill(
                  label: _priceLabel,
                  icon: Icons.payments_rounded,
                  isOpen: _activePopover == 'price',
                  isSelected: _hasPriceFilter,
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
      case 'orientation':
        optionsContent = _buildOrientationOptions();
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

  /// Renders a `Wrap` of toggleable choice chips from an option list.
  Widget _buildChoiceWrap<T>({
    required List<(String, T)> options,
    required bool Function(T) isSelected,
    required void Function(T) onToggle,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final (label, val) in options)
          FilterChoiceChip(
            label: label,
            selected: isSelected(val),
            onTap: () => onToggle(val),
          ),
      ],
    );
  }

  void _toggleInSet<T>(Set<T> set, T value) {
    setState(() {
      if (!set.add(value)) {
        set.remove(value);
      }
    });
    _applyFilters();
  }

  Widget _buildFloorOptions() {
    return _buildChoiceWrap<int>(
      options: const [
        ('بيزمنت', -1),
        ('أرضي', 0),
        ('الأول', 1),
        ('الثاني', 2),
        ('الثالث', 3),
        ('الرابع', 4),
        ('الروف', 6),
      ],
      isSelected: _selectedFloors.contains,
      onToggle: (val) => _toggleInSet(_selectedFloors, val),
    );
  }

  Widget _buildFinishingOptions() {
    return _buildChoiceWrap<String>(
      options: const [
        ('سوبر لوكس', 'superLux'),
        ('نص تشطيب', 'semiFinished'),
        ('تحت الإنشاء', 'underConstruction'),
      ],
      isSelected: _selectedFinishingStatuses.contains,
      onToggle: (val) => _toggleInSet(_selectedFinishingStatuses, val),
    );
  }

  Widget _buildOrientationOptions() {
    return _buildChoiceWrap<ApartmentOrientation>(
      options: const [
        ('أمامي', ApartmentOrientation.front),
        ('خلفي', ApartmentOrientation.rear),
        ('جانبي', ApartmentOrientation.side),
      ],
      isSelected: _selectedOrientations.contains,
      onToggle: (val) => _toggleInSet(_selectedOrientations, val),
    );
  }

  Widget _buildRoomsOptions() {
    return _buildChoiceWrap<int>(
      options: List.generate(5, (i) => ('${i + 1} غرف', i + 1)),
      isSelected: _selectedRooms.contains,
      onToggle: (val) => _toggleInSet(_selectedRooms, val),
    );
  }

  Widget _buildBathroomsOptions() {
    return _buildChoiceWrap<int>(
      options: List.generate(4, (i) => ('${i + 1} حمام', i + 1)),
      isSelected: _selectedBathrooms.contains,
      onToggle: (val) => _toggleInSet(_selectedBathrooms, val),
    );
  }

  Widget _buildAreaOptions() {
    return _buildChoiceWrap<(double, double)>(
      options: const [
        ('115م²', (115.0, 115.0)),
        ('125م²', (125.0, 125.0)),
        ('125 : 150م²', (125.0, 150.0)),
        ('150 : 200م²', (150.0, 200.0)),
        ('200 : 250م²', (200.0, 250.0)),
        ('250 : 300م²', (250.0, 300.0)),
        ('+300م²', (300.0, 99999.0)),
      ],
      isSelected: _selectedAreaRanges.contains,
      onToggle: (val) => _toggleInSet(_selectedAreaRanges, val),
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
              '${formatPriceShort(_priceRange.start)} - ${formatPriceShort(_priceRange.end)} جنيه',
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
}
