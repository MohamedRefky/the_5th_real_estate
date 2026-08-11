import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/result_count_badge.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../core/widgets/searchable_hero_banner.dart';
import '../../../../data/filters/building_filter.dart';
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Filter Pills Row
                          Row(
                            children: [
                              _statusPill(BuildingStatus.all),
                              const SizedBox(width: 10),
                              _statusPill(BuildingStatus.ready),
                              const SizedBox(width: 10),
                              _statusPill(BuildingStatus.underConstruction),
                            ],
                          ),

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
                                final double spacing = 20.0;
                                int count = 1;
                                if (constraints.maxWidth >= 900) {
                                  count = 3;
                                } else if (constraints.maxWidth >= 600) {
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
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}
