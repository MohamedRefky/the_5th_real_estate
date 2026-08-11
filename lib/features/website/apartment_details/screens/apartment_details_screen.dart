import 'package:flutter/material.dart';

import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/widgets/adaptive_network_image.dart';
import '../../../../core/widgets/details_table.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/whatsapp_floating_button.dart';
import '../../../../data/dummy_data.dart';
import '../../../../data/public_property_repository.dart';
import '../../../../models/apartment.dart';
import '../apartment_details_presenter.dart';
import '../widgets/amenities_grid.dart';
import '../widgets/construction_timeline.dart';
import '../widgets/description_section.dart';
import '../widgets/facade_cover.dart';
import '../widgets/other_units_in_area_section.dart';
import '../widgets/price_section.dart';
import '../widgets/stats_section.dart';
import '../widgets/title_header_section.dart';
import '../widgets/video_placeholder.dart';
import '../widgets/whatsapp_banner_card.dart';

/// Apartment Details Screen — Ultra-premium listing page.
class ApartmentDetailsScreen extends StatefulWidget {
  final String apartmentId;

  const ApartmentDetailsScreen({super.key, required this.apartmentId});

  @override
  State<ApartmentDetailsScreen> createState() => _ApartmentDetailsScreenState();
}

class _ApartmentDetailsScreenState extends State<ApartmentDetailsScreen> {
  Apartment? _apartment;
  bool _loading = true;
  bool _notFound = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final apt =
        await PublicPropertyRepository.instance.byId(widget.apartmentId) ??
        DummyData.getById(widget.apartmentId);
    if (!mounted) return;
    setState(() {
      _apartment = apt;
      _notFound = apt == null;
      _loading = false;
    });
  }

  List<DetailsRow> get _detailsRows => apartmentDetailsRows(_apartment!);

  String get _whatsAppMessage {
    final apartment = _apartment!;
    return 'مرحبًا، أنا مهتم بـ "${apartment.title}" في ${apartment.area}. '
        'هل يمكنني الحصول على مزيد من المعلومات وتحديد موعد معاينة؟';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const ScaffoldLoadingView();
    }

    final apartment = _apartment;

    if (apartment == null || _notFound) {
      return const ScaffoldNotFoundView(message: 'الشقة غير موجودة');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(apartment.area),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ── Floating Side WhatsApp CTA ────────────────────────────
      floatingActionButton: WhatsAppFloatingButton(
        phoneNumber: apartment.whatsappNumber,
        message: _whatsAppMessage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 1. Facade Cover Photo ───────────────────────
                  RevealOnScroll(
                    direction: RevealDirection.scale,
                    child: FacadeCoverPlaceholder(
                      imageUrl: apartment.coverImageUrl,
                      area: apartment.area,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── 2. Title & Address Header ───────────────────
                  RevealOnScroll(
                    direction: RevealDirection.fromRight,
                    child: TitleHeaderSection(apartment: apartment),
                  ),
                  const SizedBox(height: 20),

                  // ── 3. Price & Financials ───────────────────────
                  RevealOnScroll(
                    direction: RevealDirection.scale,
                    child: PriceSection(apartment: apartment),
                  ),
                  const SizedBox(height: 20),

                  // ── 4. Key Stats Grid ───────────────────────────
                  RevealOnScroll(
                    direction: RevealDirection.fromLeft,
                    child: StatsSection(apartment: apartment),
                  ),
                  const SizedBox(height: 28),

                  // ── 5. Image Gallery ────────────────────────────
                  if (apartment.imageUrls.isNotEmpty) ...[
                    const SectionHeader(
                      title: 'معرض صور الشقة',
                      icon: Icons.photo_library_rounded,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: apartment.imageUrls.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final cleanUrl = sanitizeImageUrl(
                            apartment.imageUrls[index],
                          );
                          return AdaptiveNetworkImage(
                            url: cleanUrl,
                            targetHeight: 180,
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _openImageDialog(context, cleanUrl),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── 6. Description Section ──────────────────────
                  RevealOnScroll(
                    direction: RevealDirection.fromRight,
                    child: DescriptionSection(apartment: apartment),
                  ),
                  const SizedBox(height: 28),

                  // ── 7. Amenities & Features Grid ────────────────
                  if (apartment.amenities.isNotEmpty) ...[
                    RevealOnScroll(
                      direction: RevealDirection.fromLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(
                            title: 'المميزات والتسهيلات',
                            icon: Icons.star_rounded,
                          ),
                          const SizedBox(height: 12),
                          AmenitiesGrid(amenities: apartment.amenities),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── 8. Details Table ────────────────────────────
                  RevealOnScroll(
                    direction: RevealDirection.fromLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(
                          title: 'جدول التفاصيل الكاملة',
                          icon: Icons.assignment_rounded,
                        ),
                        const SizedBox(height: 12),
                        DetailsTable(rows: _detailsRows),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── 9. Construction Timeline (if under construction) ─
                  if (apartment.isUnderConstruction &&
                      apartment.milestones.isNotEmpty) ...[
                    RevealOnScroll(
                      direction: RevealDirection.fromRight,
                      child: ConstructionTimeline(apartment: apartment),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── 10. Walkthrough Video ───────────────────────
                  if (apartment.videoUrl != null &&
                      apartment.videoUrl!.trim().isNotEmpty) ...[
                    RevealOnScroll(
                      direction: RevealDirection.fromRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHeader(
                            title: 'فيديو معاينة الشقة',
                            icon: Icons.videocam_rounded,
                          ),
                          const SizedBox(height: 12),
                          VideoPlaceholder(videoUrl: apartment.videoUrl),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── 11. WhatsApp Banner CTA ─────────────────────
                  RevealOnScroll(
                    direction: RevealDirection.scale,
                    child: WhatsAppBannerCard(apartment: apartment),
                  ),
                  const SizedBox(height: 32),

                  // ── 12. Similar Properties in Area ──────────────
                  RevealOnScroll(
                    direction: RevealDirection.fromRight,
                    child: OtherUnitsInAreaSection(
                      currentApartment: apartment,
                    ),
                  ),

                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openImageDialog(BuildContext context, String cleanUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.network(
                  cleanUrl,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
