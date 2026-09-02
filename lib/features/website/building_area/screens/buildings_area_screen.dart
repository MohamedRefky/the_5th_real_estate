import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/result_count_badge.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../core/widgets/searchable_hero_banner.dart';
import '../../../../data/filters/building_filter.dart';
import '../../../../data/filters/filter_formatters.dart';
import '../../area/widgets/filter_popover_panel.dart';
import '../../area/widgets/filter_price_slider.dart';
import '../controllers/buildings_area_controller.dart';
import '../widgets/building_card.dart';

/// Screen listing all residential buildings in a specific neighborhood.
class BuildingsAreaScreen extends StatefulWidget {
  final String areaName;

  /// When set, loads buildings across all these areas (combined box).
  final List<String>? areas;

  const BuildingsAreaScreen({
    super.key,
    required this.areaName,
    this.areas,
  });

  @override
  State<BuildingsAreaScreen> createState() => _BuildingsAreaScreenState();
}

class _BuildingsAreaScreenState extends State<BuildingsAreaScreen> {
  late final BuildingsAreaController _controller;
  bool _isPriceOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = BuildingsAreaController(
      widget.areaName,
      areas: widget.areas,
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عمارات ${widget.areaName}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          final buildings = _controller.filteredBuildings;

          return SingleChildScrollView(
            child: Column(
              children: [
                // ── Hero Banner ──────────────────────────────────────
                SearchableHeroBanner(
                  title: 'عمارات ${widget.areaName}',
                  subtitle: 'استكشف العمارات والمشاريع السكنية المتاحة في ${widget.areaName} وتفاصيل نسبة التنفيذ والوحدات المتاحة',
                  searchHint: 'ابحث باسم العمارة أو تفاصيل المشروع...',
                  onSearchChanged: _controller.onSearchChanged,
                ),

                // ── Main Content Area ─────────────────────────────────
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.sizeOf(context).width < 600 ? 14 : 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Filter Pills Row (Status + Price)
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _statusPill(BuildingStatus.all),
                              _statusPill(BuildingStatus.ready),
                              _statusPill(BuildingStatus.underConstruction),
                              _pricePill(),
                              if (_controller.selectedStatus != BuildingStatus.all ||
                                  _controller.priceRange.start > 0 ||
                                  _controller.priceRange.end < 40000000)
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isPriceOpen = false;
                                      _controller.resetFilters();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    size: 16,
                                    color: AppColors.accent,
                                  ),
                                  label: const Text(
                                    'إعادة ضبط',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          if (_isPriceOpen) ...[
                            const SizedBox(height: 14),
                            FilterPopoverPanel(
                              onDone: () => setState(() => _isPriceOpen = false),
                              child: FilterPriceSlider(
                                values: _controller.priceRange,
                                onChanged: (v) {
                                  setState(() => _controller.setPriceRange(v));
                                },
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Result Count Badge
                          ResultCountBadge(
                            icon: Icons.apartment_rounded,
                            text: 'تم العثور على ${buildings.length} عمارة متاحة',
                          ),

                          const SizedBox(height: 28),

                          // Building Grid / List
                          if (buildings.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 64),
                                child: Text(
                                  'لا توجد عمارات مطابقة للبحث حالياً',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          else
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isSmall = constraints.maxWidth < 600;
                                final double spacing = isSmall ? 14.0 : 20.0;
                                int count = 1;
                                if (constraints.maxWidth >= 950) {
                                  count = 3;
                                } else if (constraints.maxWidth >= 640) {
                                  count = 2;
                                }
                                final cardWidth =
                                    (constraints.maxWidth - (spacing * (count - 1))) /
                                        count;

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: spacing,
                                  children: buildings.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final bld = entry.value;
                                    return SizedBox(
                                      width: cardWidth,
                                      child: RevealOnScroll(
                                        delayMilliseconds: (index % 4) * 80,
                                        child: BuildingCard(building: bld),
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            ),

                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusPill(String status) {
    return _FilterPill(
      label: status,
      isSelected: _controller.selectedStatus == status,
      onTap: () => _controller.selectStatus(status),
    );
  }

  Widget _pricePill() {
    final hasPriceFilter =
        _controller.priceRange.start > 0 || _controller.priceRange.end < 40000000;
    final label = priceFilterLabel(
      min: _controller.priceRange.start,
      max: _controller.priceRange.end,
    );
    return _FilterPill(
      label: label,
      isSelected: hasPriceFilter || _isPriceOpen,
      icon: Icons.payments_outlined,
      onTap: () => setState(() => _isPriceOpen = !_isPriceOpen),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent
              : AppColors.primaryMedium.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: isSelected ? AppColors.textOnPrimary : AppColors.accent,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
