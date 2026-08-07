import 'package:flutter/material.dart';
import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/dummy_data.dart';
import '../../../models/apartment.dart';
import '../../area/widgets/apartment_card.dart';

/// Featured Properties section (horizontal carousel/list of luxury properties).
class FeaturedPropertiesSection extends StatelessWidget {
  const FeaturedPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: AppColors.accent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'عقارات مميزة',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'تصفح باقة من أفخم الوحدات المتاحة حالياً',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 410,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredApartments.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
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
