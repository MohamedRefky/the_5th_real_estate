import 'package:flutter/material.dart';

import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/result_count_badge.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../core/widgets/searchable_hero_banner.dart';
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
          final screenWidth = MediaQuery.sizeOf(context).width;
          final isMobile = screenWidth < 600;
          final double spacing = isMobile ? 14.0 : 20.0;
          int count = 1;
          if (screenWidth >= 950) {
            count = 3;
          } else if (screenWidth >= 640) {
            count = 2;
          }

          return CustomScrollView(
            slivers: [
              // ── Animated Header Banner ────────────────────────────
              SliverToBoxAdapter(
                child: SearchableHeroBanner(
                  title: 'شقق ${widget.areaName}',
                  subtitle:
                      'تصفح أرقى الوحدات السكنية المتاحة واستخدم أدوات الفلترة للوصول لطلبك',
                  searchHint: 'ابحث بعنوان الشقة أو السعر...',
                  onSearchChanged: _controller.onSearchChanged,
                ),
              ),

              // ── Filters & Count Header ────────────────────────────
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        isMobile ? 14 : 24,
                        isMobile ? 14 : 24,
                        isMobile ? 14 : 24,
                        16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RevealOnScroll(
                            child: FilterSection(
                              onFiltersChanged: _controller.applyFilters,
                              onReset: _controller.resetFilters,
                            ),
                          ),
                          const SizedBox(height: 24),
                          RevealOnScroll(
                            delayMilliseconds: 100,
                            child: ResultCountBadge(
                              icon: Icons.home_work_rounded,
                              text:
                                  'تم العثور على ${apartments.length} شقة متاحة',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Apartment Grid or Empty / Loading States ─────────
              if (_controller.loading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 64),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                )
              else if (apartments.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: RevealOnScroll(
                      child: EmptyStateView(
                        icon: Icons.search_off_rounded,
                        title: 'لا توجد شقق مطابقة للبحث',
                        subtitle:
                            'جرب تغيير الفلاتر أو إعادة تعيين البحث للحصول على نتائج أخرى',
                      ),
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 14 : 24,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final rawWidth =
                                (constraints.maxWidth - (spacing * (count - 1))) /
                                    count;
                            final cardWidth = (count == 1 && constraints.maxWidth > 420)
                                ? 360.0
                                : rawWidth;

                            return Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              alignment: (count == 1 && constraints.maxWidth > 420)
                                  ? WrapAlignment.center
                                  : WrapAlignment.start,
                              children: apartments.asMap().entries.map((entry) {
                                final index = entry.key;
                                final apt = entry.value;
                                return SizedBox(
                                  width: cardWidth,
                                  child: isMobile
                                      ? ApartmentCard(apartment: apt)
                                      : RevealOnScroll(
                                          delayMilliseconds: (index % 4) * 70,
                                          child: ApartmentCard(apartment: apt),
                                        ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 48),
              ),
            ],
          );
        },
      ),
    );
  }
}
