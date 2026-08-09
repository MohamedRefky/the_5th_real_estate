import 'package:flutter/material.dart';

import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/result_count_badge.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import '../../../core/widgets/searchable_hero_banner.dart';
import '../controllers/area_controller.dart';
import '../widgets/apartment_card.dart';
import '../widgets/filter_section.dart';

/// Ultra-premium Area Screen with animated header and search bar.
class AreaScreen extends StatefulWidget {
  final String areaName;

  const AreaScreen({super.key, required this.areaName});

  @override
  State<AreaScreen> createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  late final AreaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AreaController(widget.areaName)..load();
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
        title: Text('شقق ${widget.areaName}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final apartments = _controller.filteredApartments;

          return SingleChildScrollView(
            child: Column(
              children: [
                // ── Animated Header Banner ────────────────────────────
                SearchableHeroBanner(
                  title: 'شقق ${widget.areaName}',
                  subtitle: 'تصفح أرقى الوحدات السكنية المتاحة واستخدم أدوات الفلترة للوصول لطلبك',
                  searchHint: 'ابحث بعنوان الشقة أو السعر...',
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
                          // ── Filters Section ──────────────────────────────
                          RevealOnScroll(
                            child: FilterSection(
                              onFiltersChanged: _controller.applyFilters,
                              onReset: _controller.resetFilters,
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── Result Count Badge ───────────────────────────
                          RevealOnScroll(
                            delayMilliseconds: 100,
                            child: ResultCountBadge(
                              icon: Icons.home_work_rounded,
                              text:
                                  'تم العثور على ${apartments.length} شقة متاحة',
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── Apartment Grid ───────────────────────────────
                          if (_controller.loading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 64),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (apartments.isEmpty)
                            const RevealOnScroll(
                              child: EmptyStateView(
                                icon: Icons.search_off_rounded,
                                title: 'لا توجد شقق مطابقة للبحث',
                                subtitle: 'جرب تغيير الفلاتر أو إعادة تعيين البحث للحصول على نتائج أخرى',
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
                                  children: apartments.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final apt = entry.value;
                                    return SizedBox(
                                      width: cardWidth,
                                      child: RevealOnScroll(
                                        delayMilliseconds: (index % 4) * 80,
                                        child: ApartmentCard(apartment: apt),
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
}
