import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../auth/auth_controller.dart';
import '../data/area_catalog.dart';
import '../models/admin_building.dart';
import '../models/property.dart';
import '../services/building_service.dart';
import '../services/property_service.dart';
import '../widgets/admin_area_card.dart';
import '../widgets/admin_building_card.dart';
import '../widgets/message_view.dart';
import '../widgets/property_card.dart';
import 'building_form_screen.dart';
import 'property_form_screen.dart';

/// Simplified & Ultra-Clean Admin Dashboard.
///
/// Features a streamlined single-page workflow with:
///  - High-visibility Add buttons at the top
///  - Live Stats Overview
///  - Instant Search & Neighborhood Dropdown Filter
///  - Unified listings view with toggle switches, edit & delete buttons
///  - Optional district-grouped overview
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<List<Property>> _unitsFuture;
  late Future<List<AdminBuilding>> _buildingsFuture;

  String _selectedArea = 'الكل';
  String _filterType = 'all'; // 'all', 'unit', 'building'
  String _statusFilter = 'all'; // 'all', 'published', 'hidden'
  String _searchQuery = '';
  String _viewMode = 'list'; // 'list', 'areas'

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _unitsFuture = PropertyService.instance.fetchAll();
      _buildingsFuture = BuildingService.instance.fetchAll();
    });
  }

  Future<void> _logout() async {
    await AuthController.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RoutesNames.adminLogin);
  }

  bool _areaMatches(String itemArea, String targetArea) {
    if (targetArea == 'الكل') return true;
    final cleanItem = itemArea
        .trim()
        .replaceAll('حي ', '')
        .replaceAll('منطقة ', '')
        .replaceAll('جاردنيا', 'جاردينيا');
    final cleanTarget = targetArea
        .trim()
        .replaceAll('حي ', '')
        .replaceAll('منطقة ', '')
        .replaceAll('جاردنيا', 'جاردينيا');
    if (cleanItem == cleanTarget) return true;
    return cleanItem.contains(cleanTarget) || cleanTarget.contains(cleanItem);
  }

  Future<void> _openUnitForm({Property? property, String? initialArea}) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PropertyFormScreen(
          property: property,
          initialArea: initialArea,
        ),
      ),
    );
    _reload();
  }

  Future<void> _openBuildingForm(
      {AdminBuilding? building, String? initialArea}) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BuildingFormScreen(
          building: building,
          initialArea: initialArea,
        ),
      ),
    );
    _reload();
  }

  Future<void> _confirmDeleteUnit(Property property) async {
    final confirmed = await _confirm(
      title: 'حذف الوحدة؟',
      message:
          'سيتم حذف "${property.projectName} - ${property.floor}" نهائياً ولا يمكن التراجع.',
    );
    if (confirmed != true) return;
    await PropertyService.instance.delete(property.id!, property);
    _reload();
  }

  Future<void> _confirmDeleteBuilding(AdminBuilding building) async {
    final confirmed = await _confirm(
      title: 'حذف العمارة؟',
      message: 'سيتم حذف "${building.name}" نهائياً ولا يمكن التراجع.',
    );
    if (confirmed != true) return;
    await BuildingService.instance.delete(building.id!, building);
    _reload();
  }

  Future<bool?> _confirm({required String title, required String message}) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider),
        ),
        title:
            Text(title, style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(message,
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _togglePublishedUnit(Property property, bool value) async {
    await PropertyService.instance.setPublished(property.id!, property, value);
    _reload();
  }

  Future<void> _togglePublishedBuilding(
      AdminBuilding building, bool value) async {
    await BuildingService.instance
        .setPublished(building.id!, building, value);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([_unitsFuture, _buildingsFuture]),
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState != ConnectionState.done;
        final units =
            (snapshot.data?[0] as List<Property>?) ?? const <Property>[];
        final buildings = (snapshot.data?[1] as List<AdminBuilding>?) ??
            const <AdminBuilding>[];

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: const Text(
              'لوحة تحكم الأدمن',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 19,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'تحديث البيانات',
                onPressed: _reload,
                icon:
                    const Icon(Icons.refresh_rounded, color: AppColors.accent),
              ),
              IconButton(
                tooltip: 'تسجيل الخروج',
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              ),
            ],
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                )
              : snapshot.hasError
                  ? _buildError(snapshot.error!)
                  : RefreshIndicator(
                      color: AppColors.accent,
                      onRefresh: () async => _reload(),
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // ── 1. Prominent Quick Add Buttons ─────────
                          _buildQuickAddHeader(),
                          const SizedBox(height: 16),

                          // ── 2. Simple Stats Row ────────────────────
                          _buildStatsRow(units, buildings),
                          const SizedBox(height: 20),

                          // ── 3. Controls & View Mode Toggle ─────────
                          _buildControlsBar(),
                          const SizedBox(height: 16),

                          // ── 4. Main Body Content ───────────────────
                          if (_viewMode == 'areas')
                            _buildAreaOverview(units, buildings)
                          else
                            _buildListContent(units, buildings),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 48),
            const SizedBox(height: 12),
            Text(
              'تعذر جلب البيانات من Firebase:\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Quick Add Header Buttons ──────────────────────────────────────────

  Widget _buildQuickAddHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إضافة عقار جديد',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _openUnitForm(
                      initialArea:
                          _selectedArea == 'الكل' ? null : _selectedArea),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.textOnPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_home_rounded, size: 20),
                  label: const Text(
                    'إضافة شقة / فيلا',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _openBuildingForm(
                      initialArea:
                          _selectedArea == 'الكل' ? null : _selectedArea),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.domain_add_rounded, size: 20),
                  label: const Text(
                    'إضافة عمارة كاملة',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Stats Summary Bar ─────────────────────────────────────────────────

  Widget _buildStatsRow(List<Property> units, List<AdminBuilding> buildings) {
    final publishedUnits = units.where((u) => u.isPublished).length;
    final publishedBuildings = buildings.where((b) => b.isPublished).length;
    final totalPublished = publishedUnits + publishedBuildings;
    final totalHidden = (units.length + buildings.length) - totalPublished;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              _statItem(Icons.apartment_rounded, units.length, 'شقق وفيلات',
                  AppColors.accent),
              _statDivider(),
              _statItem(Icons.business_rounded, buildings.length, 'عمارات',
                  const Color(0xFFC084FC)),
              _statDivider(),
              _statItem(Icons.visibility_rounded, totalPublished, 'منشور',
                  AppColors.success),
              _statDivider(),
              _statItem(Icons.visibility_off_rounded, totalHidden, 'مخفي',
                  AppColors.warning),
            ],
          ),
        );
      },
    );
  }

  Widget _statItem(IconData icon, int count, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(width: 1, height: 44, color: AppColors.divider);
  }

  // ── Unified Controls & Filters ────────────────────────────────────────

  Widget _buildControlsBar() {
    final allAreasOptions = ['الكل', ...areaOptions];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // Row 1: Search Box & View Mode Toggle
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'ابحث باسم المشروع، العمارة، أو الكلمات...',
                    hintStyle:
                        const TextStyle(color: AppColors.textHint, fontSize: 13),
                    prefixIcon:
                        const Icon(Icons.search_rounded, color: AppColors.accent),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded,
                                color: AppColors.textSecondary, size: 18),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: AppColors.accent, width: 1.5),
                    ),
                  ),
                  onChanged: (val) =>
                      setState(() => _searchQuery = val.trim().toLowerCase()),
                ),
              ),
              const SizedBox(width: 10),
              // View Mode Selector (List vs Areas)
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'list',
                    icon: Icon(Icons.format_list_bulleted_rounded, size: 18),
                    label: Text('القائمة'),
                  ),
                  ButtonSegment(
                    value: 'areas',
                    icon: Icon(Icons.grid_view_rounded, size: 18),
                    label: Text('المناطق'),
                  ),
                ],
                selected: {_viewMode},
                onSelectionChanged: (val) =>
                    setState(() => _viewMode = val.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : AppColors.background,
                  ),
                ),
              ),
            ],
          ),

          if (_viewMode == 'list') ...[
            const SizedBox(height: 14),
            // Row 2: Area Selector Dropdown + Type Filters
            Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                // Area Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: allAreasOptions.contains(_selectedArea)
                          ? _selectedArea
                          : 'الكل',
                      icon: const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.accent),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedArea = val);
                      },
                      items: allAreasOptions.map((area) {
                        return DropdownMenuItem<String>(
                          value: area,
                          child: Text(area == 'الكل' ? 'كل المناطق 🏙️' : area),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // Type Filter Chips
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _filterChip('all', 'الكل'),
                    const SizedBox(width: 6),
                    _filterChip('unit', 'شقق/فيلات'),
                    const SizedBox(width: 6),
                    _filterChip('building', 'عمارات'),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _filterChip(String value, String label) {
    final isSelected = _filterType == value;
    return ChoiceChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      selectedColor: AppColors.accent,
      backgroundColor: AppColors.background,
      onSelected: (_) => setState(() => _filterType = value),
    );
  }

  // ── Unified Listings Content View ─────────────────────────────────────

  Widget _buildListContent(
      List<Property> units, List<AdminBuilding> buildings) {
    // 1. Filter by Area
    final areaUnits =
        units.where((u) => _areaMatches(u.area, _selectedArea)).toList();
    final areaBuildings =
        buildings.where((b) => _areaMatches(b.area, _selectedArea)).toList();

    // 2. Filter by Search Query
    final query = _searchQuery.toLowerCase();
    final filteredUnits = areaUnits.where((u) {
      if (query.isEmpty) return true;
      return u.projectName.toLowerCase().contains(query) ||
          (u.description?.toLowerCase().contains(query) ?? false) ||
          u.area.toLowerCase().contains(query);
    }).toList();

    final filteredBuildings = areaBuildings.where((b) {
      if (query.isEmpty) return true;
      return b.name.toLowerCase().contains(query) ||
          b.description.toLowerCase().contains(query) ||
          b.area.toLowerCase().contains(query);
    }).toList();

    final showUnits = _filterType == 'all' || _filterType == 'unit';
    final showBuildings = _filterType == 'all' || _filterType == 'building';

    final displayUnits = showUnits ? filteredUnits : <Property>[];
    final displayBuildings = showBuildings ? filteredBuildings : <AdminBuilding>[];

    final totalCount = displayUnits.length + displayBuildings.length;

    if (totalCount == 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: MessageView(
          icon: Icons.search_off_rounded,
          title: 'لا توجد عقارات مطابقة',
          message:
              'لم نجد عقارات تطابق خيارات البحث الحالية. يمكنك تغيير التصفية أو إضافة عقار جديد.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayUnits.isNotEmpty) ...[
          _sectionHeader(
            icon: Icons.apartment_rounded,
            color: AppColors.accent,
            label: 'الشقق والفيلات',
            count: displayUnits.length,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayUnits.length,
            itemBuilder: (context, index) {
              final property = displayUnits[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PropertyCard(
                  property: property,
                  onEdit: () => _openUnitForm(property: property),
                  onDelete: () => _confirmDeleteUnit(property),
                  onToggle: (v) => _togglePublishedUnit(property, v),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        if (displayBuildings.isNotEmpty) ...[
          _sectionHeader(
            icon: Icons.business_rounded,
            color: const Color(0xFFC084FC),
            label: 'العمارات السكنية',
            count: displayBuildings.length,
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayBuildings.length,
            itemBuilder: (context, index) {
              final building = displayBuildings[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AdminBuildingCard(
                  building: building,
                  onEdit: () => _openBuildingForm(building: building),
                  onDelete: () => _confirmDeleteBuilding(building),
                  onToggle: (v) => _togglePublishedBuilding(building, v),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required Color color,
    required String label,
    required int count,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label ($count)',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ── Area Overview Grid ────────────────────────────────────────────────

  Widget _buildAreaOverview(
      List<Property> units, List<AdminBuilding> buildings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final group in adminAreaGroups) ...[
          Row(
            children: [
              Icon(group.icon, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                group.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildAreaGrid(units, buildings, group.areas),
          const SizedBox(height: 22),
        ],
      ],
    );
  }

  Widget _buildAreaGrid(
    List<Property> units,
    List<AdminBuilding> buildings,
    List<String> areas,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 640;
        final cardWidth = twoColumns
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final area in areas)
              SizedBox(
                width: cardWidth,
                child: AdminAreaCard(
                  area: area,
                  unitCount:
                      units.where((u) => _areaMatches(u.area, area)).length,
                  buildingCount: buildings
                      .where((b) => _areaMatches(b.area, area))
                      .length,
                  onOpen: () {
                    setState(() {
                      _selectedArea = area;
                      _viewMode = 'list';
                    });
                  },
                  onAddUnit: () => _openUnitForm(initialArea: area),
                  onAddBuilding: () => _openBuildingForm(initialArea: area),
                ),
              ),
          ],
        );
      },
    );
  }
}
