import 'package:flutter/material.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../data/public_property_repository.dart';
import '../../../../models/apartment.dart';
import '../../area/widgets/apartment_card.dart';
import 'section_bar.dart';

/// Featured Properties section (horizontal carousel/list of luxury properties).
class FeaturedPropertiesSection extends StatefulWidget {
  const FeaturedPropertiesSection({super.key});

  @override
  State<FeaturedPropertiesSection> createState() =>
      _FeaturedPropertiesSectionState();
}

class _FeaturedPropertiesSectionState
    extends State<FeaturedPropertiesSection> {
  late final Future<List<Apartment>> _featuredFuture;

  @override
  void initState() {
    super.initState();
    _featuredFuture = PublicPropertyRepository.instance.all().then((all) {
      final filtered = all.where((apt) => apt.price >= 3500000).toList();
      return filtered.isNotEmpty ? filtered : all.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                child: FutureBuilder<List<Apartment>>(
                  future: _featuredFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final featuredApartments = snapshot.data ?? [];
                    if (featuredApartments.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
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
