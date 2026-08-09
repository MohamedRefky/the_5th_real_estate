import 'package:flutter/material.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../data/dummy_data.dart';
import '../../../../models/apartment.dart';
import '../../area/widgets/apartment_card.dart';
import 'section_bar.dart';

/// Featured Properties section (horizontal carousel/list of luxury properties).
class FeaturedPropertiesSection extends StatelessWidget {
  const FeaturedPropertiesSection({super.key});

  /// Featured apartments (e.g., price >= 3.5M) — computed once, not per build.
  static final List<Apartment> _featuredApartments =
      DummyData.apartments.where((apt) => apt.price >= 3500000).toList();

  @override
  Widget build(BuildContext context) {
    final featuredApartments = _featuredApartments;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionBar(
                index: 2,
                icon: Icons.star_rounded,
                title: 'عقارات مميزة',
                subtitle: 'تصفح باقة من أفخم الوحدات المتاحة حالياً',
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 480,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredApartments.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final apt = featuredApartments[index];
                    final direction = index % 2 == 0
                        ? RevealDirection.fromRight
                        : RevealDirection.fromBottom;
                    return RevealOnScroll(
                      direction: direction,
                      delayMilliseconds: index * 75,
                      child: SizedBox(
                        width: 340,
                        child: ApartmentCard(apartment: apt),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
