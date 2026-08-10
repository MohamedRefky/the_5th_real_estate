import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/details_table.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/whatsapp_floating_button.dart';
import '../../../../data/public_building_repository.dart';
import '../../../../models/building.dart';
import '../../apartment_details/widgets/facade_cover.dart';
import '../building_details_presenter.dart';
import '../widgets/amenities_grid.dart';
import '../widgets/construction_timeline_section.dart';
import '../widgets/description_section.dart';
import '../widgets/price_section.dart';
import '../widgets/stats_section.dart';
import '../widgets/title_header_section.dart';

/// Ultra-premium details screen for residential buildings.
class BuildingDetailsScreen extends StatefulWidget {
  final String buildingId;

  const BuildingDetailsScreen({super.key, required this.buildingId});

  @override
  State<BuildingDetailsScreen> createState() => _BuildingDetailsScreenState();
}

class _BuildingDetailsScreenState extends State<BuildingDetailsScreen> {
  Building? _building;
  bool _loading = true;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bld =
        await PublicBuildingRepository.instance.byId(widget.buildingId);
    if (!mounted) return;
    setState(() {
      _building = bld;
      _notFound = bld == null;
      _loading = false;
    });
  }

  List<DetailsRow> get _detailsRows => buildingDetailsRows(_building!);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const ScaffoldLoadingView();
    }

    final building = _building;

    if (building == null || _notFound) {
      return const ScaffoldNotFoundView(
        message: 'العمارة غير موجودة',
        styled: true,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('عقارات ${building.area}'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ── Floating Side WhatsApp CTA ────────────────────────────
      floatingActionButton: WhatsAppFloatingButton(
        phoneNumber: building.whatsappNumber,
        message: 'مرحباً، أود الاستفسار عن ${building.name} في حي ${building.area}.',
        failureMessage:
            'تعذر فتح واتساب على هذا الجهاز (${building.whatsappNumber.replaceAll(RegExp(r'\D'), '')})',
        variant: WhatsAppFloatingButtonVariant.fabExtended,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Facade Cover Photo (Scale Reveal) ───────────
                  RevealOnScroll(
                    direction: RevealDirection.scale,
                    child: FacadeCoverPlaceholder(
                      imageUrl: building.coverImageUrl,
                      area: building.area,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Title & Badges (From Left) ─────────────────
                  RevealOnScroll(
                    direction: RevealDirection.fromLeft,
                    child: TitleHeaderSection(building: building),
                  ),
                  const SizedBox(height: 20),

                  // ── Description & Spec Highlights (From Right) ─
                  RevealOnScroll(
                    direction: RevealDirection.fromRight,
                    child: DescriptionSection(building: building),
                  ),

                  const SizedBox(height: 20),

                  // ── Key Stats (From Left) ──────────────────────
                  if (building.areaSqm != null && building.areaSqm! > 0) ...[
                    RevealOnScroll(
                      direction: RevealDirection.fromLeft,
                      child: StatsSection(building: building),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Price Section (Scale Reveal) ───────────────
                  if (building.startingPrice > 0) ...[
                    RevealOnScroll(
                      direction: RevealDirection.scale,
                      child: PriceSection(building: building),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Construction Timeline (if under construction)
                  if (building.isUnderConstruction &&
                      building.milestones.isNotEmpty) ...[
                    RevealOnScroll(
                      direction: RevealDirection.fromRight,
                      child: ConstructionTimelineSection(building: building),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Amenities (From Left) ──────────────────────
                  if (building.amenities.isNotEmpty) ...[
                    RevealOnScroll(
                      direction: RevealDirection.fromLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(
                            title: 'المميزات والخدمات',
                            icon: Icons.star_rounded,
                            gradient: false,
                          ),
                          const SizedBox(height: 10),
                          AmenitiesGrid(amenities: building.amenities),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Details Table (From Left) ──────────────────
                  RevealOnScroll(
                    direction: RevealDirection.fromLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          title: 'جدول تفاصيل العمارة الكاملة',
                          icon: Icons.assignment_rounded,
                          gradient: false,
                        ),
                        const SizedBox(height: 10),
                        DetailsTable(
                          rows: _detailsRows,
                          layout: DetailsTableLayout.flex,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Browse Apartments Button ───────────────────
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          RoutesNames.area,
                          arguments: building.area,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      icon: const Icon(Icons.apartment_rounded),
                      label: Text(
                        'عرض الشقق المتاحة في ${building.area}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 90), // Space for sticky CTA
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
