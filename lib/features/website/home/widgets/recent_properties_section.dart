import 'package:flutter/material.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../data/dummy_data.dart';
import '../../../../models/apartment.dart';
import '../../area/widgets/apartment_card.dart';
import 'section_bar.dart';

/// Recently Added Properties section for Home Screen.
class RecentPropertiesSection extends StatelessWidget {
  const RecentPropertiesSection({super.key});

  /// Latest listings (first 3) — computed once, not per build.
  static final List<Apartment> _recentApartments =
      DummyData.apartments.take(3).toList();

  @override
  Widget build(BuildContext context) {
    final recentApartments = _recentApartments;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
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
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 900;
                  final isTablet = constraints.maxWidth >= 600;

                  final count = isDesktop ? 3 : (isTablet ? 2 : 1);
                  final spacing = 20.0;
                  final cardWidth = (constraints.maxWidth - (spacing * (count - 1))) / count;

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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
