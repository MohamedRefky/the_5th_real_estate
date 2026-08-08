import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../data/dummy_data.dart';
import '../../models/apartment.dart';
import 'widgets/apartment_card.dart';
import 'widgets/filter_section.dart';

/// Ultra-premium Area Screen with animated header and search bar.
class AreaScreen extends StatefulWidget {
  final String areaName;

  const AreaScreen({super.key, required this.areaName});

  @override
  State<AreaScreen> createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  List<Apartment> _filteredApartments = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredApartments = DummyData.getByArea(widget.areaName);
  }

  void _applyFilters(FilterValues filters) {
    final all = DummyData.getByArea(widget.areaName);
    setState(() {
      _filteredApartments = all.where((apt) {
        // Search query keyword filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final titleMatch = apt.title.toLowerCase().contains(query);
          final descMatch = apt.description.toLowerCase().contains(query);
          if (!titleMatch && !descMatch) return false;
        }

        // Price range
        if (apt.price < filters.minPrice || apt.price > filters.maxPrice) {
          return false;
        }
        // Floor
        if (filters.floors.isNotEmpty && !filters.floors.contains(apt.floor)) {
          return false;
        }
        // Finishing status
        if (filters.finishingStatuses.isNotEmpty &&
            !filters.finishingStatuses.contains(apt.finishingStatus.name)) {
          return false;
        }
        // Rooms
        if (filters.rooms.isNotEmpty && !filters.rooms.contains(apt.rooms)) {
          return false;
        }
        // Bathrooms
        if (filters.bathrooms.isNotEmpty &&
            !filters.bathrooms.contains(apt.bathrooms)) {
          return false;
        }
        // Area (sqm) — matches any of the selected ranges.
        if (filters.areaRanges.isNotEmpty) {
          final matchesArea = filters.areaRanges
              .any((r) => apt.areaSqm >= r.$1 && apt.areaSqm <= r.$2);
          if (!matchesArea) return false;
        }
        return true;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchQuery = '';
      _filteredApartments = DummyData.getByArea(widget.areaName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('شقق ${widget.areaName}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBackground(
        shapeColor: AppColors.accent,
        shapeCount: 8,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Animated Header Banner ────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: AppColors.heroGradient,
                ),
                child: AnimatedBackground(
                  shapeColor: AppColors.accent,
                  shapeCount: 10,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          children: [
                            Text(
                              'شقق ${widget.areaName}',
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
                              'تصفح أرقى الوحدات السكنية المتاحة واستخدم أدوات الفلترة للوصول لطلبك',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Search input bar inside header
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.accent.withValues(alpha: 0.2),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  _searchQuery = value;
                                  _applyFilters(const FilterValues());
                                },
                                decoration: InputDecoration(
                                  hintText: 'ابحث باسم الشقة أو الوصف...',
                                  hintStyle: const TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: AppColors.accent,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                        // ── Filters Section ──────────────────────────────
                        RevealOnScroll(
                          child: FilterSection(
                            onFiltersChanged: _applyFilters,
                            onReset: _resetFilters,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Result Count Badge ───────────────────────────
                        RevealOnScroll(
                          delayMilliseconds: 100,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 18,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'تم العثور على ${_filteredApartments.length} شقة في ${widget.areaName}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Apartment Grid ───────────────────────────────
                        if (_filteredApartments.isEmpty)
                          const RevealOnScroll(child: _EmptyState())
                        else
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final crossAxisCount =
                                  constraints.maxWidth >= 800 ? 2 : 1;
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                  childAspectRatio:
                                      crossAxisCount == 2 ? 0.82 : 1.1,
                                ),
                                itemCount: _filteredApartments.length,
                                itemBuilder: (context, index) {
                                  return RevealOnScroll(
                                    delayMilliseconds: (index % 4) * 80,
                                    child: ApartmentCard(
                                      apartment:
                                          _filteredApartments[index],
                                    ),
                                  );
                                },
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Empty State
// ═══════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 56,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'لا توجد شقق مطابقة للبحث',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'جرب تغيير الفلاتر أو إعادة تعيين البحث للحصول على نتائج أخرى',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
