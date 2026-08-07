import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_data.dart';
import '../../models/apartment.dart';
import 'widgets/apartment_card.dart';
import 'widgets/filter_section.dart';

/// Area Screen — displays apartment listings for a specific neighborhood.
///
/// Features:
/// - Collapsible filter section (price, floor, finishing, rooms, bathrooms)
/// - Responsive grid of [ApartmentCard]s
/// - Empty state when no apartments match filters
/// - Result count indicator
class AreaScreen extends StatefulWidget {
  final String areaName;

  const AreaScreen({super.key, required this.areaName});

  @override
  State<AreaScreen> createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  List<Apartment> _filteredApartments = [];

  @override
  void initState() {
    super.initState();
    _filteredApartments = DummyData.getByArea(widget.areaName);
  }

  void _applyFilters(FilterValues filters) {
    final all = DummyData.getByArea(widget.areaName);
    setState(() {
      _filteredApartments = all.where((apt) {
        // Price range
        if (apt.price < filters.minPrice || apt.price > filters.maxPrice) {
          return false;
        }
        // Floor
        if (filters.floor != null && apt.floor != filters.floor) {
          return false;
        }
        // Finishing status
        if (filters.finishingStatus != null) {
          final statusName = apt.finishingStatus.name;
          if (statusName != filters.finishingStatus) return false;
        }
        // Rooms
        if (filters.rooms != null && apt.rooms != filters.rooms) {
          return false;
        }
        // Bathrooms
        if (filters.bathrooms != null && apt.bathrooms != filters.bathrooms) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _filteredApartments = DummyData.getByArea(widget.areaName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.areaName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Page Title ───────────────────────────────────
                  Text(
                    'شقق ${widget.areaName}',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'تصفح الشقق المتاحة واستخدم الفلاتر للوصول لطلبك',
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 24),

                  // ── Filters ──────────────────────────────────────
                  FilterSection(
                    onFiltersChanged: _applyFilters,
                    onReset: _resetFilters,
                  ),

                  const SizedBox(height: 24),

                  // ── Result Count ─────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'تم العثور على ${_filteredApartments.length} شقة',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Apartment List ───────────────────────────────
                  if (_filteredApartments.isEmpty)
                    _EmptyState(theme: theme)
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
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: crossAxisCount == 2 ? 0.85 : 1.2,
                          ),
                          itemCount: _filteredApartments.length,
                          itemBuilder: (context, index) {
                            return ApartmentCard(
                              apartment: _filteredApartments[index],
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Empty State
// ═══════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final ThemeData theme;
  const _EmptyState({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 72,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد شقق مطابقة',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'جرب تغيير الفلاتر للحصول على نتائج أخرى',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
