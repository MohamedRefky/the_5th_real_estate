import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

import '../../../../data/public_building_repository.dart';
import '../../../../data/public_property_repository.dart';
import '../../../../models/apartment.dart';
import '../../../../models/building.dart';
import '../../area/widgets/apartment_card.dart';
import '../../building_area/widgets/building_card.dart';
import 'section_bar.dart';

class _FeaturedItem {
  final Apartment? apartment;
  final Building? building;

  const _FeaturedItem.apartment(this.apartment) : building = null;
  const _FeaturedItem.building(this.building) : apartment = null;
}

/// Featured Properties section — Auto-scrolling carousel displaying
/// original ApartmentCard and BuildingCard listings.
class FeaturedPropertiesSection extends StatefulWidget {
  const FeaturedPropertiesSection({super.key});

  @override
  State<FeaturedPropertiesSection> createState() =>
      _FeaturedPropertiesSectionState();
}

class _FeaturedPropertiesSectionState extends State<FeaturedPropertiesSection> {
  late final Future<List<_FeaturedItem>> _featuredFuture;
  List<_FeaturedItem>? _initialItems;
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  bool _isUserInteracting = false;

  static List<_FeaturedItem> _combineItems(
      List<Apartment> apartments, List<Building> buildings) {
    final items = <_FeaturedItem>[];
    final maxLen = apartments.length > buildings.length
        ? apartments.length
        : buildings.length;

    for (var i = 0; i < maxLen; i++) {
      if (i < apartments.length) {
        items.add(_FeaturedItem.apartment(apartments[i]));
      }
      if (i < buildings.length) {
        items.add(_FeaturedItem.building(buildings[i]));
      }
    }

    if (items.isEmpty) {
      items.addAll(apartments.map((a) => _FeaturedItem.apartment(a)));
      items.addAll(buildings.map((b) => _FeaturedItem.building(b)));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    final cachedApts = PublicPropertyRepository.instance.cachedItems;
    final cachedBldgs = PublicBuildingRepository.instance.cachedItems;

    if (cachedApts != null && cachedApts.isNotEmpty) {
      _initialItems = _combineItems(cachedApts, cachedBldgs ?? []);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAutoScroll();
      });
    }

    _featuredFuture =
        Future.wait([
          PublicPropertyRepository.instance.all(),
          PublicBuildingRepository.instance.all(),
        ]).then((results) {
          final apartments = results[0] as List<Apartment>;
          final buildings = results[1] as List<Building>;
          final items = _combineItems(apartments, buildings);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _startAutoScroll();
          });

          return items;
        });
  }

  void _startAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted ||
          _isUserInteracting ||
          !_scrollController.hasClients ||
          !_scrollController.position.hasContentDimensions) {
        return;
      }
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      if (maxScroll <= 0) return;

      double nextScroll = currentScroll + 1.2;
      if (nextScroll >= maxScroll) {
        _scrollController.jumpTo(0.0);
      } else {
        _scrollController.jumpTo(nextScroll);
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;
    final cardWidth = isMobile ? 255.0 : 350.0;
    final spacing = isMobile ? 12.0 : 24.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Centered Section Bar Header ──────────────────────────────
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                ),
                child: const SectionBar(
                  index: 2,
                  icon: Icons.star_rounded,
                  title: 'عقارات مميزة',
                  subtitle: 'تصفح باقة شاملة من أفخم الشقق والعمارات المتاحة',
                ),
              ),
            ),
          ),

          SizedBox(height: isMobile ? 12 : 20),

          // ── Horizontal Auto-Scrolling Carousel with Standard Cards ─────
          FutureBuilder<List<_FeaturedItem>>(
            initialData: _initialItems,
            future: _featuredFuture,
            builder: (context, snapshot) {
              final items = snapshot.data ?? [];
              if (items.isEmpty && snapshot.connectionState == ConnectionState.waiting) {
                return _buildSkeletonPlaceholder(cardWidth, spacing, isMobile);
              }
              if (items.isEmpty) {
                return const SizedBox.shrink();
              }

              final displayItems = items.length > 2
                  ? [...items, ...items, ...items, ...items]
                  : items;

              return MouseRegion(
                onEnter: (_) => setState(() => _isUserInteracting = true),
                onExit: (_) => setState(() => _isUserInteracting = false),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      _isUserInteracting = true;
                    } else if (notification is ScrollEndNotification) {
                      _isUserInteracting = false;
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 24,
                      vertical: isMobile ? 10 : 20,
                    ),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < displayItems.length; i++) ...[
                          if (i > 0) SizedBox(width: spacing),
                          SizedBox(
                            width: cardWidth,
                            child: displayItems[i].apartment != null
                                ? ApartmentCard(
                                    apartment: displayItems[i].apartment!,
                                  )
                                : BuildingCard(
                                    building: displayItems[i].building!,
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonPlaceholder(
    double cardWidth,
    double spacing,
    bool isMobile,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 10 : 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            _buildSkeletonCard(cardWidth, isMobile),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeletonCard(double cardWidth, bool isMobile) {
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10.5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryMedium.withValues(alpha: 0.35),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isMobile ? 18 : 24),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isMobile ? 11 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title line
                FractionallySizedBox(
                  widthFactor: 0.70,
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: isMobile ? 14 : 18,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 6 : 10),
                // Subtitle line
                FractionallySizedBox(
                  widthFactor: 0.90,
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: isMobile ? 11 : 14,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 10 : 16),
                // Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(
                    3,
                    (i) => Container(
                      height: isMobile ? 20 : 24,
                      width: isMobile ? 55 : 70,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 18),
                // Action button placeholder
                Container(
                  height: isMobile ? 32 : 42,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(isMobile ? 10 : 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
