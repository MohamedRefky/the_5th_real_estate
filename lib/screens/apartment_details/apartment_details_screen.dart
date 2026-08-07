import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/info_chip.dart';
import '../../data/dummy_data.dart';
import '../../models/apartment.dart';
import 'widgets/construction_timeline.dart';
import 'widgets/image_gallery_placeholder.dart';

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

      // ── Sticky WhatsApp CTA ──────────────────────────────────
      bottomNavigationBar: _WhatsAppCTA(apartment: apartment),

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 950),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image Gallery ──────────────────────────────
                  const ImageGalleryPlaceholder(),

                  const SizedBox(height: 32),

                  // ── Title & Price Header ───────────────────────
                  _TitleSection(apartment: apartment, theme: theme),

                  const SizedBox(height: 28),

                  // ── Key Stats ──────────────────────────────────
                  _StatsSection(apartment: apartment),

                  const SizedBox(height: 32),

                  // ── Description ────────────────────────────────
                  _SectionHeader(
                    title: 'الوصف',
                    icon: Icons.description_rounded,
                    theme: theme,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
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
                        height: 1.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Amenities ──────────────────────────────────
                  if (apartment.amenities.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'المميزات والتسهيلات',
                      icon: Icons.star_rounded,
                      theme: theme,
                    ),
                    const SizedBox(height: 14),
                    _AmenitiesGrid(
                      amenities: apartment.amenities,
                      theme: theme,
                    ),
                    const SizedBox(height: 32),
                  ],

                  // ── Construction Timeline ──────────────────────
                  if (apartment.isUnderConstruction &&
                      apartment.milestones.isNotEmpty) ...[
                    ConstructionTimeline(apartment: apartment),
                    const SizedBox(height: 32),
                  ],

                  // ── Details Table ──────────────────────────────
                  _SectionHeader(
                    title: 'جدول التفاصيل',
                    icon: Icons.assignment_rounded,
                    theme: theme,
                  ),
                  const SizedBox(height: 14),
                  _DetailsTable(apartment: apartment, theme: theme),

                  const SizedBox(height: 120), // Space for sticky CTA
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
              color: AppColors.primary,
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
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 16),

        // Price Badge with Gold Gradient
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
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
      spacing: 14,
      runSpacing: 14,
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
      width: 140,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: AppColors.accent),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
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
            color: AppColors.primary,
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
      ('الحي', apartment.area),
      ('المساحة', '${apartment.areaSqm.toInt()} م²'),
      ('الغرف', '${apartment.rooms} غرف'),
      ('الحمامات', '${apartment.bathrooms} حمام'),
      ('الدور', apartment.floorLabel),
      ('إجمالي الأدوار', '${apartment.totalFloors} أدوار'),
      ('التشطيب', apartment.finishingStatus.label),
      ('السعر', apartment.formattedPrice),
      if (apartment.formattedDeliveryDate != null)
        ('موعد التسليم المتوقع', apartment.formattedDeliveryDate!),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
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
      child: Column(
        children: List.generate(details.length, (index) {
          final (label, value) = details[index];
          final isLast = index == details.length - 1;
          final isEven = index.isEven;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isEven
                  ? AppColors.surface
                  : AppColors.background.withValues(alpha: 0.5),
              borderRadius: isLast
                  ? const BorderRadius.vertical(bottom: Radius.circular(20))
                  : (index == 0
                      ? const BorderRadius.vertical(top: Radius.circular(20))
                      : null),
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: AppColors.divider.withValues(alpha: 0.4),
                        width: 0.5,
                      ),
                    ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
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
      'هل يمكنني الحصول على مزيد من المعلومات وتحديد موعد معاينة؟',
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
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -6),
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
                icon: const Icon(Icons.chat_rounded, size: 24),
                label: Text(
                  'تواصل مع المالك لتحديد معاينة',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 6,
                  shadowColor: const Color(0xFF25D366).withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
