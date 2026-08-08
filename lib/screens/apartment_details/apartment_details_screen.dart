import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/info_chip.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../data/dummy_data.dart';
import '../../models/apartment.dart';
import 'widgets/construction_timeline.dart';
import 'widgets/facade_cover.dart';
import 'widgets/image_gallery_placeholder.dart';
import 'widgets/video_placeholder.dart';

/// Helper launcher for WhatsApp messaging with cross-platform fallback.
Future<void> openWhatsAppForApartment(Apartment apartment) async {
  final message = Uri.encodeComponent(
    'مرحبًا، أنا مهتم بـ "${apartment.title}" في ${apartment.area}. '
    'هل يمكنني الحصول على مزيد من المعلومات وتحديد موعد معاينة؟',
  );
  final url = Uri.parse(
    'https://wa.me/${apartment.whatsappNumber}?text=$message',
  );
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  } catch (_) {
    await launchUrl(url);
  }
}

/// Apartment Details Screen — Ultra-premium listing page.
class ApartmentDetailsScreen extends StatelessWidget {
  final String apartmentId;

  const ApartmentDetailsScreen({super.key, required this.apartmentId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final apartment = DummyData.getById(apartmentId);

    if (apartment == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(
          child: Text('الشقة غير موجودة'),
        ),
      );
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
      floatingActionButton: _FloatingWhatsAppButton(apartment: apartment),
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
                        imageUrl: apartment.coverImageUrl,
                        area: apartment.area,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Title & Price Header (From Right) ──────────
                    RevealOnScroll(
                      direction: RevealDirection.fromRight,
                      child: _TitleSection(apartment: apartment, theme: theme),
                    ),

                    const SizedBox(height: 18),

                    // ── Key Stats (From Left) ──────────────────────
                    RevealOnScroll(
                      direction: RevealDirection.fromLeft,
                      child: _StatsSection(apartment: apartment),
                    ),

                    const SizedBox(height: 20),

                    // ── Walkthrough Video (From Right) ─────────────
                    RevealOnScroll(
                      direction: RevealDirection.fromRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: 'فيديو معاينة الشقة',
                            icon: Icons.videocam_rounded,
                            theme: theme,
                          ),
                          const SizedBox(height: 10),
                          VideoPlaceholder(videoUrl: apartment.videoUrl),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Interior Gallery (From Left) ───────────────
                    RevealOnScroll(
                      direction: RevealDirection.fromLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: 'معاينة الغرف والتصميم الداخلي',
                            icon: Icons.photo_library_rounded,
                            theme: theme,
                          ),
                          const SizedBox(height: 10),
                          const ImageGalleryPlaceholder(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Description (From Right) ───────────────────
                    RevealOnScroll(
                      direction: RevealDirection.fromRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: 'الوصف والتفاصيل الكاملة',
                            icon: Icons.description_rounded,
                            theme: theme,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.divider.withValues(alpha: 0.6),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              apartment.description,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                height: 1.8,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── WhatsApp Direct Callout Banner (Scale) ──────
                    RevealOnScroll(
                      direction: RevealDirection.scale,
                      child: _WhatsAppBannerCard(apartment: apartment, theme: theme),
                    ),

                    const SizedBox(height: 20),

                    // ── Amenities (From Left) ──────────────────────
                    if (apartment.amenities.isNotEmpty) ...[
                      RevealOnScroll(
                        direction: RevealDirection.fromLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SectionHeader(
                              title: 'المميزات والتسهيلات',
                              icon: Icons.star_rounded,
                              theme: theme,
                            ),
                            const SizedBox(height: 10),
                            _AmenitiesGrid(
                              amenities: apartment.amenities,
                              theme: theme,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Construction Timeline (From Right) ─────────
                    if (apartment.isUnderConstruction &&
                        apartment.milestones.isNotEmpty) ...[
                      RevealOnScroll(
                        direction: RevealDirection.fromRight,
                        child: ConstructionTimeline(apartment: apartment),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Details Table (From Left) ──────────────────
                    RevealOnScroll(
                      direction: RevealDirection.fromLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: 'جدول التفاصيل الكاملة',
                            icon: Icons.assignment_rounded,
                            theme: theme,
                          ),
                          const SizedBox(height: 10),
                          _DetailsTable(apartment: apartment, theme: theme),
                        ],
                      ),
                    ),

                    // ── Other Available Units (From Right) ─────────
                    if (apartment.buildingName != null) ...[
                      const SizedBox(height: 20),
                      RevealOnScroll(
                        direction: RevealDirection.fromRight,
                        child: _BuildingUnitsSection(
                          currentApartment: apartment,
                          theme: theme,
                        ),
                      ),
                    ],

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

// ═══════════════════════════════════════════════════════════════════
// Title Section
// ═══════════════════════════════════════════════════════════════════

class _TitleSection extends StatelessWidget {
  final Apartment apartment;
  final ThemeData theme;

  const _TitleSection({required this.apartment, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges row
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _Badge(
              label: apartment.finishingStatus.label,
              color: _finishingColor(apartment.finishingStatus),
            ),
            _Badge(
              label: apartment.area,
              color: AppColors.accentLight2,
            ),
            if (apartment.buildingName != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.domain_rounded,
                      size: 16,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      apartment.buildingName!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            if (apartment.isUnderConstruction)
              const _Badge(
                label: 'تحت الإنشاء',
                color: AppColors.warning,
              ),
          ],
        ),

        const SizedBox(height: 18),

        // Title
        Text(
          apartment.title,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 16),

        // Price Tag Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            apartment.formattedPrice,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        // Delivery date
        if (apartment.isUnderConstruction &&
            apartment.formattedDeliveryDate != null) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.event_rounded,
                  size: 20,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 8),
                Text(
                  'موعد التسليم المتوقع: ${apartment.formattedDeliveryDate}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Color _finishingColor(FinishingStatus status) {
    switch (status) {
      case FinishingStatus.finished:
        return AppColors.success;
      case FinishingStatus.semiFinished:
        return AppColors.info;
      case FinishingStatus.unfinished:
        return AppColors.textSecondary;
    }
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Stats Section
// ═══════════════════════════════════════════════════════════════════

class _StatsSection extends StatelessWidget {
  final Apartment apartment;

  const _StatsSection({required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _StatCard(
          icon: Icons.bed_rounded,
          value: '${apartment.rooms} غرف',
          label: 'غرف النوم',
        ),
        _StatCard(
          icon: Icons.bathtub_rounded,
          value: '${apartment.bathrooms} حمامات',
          label: 'الحمامات',
        ),
        _StatCard(
          icon: Icons.square_foot_rounded,
          value: '${apartment.areaSqm.toInt()} م²',
          label: 'المساحة',
        ),
        _StatCard(
          icon: Icons.layers_rounded,
          value: apartment.floorLabel,
          label: 'الدور',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: AppColors.textOnPrimary),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Section Header
// ═══════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final ThemeData theme;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.textOnPrimary, size: 20),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Amenities Grid
// ═══════════════════════════════════════════════════════════════════

class _AmenitiesGrid extends StatelessWidget {
  final List<String> amenities;
  final ThemeData theme;

  const _AmenitiesGrid({required this.amenities, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: amenities
          .map((amenity) => InfoChip(
                icon: Icons.check_circle_rounded,
                label: amenity,
                iconColor: AppColors.success,
              ))
          .toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Details Table
// ═══════════════════════════════════════════════════════════════════

class _DetailsTable extends StatelessWidget {
  final Apartment apartment;
  final ThemeData theme;

  const _DetailsTable({required this.apartment, required this.theme});

  @override
  Widget build(BuildContext context) {
    final details = [
      (Icons.location_on_rounded, 'الحي', apartment.area),
      (Icons.square_foot_rounded, 'المساحة الإجمالية', '${apartment.areaSqm.toInt()} م²'),
      (Icons.bed_rounded, 'عدد غرف النوم', '${apartment.rooms} غرف'),
      (Icons.bathtub_rounded, 'عدد الحمامات', '${apartment.bathrooms} حمام'),
      (Icons.layers_rounded, 'الدور الحالي', apartment.floorLabel),
      (Icons.apartment_rounded, 'إجمالي أدوار المبنى', '${apartment.totalFloors} أدوار'),
      (Icons.brush_rounded, 'مستوى التشطيب', apartment.finishingStatus.label),
      (Icons.monetization_on_rounded, 'السعر الإجمالي', apartment.formattedPrice),
      if (apartment.formattedDeliveryDate != null)
        (Icons.event_rounded, 'موعد التسليم المتوقع', apartment.formattedDeliveryDate!),
      (Icons.phone_iphone_rounded, 'رقم التواصل والمعاينة', apartment.whatsappNumber),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: List.generate(details.length, (index) {
          final (icon, label, value) = details[index];
          final isLast = index == details.length - 1;
          final isEven = index.isEven;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            decoration: BoxDecoration(
              color: isEven
                  ? AppColors.surface
                  : AppColors.cream.withValues(alpha: 0.7),
              borderRadius: isLast
                  ? const BorderRadius.vertical(bottom: Radius.circular(22))
                  : (index == 0
                      ? const BorderRadius.vertical(top: Radius.circular(22))
                      : null),
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        width: 0.8,
                      ),
                    ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: label == 'السعر الإجمالي' ? AppColors.accent : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// WhatsApp CTA
// ═══════════════════════════════════════════════════════════════════

class _FloatingWhatsAppButton extends StatelessWidget {
  final Apartment apartment;

  const _FloatingWhatsAppButton({required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => openWhatsAppForApartment(apartment),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF25D366),
                  Color(0xFF128C7E),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF25D366).withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 10),
                Text(
                  'تواصل معنا',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WhatsAppBannerCard extends StatelessWidget {
  final Apartment apartment;
  final ThemeData theme;

  const _WhatsAppBannerCard({required this.apartment, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF25D366).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF25D366).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF25D366).withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const FaIcon(
              FontAwesomeIcons.whatsapp,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مهتم بهذه الشقة؟',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'تواصل مباشرة مع المالك عبر واتساب للاستفسار وحجز المعاينة',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => openWhatsAppForApartment(apartment),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('تواصل الآن', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Other Available Units in the Same Building
// ═══════════════════════════════════════════════════════════════════

class _BuildingUnitsSection extends StatelessWidget {
  final Apartment currentApartment;
  final ThemeData theme;

  const _BuildingUnitsSection({
    required this.currentApartment,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final buildingUnits = DummyData.getByBuilding(currentApartment.buildingName!)
        .where((apt) => apt.id != currentApartment.id)
        .toList();

    if (buildingUnits.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'شقق أخرى متاحة في ${currentApartment.buildingName}',
          icon: Icons.apartment_rounded,
          theme: theme,
        ),
        const SizedBox(height: 14),
        Column(
          children: buildingUnits.map((apt) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutesNames.apartmentDetails,
                      arguments: apt.id,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.home_work_rounded,
                            color: AppColors.accent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                apt.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'الدور: ${apt.floorLabel} • ${apt.areaSqm.toInt()} م² • ${apt.rooms} غرف',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              apt.formattedPrice,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'عرض',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 12,
                                  color: AppColors.accent,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
