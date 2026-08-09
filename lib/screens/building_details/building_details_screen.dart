import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/reveal_on_scroll.dart';
import '../../data/dummy_data.dart';
import '../../models/building.dart';
import '../apartment_details/widgets/facade_cover.dart';

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

  void _load() {
    final bld = DummyData.getBuildingById(widget.buildingId);
    setState(() {
      _building = bld;
      _notFound = bld == null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final building = _building;

    if (building == null || _notFound) {
      return Scaffold(
        appBar: AppBar(title: const Text('خطأ')),
        body: const Center(
          child: Text(
            'العمارة غير موجودة',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
        ),
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
      floatingActionButton: _FloatingWhatsAppButton(building: building),
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
                    child: _TitleHeaderSection(
                      building: building,
                      theme: theme,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Description & Spec Highlights (From Right) ─
                  RevealOnScroll(
                    direction: RevealDirection.fromRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionHeader(
                          title: 'الوصف الكامل للعمارة',
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
                                color: AppColors.primary.withValues(
                                  alpha: 0.04,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                building.description,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.8,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (building.buildingStructure != null ||
                                  building.orientation != null ||
                                  building.layoutNote != null) ...[
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentLight,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.accent.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.stars_rounded,
                                        size: 20,
                                        color: AppColors.accent,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          [
                                            if (building.areaSqm != null)
                                              'مساحة الأرض: ${building.areaSqm!.toInt()}م²',
                                            if (building.buildingStructure !=
                                                null)
                                              building.buildingStructure!,
                                            if (building.orientation != null)
                                              'واجهة ${building.orientation!}',
                                            if (building.layoutNote != null)
                                              building.layoutNote!,
                                          ].join(' • '),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: AppColors.accent,
                                                fontWeight: FontWeight.w800,
                                                height: 1.5,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Key Stats (From Left) ──────────────────────
                  RevealOnScroll(
                    direction: RevealDirection.fromLeft,
                    child: _StatsSection(building: building),
                  ),

                  const SizedBox(height: 20),

                  // ── Price Section (Scale Reveal) ───────────────
                  RevealOnScroll(
                    direction: RevealDirection.scale,
                    child: _PriceSection(building: building, theme: theme),
                  ),

                  const SizedBox(height: 20),

                  // ── Construction Timeline (if under construction)
                  if (building.isUnderConstruction &&
                      building.milestones.isNotEmpty) ...[
                    RevealOnScroll(
                      direction: RevealDirection.fromRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(
                            title: 'مراحل ومواعيد البناء والتسليم',
                            icon: Icons.foundation_rounded,
                            theme: theme,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              children: building.milestones.map((m) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        m.isCompleted
                                            ? Icons.check_circle_rounded
                                            : Icons
                                                  .radio_button_unchecked_rounded,
                                        color: m.isCompleted
                                            ? AppColors.success
                                            : AppColors.textSecondary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          m.title,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
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
                          _SectionHeader(
                            title: 'المميزات والخدمات',
                            icon: Icons.star_rounded,
                            theme: theme,
                          ),
                          const SizedBox(height: 10),
                          _AmenitiesGrid(
                            amenities: building.amenities,
                            theme: theme,
                          ),
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
                        _SectionHeader(
                          title: 'جدول تفاصيل العمارة الكاملة',
                          icon: Icons.assignment_rounded,
                          theme: theme,
                        ),
                        const SizedBox(height: 10),
                        _BuildingDetailsTable(building: building, theme: theme),
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
          child: Icon(icon, size: 20, color: AppColors.accent),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Title & Header Section
// ═══════════════════════════════════════════════════════════════════

class _TitleHeaderSection extends StatelessWidget {
  final Building building;
  final ThemeData theme;

  const _TitleHeaderSection({required this.building, required this.theme});

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
              label: building.isUnderConstruction
                  ? 'تحت الإنشاء'
                  : 'جاهز للتسليم',
              color: building.isUnderConstruction
                  ? AppColors.warning
                  : AppColors.success,
            ),
            _Badge(label: building.area, color: AppColors.accentLight2),
            if (building.orientation != null)
              _Badge(label: building.orientation!, color: AppColors.accent),
            if (building.areaSqm != null)
              _Badge(
                label: '${building.areaSqm!.toInt()}م²',
                color: AppColors.primary,
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Title
        Text(
          building.name,
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.2),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Key Stats Section
// ═══════════════════════════════════════════════════════════════════

class _StatsSection extends StatelessWidget {
  final Building building;

  const _StatsSection({required this.building});

  @override
  Widget build(BuildContext context) {
    final stats = [
      if (building.areaSqm != null)
        (
          Icons.square_foot_rounded,
          'مساحة الأرض',
          '${building.areaSqm!.toInt()} م²',
        )
      else
        (
          Icons.layers_rounded,
          'إجمالي الأدوار',
          '${building.totalFloors} أدوار',
        ),
      (Icons.domain_rounded, 'إجمالي الشقق', '${building.totalUnits} شقة'),
      (
        Icons.door_front_door_rounded,
        'المتاح للبيع',
        '${building.availableUnits} شقة',
      ),
      (Icons.brush_rounded, 'مستوى التشطيب', building.finishingStatus.label),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((s) {
          final (icon, label, val) = s;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.accent, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                val,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Price Section
// ═══════════════════════════════════════════════════════════════════

class _PriceSection extends StatelessWidget {
  final Building building;
  final ThemeData theme;

  const _PriceSection({required this.building, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.monetization_on_rounded,
              color: AppColors.accent,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'السعر المطلوب / سعر العمارة',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  building.formattedStartingPrice,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Details Table
// ═══════════════════════════════════════════════════════════════════

class _BuildingDetailsTable extends StatelessWidget {
  final Building building;
  final ThemeData theme;

  const _BuildingDetailsTable({required this.building, required this.theme});

  @override
  Widget build(BuildContext context) {
    final details = [
      (Icons.location_on_rounded, 'الحي والمنطقة', building.area),
      if (building.areaSqm != null)
        (
          Icons.square_foot_rounded,
          'مساحة الأرض الإجمالية',
          '${building.areaSqm!.toInt()} م²',
        ),
      if (building.buildingStructure != null)
        (Icons.foundation_rounded, 'هيكل البناء', building.buildingStructure!),
      if (building.orientation != null)
        (Icons.explore_rounded, 'الواجهة والفيو', building.orientation!),
      if (building.layoutNote != null)
        (
          Icons.space_dashboard_rounded,
          'ملاحظة تقسيم الدور',
          building.layoutNote!,
        ),
      (
        Icons.layers_rounded,
        'إجمالي عدد الأدوار',
        '${building.totalFloors} أدوار',
      ),
      (
        Icons.grid_view_rounded,
        'إجمالي وحدات المبنى',
        '${building.totalUnits} شقة',
      ),
      (
        Icons.door_front_door_rounded,
        'الوحدات المتاحة للبيع',
        '${building.availableUnits} شقة',
      ),
      (Icons.brush_rounded, 'مستوى التشطيب', building.finishingStatus.label),
      (
        Icons.monetization_on_rounded,
        'السعر المطلوب',
        building.formattedStartingPrice,
      ),
      if (building.formattedDeliveryDate != null)
        (
          Icons.event_rounded,
          'موعد التسليم المتوقع',
          building.formattedDeliveryDate!,
        ),
      (
        Icons.phone_iphone_rounded,
        'رقم التواصل والمعاينة',
        building.whatsappNumber,
      ),
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
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.accent),
                const SizedBox(width: 14),
                Expanded(
                  flex: 4,
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
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
// Floating WhatsApp Button
// ═══════════════════════════════════════════════════════════════════

class _FloatingWhatsAppButton extends StatelessWidget {
  final Building building;

  const _FloatingWhatsAppButton({required this.building});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final message = Uri.encodeComponent(
      'مرحباً، أود الاستفسار عن ${building.name} في حي ${building.area}.',
    );
    final cleanPhone = building.whatsappNumber.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$message');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تعذر فتح واتساب على هذا الجهاز ($cleanPhone)'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25D366).withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _launchWhatsApp(context),
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        icon: const Icon(Icons.chat_rounded, size: 24),
        label: const Text(
          'تواصل عبر واتساب',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  final List<String> amenities;
  final ThemeData theme;

  const _AmenitiesGrid({required this.amenities, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: amenities.map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Text(
                amenity,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
