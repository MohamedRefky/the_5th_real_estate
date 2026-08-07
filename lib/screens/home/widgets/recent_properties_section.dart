import 'package:flutter/material.dart';
import '../../../data/dummy_data.dart';
import '../../area/widgets/apartment_card.dart';
import 'section_bar.dart';

/// Recently Added Properties section for Home Screen.
class RecentPropertiesSection extends StatelessWidget {
  const RecentPropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final recentApartments = DummyData.apartments.take(3).toList();

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

                  final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: crossAxisCount == 1 ? 1.05 : 0.82,
                    ),
                    itemCount: recentApartments.length,
                    itemBuilder: (context, index) {
                      return ApartmentCard(apartment: recentApartments[index]);
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
