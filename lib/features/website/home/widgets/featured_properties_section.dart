import 'dart:async';

import 'package:flutter/material.dart';

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
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    _featuredFuture =
        Future.wait([
          PublicPropertyRepository.instance.all(),
          PublicBuildingRepository.instance.all(),
        ]).then((results) {
          final apartments = results[0] as List<Apartment>;
          final buildings = results[1] as List<Building>;

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Centered Section Bar Header ──────────────────────────────
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SectionBar(
                  index: 2,
                  icon: Icons.star_rounded,
                  title: 'عقارات مميزة',
                  subtitle: 'تصفح باقة شاملة من أفخم الشقق والعمارات المتاحة',
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Horizontal Auto-Scrolling Carousel with Standard Cards ─────
          SizedBox(
            height: 520,
            width: double.infinity,
            child: FutureBuilder<List<_FeaturedItem>>(
              future: _featuredFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                final items = snapshot.data ?? [];
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
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: displayItems.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 24),
                      itemBuilder: (context, index) {
                        final item = displayItems[index];
                        return SizedBox(
                          width: 350,
                          child: item.apartment != null
                              ? ApartmentCard(apartment: item.apartment!)
                              : BuildingCard(building: item.building!),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
