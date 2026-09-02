import 'package:flutter/material.dart';
import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../auth/auth_controller.dart';
import '../models/admin_building.dart';
import '../models/property.dart';
import '../services/building_service.dart';
import '../services/property_service.dart';
import '../widgets/admin_building_card.dart';
import '../widgets/message_view.dart';
import '../widgets/property_card.dart';
import 'building_form_screen.dart';
import 'bulk_import_dialog.dart';
import 'property_form_screen.dart';

/// Ultra-Simple & Minimal Admin Dashboard.
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
  String _searchQuery = '';

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
      message: 'سيتم حذف "${property.projectName}" نهائياً.',
    );
    if (confirmed != true) return;
    try {
      await PropertyService.instance.delete(property.id!, property);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف الوحدة بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل الحذف: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _confirmDeleteBuilding(AdminBuilding building) async {
    final confirmed = await _confirm(
      title: 'حذف العمارة؟',
      message: 'سيتم حذف "${building.name}" نهائياً.',
    );
    if (confirmed != true) return;
    try {
      await BuildingService.instance.delete(building.id!, building);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف العمارة بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل الحذف: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
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
              'لوحة التحكم',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                tooltip: 'تحديث',
                onPressed: _reload,
                icon: const Icon(Icons.refresh_rounded, color: AppColors.accent),
              ),
              IconButton(
                tooltip: 'خروج',
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
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              // ── 1. Quick Search & Area Selector ────
                              _buildSearchAndFilters(),
                              const SizedBox(height: 14),

                              // ── 2. Dynamic Add Buttons ──────────────
                              _buildAddButtons(),
                              const SizedBox(height: 16),

                              // ── 3. List Content ────────────────────
                              _buildListContent(units, buildings),
                            ],
                          ),
                        ),
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
              'خطأ في جلب البيانات من Firebase:\n$error',
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

  // ── Dynamic Action Buttons ──────────────────────────────────────────

  Future<void> _openBulkImport() async {
    final imported = await BulkImportDialog.show(context);
    if (imported == true && mounted) {
      _reload();
    }
  }

  Widget _buildAddButtons() {
    final areaText = _selectedArea == 'الكل' ? '' : ' في $_selectedArea';
    final unitLabel = 'إضافة شقة / فيلا$areaText';
    final buildingLabel = 'إضافة عمارة$areaText';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 450;
        final unitBtn = FilledButton.icon(
          onPressed: () => _openUnitForm(
              initialArea: _selectedArea == 'الكل' ? null : _selectedArea),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.add_rounded, size: 20),
          label: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              unitLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            ),
          ),
        );

        final buildingBtn = FilledButton.icon(
          onPressed: () => _openBuildingForm(
              initialArea: _selectedArea == 'الكل' ? null : _selectedArea),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.business_rounded, size: 19),
          label: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              buildingLabel,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
            ),
          ),
        );

        return Column(
          children: [
            if (isSmall) ...[
              SizedBox(width: double.infinity, child: unitBtn),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: buildingBtn),
            ] else ...[
              Row(
                children: [
                  Expanded(child: unitBtn),
                  const SizedBox(width: 10),
                  Expanded(child: buildingBtn),
                ],
              ),
            ],
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openBulkImport,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  backgroundColor: AppColors.accentLight,
                  side: const BorderSide(color: AppColors.accentLine),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.upload_file_rounded, size: 20),
                label: const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'الرفع الجماعي من كود JSON (شقق وعمارات) 📄',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── 2. Search Box & Area Filter ────────────────────────────────────

  Widget _buildSearchAndFilters() {
    final allAreasOptions = ['الكل', ...areaOptions];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          // Search Input Field
          TextField(
            controller: _searchController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'ابحث عن عقار أو حي...',
              hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.accent),
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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

          const SizedBox(height: 12),

          // Area & Type Selection Row (Responsive)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              final dropdownWidget = Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
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
                        child: Text(area == 'الكل' ? 'كل المناطق' : area),
                      );
                    }).toList(),
                  ),
                ),
              );

              final chipsRow = SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _filterChip('all', 'الكل'),
                    const SizedBox(width: 4),
                    _filterChip('unit', 'شقق'),
                    const SizedBox(width: 4),
                    _filterChip('building', 'عمارات'),
                  ],
                ),
              );

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    dropdownWidget,
                    const SizedBox(height: 10),
                    chipsRow,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: dropdownWidget),
                  const SizedBox(width: 10),
                  chipsRow,
                ],
              );
            },
          ),
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

  // ── 3. Simple List Content ─────────────────────────────────────────

  Widget _buildListContent(
      List<Property> units, List<AdminBuilding> buildings) {
    // Filter by area
    final areaUnits =
        units.where((u) => _areaMatches(u.area, _selectedArea)).toList();
    final areaBuildings =
        buildings.where((b) => _areaMatches(b.area, _selectedArea)).toList();

    // Filter by search query
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
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: MessageView(
          icon: Icons.search_off_rounded,
          title: 'لا توجد عقارات هنا',
          message:
              'لم نجد أي نتائج تطابق التصفية الحالية. اضغط على أحد الأزرار بالأعلى لإضافة عقار جديد.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayUnits.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 4),
            child: Row(
              children: [
                const Icon(Icons.apartment_rounded,
                    color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'الشقق والفيلات (${displayUnits.length})',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 4),
            child: Row(
              children: [
                const Icon(Icons.business_rounded,
                    color: Color(0xFFC084FC), size: 20),
                const SizedBox(width: 8),
                Text(
                  'العمارات السكنية (${displayBuildings.length})',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
}
