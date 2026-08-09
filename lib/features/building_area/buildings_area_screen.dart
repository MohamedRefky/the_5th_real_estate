import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../data/dummy_data.dart';
import '../../models/building.dart';
import 'widgets/building_card.dart';

/// Screen listing all residential buildings in a specific neighborhood.
class BuildingsAreaScreen extends StatefulWidget {
  final String areaName;

  const BuildingsAreaScreen({super.key, required this.areaName});

  @override
  State<BuildingsAreaScreen> createState() => _BuildingsAreaScreenState();
}

class _BuildingsAreaScreenState extends State<BuildingsAreaScreen> {
  List<Building> _filteredBuildings = [];
  String _searchQuery = '';
  String _selectedStatus = 'الكل'; // 'الكل', 'تحت الإنشاء', 'جاهز للتسليم'

  @override
  void initState() {
    super.initState();
    _filteredBuildings = DummyData.getBuildingsByArea(widget.areaName);
  }

  void _applyFilter() {
    final all = DummyData.getBuildingsByArea(widget.areaName);
    setState(() {
      _filteredBuildings = all.where((bld) {
        // Search query
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final nameMatch = bld.name.toLowerCase().contains(query);
          final descMatch = bld.description.toLowerCase().contains(query);
          if (!nameMatch && !descMatch) return false;
        }

        // Status filter
        if (_selectedStatus == 'تحت الإنشاء' && !bld.isUnderConstruction) {
          return false;
        }
        if (_selectedStatus == 'جاهز للتسليم' && bld.isUnderConstruction) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('عمارات ${widget.areaName}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero Banner ──────────────────────────────────────
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      children: [
                        Text(
                          'عمارات ${widget.areaName}',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'استكشف العمارات والمشاريع السكنية المتاحة في ${widget.areaName} وتفاصيل نسبة التنفيذ والوحدات المتاحة',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Search Input
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.4),
                            ),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              _searchQuery = value;
                              _applyFilter();
                            },
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'ابحث باسم العمارة أو تفاصيل المشروع...',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textHint,
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.accent,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                          _FilterPill(
                            label: 'الكل',
                            isSelected: _selectedStatus == 'الكل',
                            onTap: () {
                              setState(() => _selectedStatus = 'الكل');
                              _applyFilter();
                            },
                          ),
                          const SizedBox(width: 10),
                          _FilterPill(
                            label: 'جاهز للتسليم',
                            isSelected: _selectedStatus == 'جاهز للتسليم',
                            onTap: () {
                              setState(() => _selectedStatus = 'جاهز للتسليم');
                              _applyFilter();
                            },
                          ),
                          const SizedBox(width: 10),
                          _FilterPill(
                            label: 'تحت الإنشاء',
                            isSelected: _selectedStatus == 'تحت الإنشاء',
                            onTap: () {
                              setState(() => _selectedStatus = 'تحت الإنشاء');
                              _applyFilter();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Result Count Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.apartment_rounded,
                              size: 18,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'تم العثور على ${_filteredBuildings.length} عمارة متاحة',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Building Grid / List
                      if (_filteredBuildings.isEmpty)
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
                            final isWide = constraints.maxWidth >= 800;
                            final cardWidth = isWide
                                ? (constraints.maxWidth - 24) / 2
                                : constraints.maxWidth;

                            return Wrap(
                              spacing: 24,
                              runSpacing: 24,
                              children: _filteredBuildings.asMap().entries.map((entry) {
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
      ),
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
