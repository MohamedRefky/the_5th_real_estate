import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/apartment.dart' show FinishingStatus;
import '../auth/auth_controller.dart';
import '../models/admin_building.dart';
import '../models/property.dart';
import '../services/building_service.dart';
import '../services/data_migration_service.dart';
import '../services/property_service.dart';
import '../widgets/admin_building_card.dart';
import '../widgets/message_view.dart';
import '../widgets/property_card.dart';
import 'building_form_screen.dart';
import 'property_form_screen.dart';

/// Hidden admin dashboard — lists all units and buildings organized by neighborhood
/// tabs (الكل, المستثمرين, الأندلس, جاردينيا, بيت الوطن, النرجس الجديدة)
/// with edit / delete / publish toggles and live Firestore sync.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Property>> _unitsFuture;
  late Future<List<AdminBuilding>> _buildingsFuture;

  late TabController _tabController;

  static const List<String> _areas = [
    'الكل',
    'المستثمرين',
    'الأندلس',
    'جاردينيا',
    'بيت الوطن',
    'النرجس الجديدة',
  ];

  String _searchQuery = '';
  String _filterType = 'all'; // 'all', 'unit', 'building'
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _areas.length, vsync: this);
    _reload();
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  Future<void> _openAddChooser() async {
    final activeAreaIndex = _tabController.index;
    final defaultArea =
        activeAreaIndex > 0 ? _areas[activeAreaIndex] : 'المستثمرين';

    final choice = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.divider),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'إضافة عقار جديد ($defaultArea)',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close_rounded,
                        color: AppColors.textSecondary, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _chooserOption(
                icon: Icons.apartment_rounded,
                title: 'شقة / فيلا / دوبلكس / استوديو',
                subtitle: 'تضاف في قسم $defaultArea',
                value: 'unit',
              ),
              const SizedBox(height: 12),
              _chooserOption(
                icon: Icons.business_rounded,
                title: 'عمارة بالكامل',
                subtitle: 'تضاف في قسم $defaultArea',
                value: 'building',
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted) return;
    if (choice == 'building') {
      await _openBuildingForm(initialArea: defaultArea);
    } else if (choice == 'unit') {
      await _openUnitForm(initialArea: defaultArea);
    }
    _reload();
  }

  Widget _chooserOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pop(context, value),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_left_rounded,
                  color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUnitForm({Property? property, String? initialArea}) async {
    final initialProperty = property ??
        (initialArea != null
            ? Property(
                projectName: '',
                unitType: UnitType.apartment,
                floor: 'أرضي',
                areaSqm: 120,
                bedrooms: 2,
                bathrooms: 1,
                hasReception: true,
                hasKitchen: true,
                finishingStatus: PropertyFinishing.finished,
                price: 2000000,
                area: initialArea,
              )
            : null);

    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PropertyFormScreen(property: initialProperty),
      ),
    );
    _reload();
  }

  Future<void> _openBuildingForm(
      {AdminBuilding? building, String? initialArea}) async {
    final initialBuilding = building ??
        (initialArea != null
            ? AdminBuilding(
                name: '',
                description: '',
                area: initialArea,
                startingPrice: 3000000,
                totalFloors: 5,
                totalUnits: 10,
                availableUnits: 4,
                finishingStatus: FinishingStatus.semiFinished,
                whatsappNumber: '+201000000001',
              )
            : null);

    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BuildingFormScreen(building: initialBuilding),
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
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
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

  Future<void> _runMigration() async {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider),
        ),
        title: const Text('ترحيل البيانات القديمة؟',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'هتتحول الوحدات اللي في كلكشن properties القديم إلى فولدرات المناطق الجديدة (كل وحدة في فولدر حيها). تبقى تكمل بعدها وتشيل الكلكشن القديم.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ترحيل'),
          ),
        ],
      ),
    );
    if (proceed != true) return;

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري الترحيل...')),
    );

    final result = await DataMigrationService.migrateLegacyProperties();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.hasFailures
              ? 'تم ترحيل ${result.migrated}، فشل ${result.failed} (انقلهم يدوياً).'
              : 'تم ترحيل ${result.migrated}، ${result.skipped} مكررة بالفعل.',
        ),
      ),
    );

    final deleteLegacy = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider),
        ),
        title: const Text('مسح كلكشن properties القديم؟',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'بعد الترحيل الناجح ممكن تتشال الدوكس القديمة من الكلكشن المسطح عشان الموقع ما يقراهاش تاني.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('بعدين',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('امسح القديم'),
          ),
        ],
      ),
    );
    if (deleteLegacy != true) {
      _reload();
      return;
    }

    final cleanup = await DataMigrationService.migrateLegacyProperties(
      deleteLegacy: true,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('اتمسح ${cleanup.deleted} مستند قديم.')),
    );
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
            title: _showSearch
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'ابحث بالاسم، الوصف، أو الحي...',
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: AppColors.textSecondary),
                        onPressed: () {
                          setState(() {
                            _showSearch = false;
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      ),
                    ),
                    onChanged: (val) =>
                        setState(() => _searchQuery = val.trim().toLowerCase()),
                  )
                : const Text(
                    'لوحة تحكم العقارات',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            actions: [
              IconButton(
                tooltip: _showSearch ? 'إغلاق البحث' : 'بحث',
                onPressed: () => setState(() => _showSearch = !_showSearch),
                icon: Icon(
                  _showSearch
                      ? Icons.search_off_rounded
                      : Icons.search_rounded,
                  color: AppColors.accent,
                ),
              ),
              IconButton(
                tooltip: 'تحديث البيانات',
                onPressed: _reload,
                icon: const Icon(Icons.refresh_rounded, color: AppColors.accent),
              ),
              IconButton(
                tooltip: 'ترحيل البيانات القديمة',
                onPressed: _runMigration,
                icon: const Icon(Icons.sync_rounded, color: AppColors.accent),
              ),
              IconButton(
                tooltip: 'تسجيل الخروج',
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.accent,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.accent,
              indicatorWeight: 3,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: _areas.map((area) {
                final areaUnits =
                    units.where((u) => _areaMatches(u.area, area)).length;
                final areaBlds = buildings
                    .where((b) => _areaMatches(b.area, area))
                    .length;
                final totalCount = areaUnits + areaBlds;
                return Tab(
                  text: '$area ${totalCount > 0 ? "($totalCount)" : ""}',
                );
              }).toList(),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnPrimary,
            onPressed: _openAddChooser,
            icon: const Icon(Icons.add_rounded),
            label: const Text('إضافة عقار'),
          ),
          body: Column(
            children: [
              // Type Sub-Filter Bar
              Container(
                color: AppColors.surface,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Text(
                      'عرض:',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildFilterChip('all', 'الكل'),
                    const SizedBox(width: 8),
                    _buildFilterChip('unit', 'شقق وفيلات'),
                    const SizedBox(width: 8),
                    _buildFilterChip('building', 'عمارات'),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),
              // Main Tab Views per Area
              Expanded(
                child: isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.accent),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: _areas.map((area) {
                          return _buildAreaList(
                            targetArea: area,
                            units: units,
                            buildings: buildings,
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterType == value;
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
      selectedColor: AppColors.accent,
      backgroundColor: AppColors.background,
      checkmarkColor: AppColors.textOnPrimary,
      onSelected: (_) => setState(() => _filterType = value),
    );
  }

  Widget _buildAreaList({
    required String targetArea,
    required List<Property> units,
    required List<AdminBuilding> buildings,
  }) {
    // 1. Filter by Area
    final areaUnits =
        units.where((u) => _areaMatches(u.area, targetArea)).toList();
    final areaBuildings =
        buildings.where((b) => _areaMatches(b.area, targetArea)).toList();

    // 2. Search Query filter
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

    // 3. Filter by Type
    final showUnits = _filterType == 'all' || _filterType == 'unit';
    final showBuildings = _filterType == 'all' || _filterType == 'building';

    final totalItems = (showUnits ? filteredUnits.length : 0) +
        (showBuildings ? filteredBuildings.length : 0);

    if (totalItems == 0) {
      return RefreshIndicator(
        color: AppColors.accent,
        onRefresh: () async => _reload(),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 40),
            MessageView(
              icon: Icons.location_off_rounded,
              title: 'لا توجد عقارات في $targetArea',
              message:
                  'اضغط على زر "إضافة عقار" لرفع شقة أو عمارة جديدة في هذه المنطقة.',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: () async => _reload(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          if (showUnits && filteredUnits.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Row(
                children: [
                  const Icon(Icons.apartment_rounded,
                      color: AppColors.accent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'الشقق والفيلات (${filteredUnits.length})',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...filteredUnits.map((property) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PropertyCard(
                    property: property,
                    onEdit: () => _openUnitForm(property: property),
                    onDelete: () => _confirmDeleteUnit(property),
                    onToggle: (v) => _togglePublishedUnit(property, v),
                  ),
                )),
          ],
          if (showBuildings && filteredBuildings.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 16),
              child: Row(
                children: [
                  const Icon(Icons.business_rounded,
                      color: Colors.purple, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'العمارات السكنية (${filteredBuildings.length})',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ...filteredBuildings.map((building) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AdminBuildingCard(
                    building: building,
                    onEdit: () => _openBuildingForm(building: building),
                    onDelete: () => _confirmDeleteBuilding(building),
                    onToggle: (v) => _togglePublishedBuilding(building, v),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
