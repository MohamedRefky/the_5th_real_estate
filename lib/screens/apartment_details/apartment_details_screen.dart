import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/info_chip.dart';
import '../../data/dummy_data.dart';
import '../../models/apartment.dart';
import 'widgets/construction_timeline.dart';
import 'widgets/image_gallery_placeholder.dart';

/// Apartment Details Screen — the full listing page.
///
/// Layout (scrollable):
/// 1. Image gallery placeholder
/// 2. Title, price, and badges
/// 3. Key stats row (rooms, bath, sqm, floor)
/// 4. Description
/// 5. Amenities
/// 6. Construction timeline (if under construction)
/// 7. WhatsApp CTA button (sticky bottom)
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ── Sticky WhatsApp CTA ──────────────────────────────────
      bottomNavigationBar: _WhatsAppCTA(apartment: apartment),

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image Gallery ──────────────────────────────
                  const ImageGalleryPlaceholder(),

                  const SizedBox(height: 28),

                  // ── Title & Price Header ───────────────────────
                  _TitleSection(apartment: apartment, theme: theme),

                  const SizedBox(height: 24),

                  // ── Key Stats ──────────────────────────────────
                  _StatsSection(apartment: apartment),

                  const SizedBox(height: 28),

                  // ── Description ────────────────────────────────
                  _SectionHeader(
                    title: 'الوصف',
                    icon: Icons.description_rounded,
                    theme: theme,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Text(
                      apartment.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Amenities ──────────────────────────────────
                  if (apartment.amenities.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'المميزات',
                      icon: Icons.star_rounded,
                      theme: theme,
                    ),
                    const SizedBox(height: 12),
                    _AmenitiesGrid(
                      amenities: apartment.amenities,
                      theme: theme,
                    ),
                    const SizedBox(height: 28),
                  ],

                  // ── Construction Timeline ──────────────────────
                  if (apartment.isUnderConstruction &&
                      apartment.milestones.isNotEmpty) ...[
                    ConstructionTimeline(apartment: apartment),
                    const SizedBox(height: 28),
                  ],

                  // ── Details Table ──────────────────────────────
                  _SectionHeader(
                    title: 'تفاصيل الشقة',
                    icon: Icons.info_outline_rounded,
                    theme: theme,
                  ),
                  const SizedBox(height: 12),
                  _DetailsTable(apartment: apartment, theme: theme),

                  const SizedBox(height: 100), // Space for sticky CTA
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
          spacing: 8,
          runSpacing: 8,
          children: [
            _Badge(
              label: apartment.finishingStatus.label,
              color: _finishingColor(apartment.finishingStatus),
            ),
            _Badge(
              label: apartment.area,
              color: AppColors.primary,
            ),
            if (apartment.isUnderConstruction)
              _Badge(
                label: 'تحت الإنشاء',
                color: AppColors.warning,
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Title
        Text(
          apartment.title,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 12),

        // Price
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, Color(0xFFD4B36A)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            apartment.formattedPrice,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // Delivery date
        if (apartment.isUnderConstruction &&
            apartment.formattedDeliveryDate != null) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.event_rounded,
                size: 20,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'هيتسلم ${apartment.formattedDeliveryDate}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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

// ═══════════════════════════════════════════════════════════════════
// Badge
// ═══════════════════════════════════════════════════════════════════

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
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
      spacing: 12,
      runSpacing: 12,
      children: [
        _StatCard(
          icon: Icons.bed_rounded,
          value: '${apartment.rooms}',
          label: 'غرف نوم',
        ),
        _StatCard(
          icon: Icons.bathtub_rounded,
          value: '${apartment.bathrooms}',
          label: 'حمامات',
        ),
        _StatCard(
          icon: Icons.square_foot_rounded,
          value: '${apartment.areaSqm.toInt()}',
          label: 'متر مربع',
        ),
        _StatCard(
          icon: Icons.layers_rounded,
          value: apartment.floorLabel,
          label: 'الدور',
        ),
        _StatCard(
          icon: Icons.apartment_rounded,
          value: '${apartment.totalFloors}',
          label: 'إجمالي الأدوار',
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
      width: 130,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.accent),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.accent, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
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
      spacing: 10,
      runSpacing: 10,
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
      ('الحي', apartment.area),
      ('المساحة', '${apartment.areaSqm.toInt()} م²'),
      ('الغرف', '${apartment.rooms} غرف'),
      ('الحمامات', '${apartment.bathrooms} حمام'),
      ('الدور', apartment.floorLabel),
      ('إجمالي الأدوار', '${apartment.totalFloors} أدوار'),
      ('التشطيب', apartment.finishingStatus.label),
      ('السعر', apartment.formattedPrice),
      if (apartment.formattedDeliveryDate != null)
        ('موعد التسليم', apartment.formattedDeliveryDate!),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: List.generate(details.length, (index) {
          final (label, value) = details[index];
          final isLast = index == details.length - 1;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: AppColors.divider, width: 0.5),
                    ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
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

class _WhatsAppCTA extends StatelessWidget {
  final Apartment apartment;

  const _WhatsAppCTA({required this.apartment});

  Future<void> _openWhatsApp() async {
    final message = Uri.encodeComponent(
      'مرحبًا، أنا مهتم بـ "${apartment.title}" في ${apartment.area}. '
      'هل يمكنني الحصول على مزيد من المعلومات؟',
    );
    final url = Uri.parse(
      'https://wa.me/${apartment.whatsappNumber}?text=$message',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _openWhatsApp,
                icon: const Icon(Icons.chat_rounded, size: 22),
                label: Text(
                  'تواصل مع المالك',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // WhatsApp green
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
