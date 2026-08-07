import 'package:flutter/material.dart';
import '../../../data/dummy_data.dart';
import '../../area/widgets/apartment_card.dart';
import 'section_bar.dart';

/// Featured Properties section (horizontal carousel/list of luxury properties).
class FeaturedPropertiesSection extends StatelessWidget {
  const FeaturedPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter featured apartments (e.g., price >= 3.5M or penthouse)
    final featuredApartments = DummyData.apartments.where((apt) => apt.price >= 3500000).toList();

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
                height: 445,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredApartments.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final apt = featuredApartments[index];
                    return SizedBox(
                      width: 340,
                      child: ApartmentCard(apartment: apt),
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
