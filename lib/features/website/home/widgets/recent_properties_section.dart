import 'package:flutter/material.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../data/public_property_repository.dart';
import '../../../../models/apartment.dart';
import '../../area/widgets/apartment_card.dart';
import 'section_bar.dart';

/// Recently Added Properties section for Home Screen.
class RecentPropertiesSection extends StatefulWidget {
  const RecentPropertiesSection({super.key});

  @override
  State<RecentPropertiesSection> createState() =>
      _RecentPropertiesSectionState();
}

class _RecentPropertiesSectionState extends State<RecentPropertiesSection> {
  late final Future<List<Apartment>> _recentFuture;

  @override
  void initState() {
    super.initState();
    _recentFuture = PublicPropertyRepository.instance.all().then(
          (all) => all.take(3).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: isMobile ? 16 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionBar(
                index: 3,
                icon: Icons.new_releases_rounded,
                title: 'أحدث العقارات المضافة',
                subtitle: 'وحدات جديدة تم إضافتها مؤخراً لقائمتنا',
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Apartment>>(
                future: _recentFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  final recentApartments = snapshot.data ?? [];
                  if (recentApartments.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 900;
                      final isTablet = constraints.maxWidth >= 600;

                      final count = isDesktop ? 3 : (isTablet ? 2 : 1);
                      final spacing = isMobile ? 14.0 : 20.0;
                      final cardWidth =
                          (constraints.maxWidth - (spacing * (count - 1))) /
                              count;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        children: recentApartments.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final apt = entry.value;
                          return SizedBox(
                            width: cardWidth,
                            child: RevealOnScroll(
                              direction: RevealDirection.fromBottom,
                              delayMilliseconds: idx * 90,
                              child: ApartmentCard(apartment: apt),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
