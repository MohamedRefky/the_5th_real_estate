import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
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

/// Hidden admin dashboard — lists all units and buildings (in per-area
/// folders) with edit / delete / publish toggles, plus a one-click data
/// migration from the legacy flat `properties` collection.
///
/// Reached only after login at `/admin/dashboard`.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<List<Property>> _unitsFuture;
  late Future<List<AdminBuilding>> _buildingsFuture;

  @override
  void initState() {
    super.initState();
    _unitsFuture = PropertyService.instance.fetchAll();
    _buildingsFuture = BuildingService.instance.fetchAll();
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

  /// Shows the type chooser: عمارة vs شقة/فيلا — decides which form opens.
  Future<void> _openAddChooser() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'إيه اللي هتضيفه؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _chooserOption(
                icon: Icons.apartment_rounded,
                title: 'شقة / فيلا / دوبلكس / استوديو',
                subtitle: 'تضاف لفولدر حيها في كلكشن الوحدات',
                value: 'unit',
              ),
              const SizedBox(height: 10),
              _chooserOption(
                icon: Icons.business_rounded,
                title: 'عمارة',
                subtitle: 'تضاف لفولدر حيها في كلكشن العمارات',
                value: 'building',
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted) return;
    if (choice == 'building') {
      await _openBuildingForm();
    } else if (choice == 'unit') {
      await _openUnitForm();
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

  Future<void> _openUnitForm({Property? property}) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PropertyFormScreen(property: property),
      ),
    );
    _reload();
  }

  Future<void> _openBuildingForm({AdminBuilding? building}) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BuildingFormScreen(building: building),
      ),
    );
    _reload();
  }

  Future<void> _confirmDeleteUnit(Property property) async {
    final confirmed = await _confirm(
      title: 'حذف الوحدة؟',
      message: 'سيتم حذف "${property.projectName} - ${property.floor}" نهائياً ولا يمكن التراجع.',
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

  Future<void> _togglePublishedBuilding(AdminBuilding building, bool value) async {
    await BuildingService.instance
        .setPublished(building.id!, building, value);
    _reload();
  }

  /// One-click migration of the legacy flat `properties` collection into the
  /// new per-area folders.
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
        title: const Text('نقلح كلكشن properties القديم؟',
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          title: const Text(
            'لوحة التحكم',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          actions: [
            IconButton(
              tooltip: 'ترحيل البيانات القديمة',
              onPressed: _runMigration,
              icon: const Icon(Icons.sync_rounded, color: AppColors.accent),
            ),
            IconButton(
              tooltip: 'تسجيل الخروج',
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, color: AppColors.accent),
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.accent,
            tabs: [
              Tab(text: 'الوحدات (شقق وفيلات)'),
              Tab(text: 'العمارات'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.textOnPrimary,
          onPressed: _openAddChooser,
          icon: const Icon(Icons.add_rounded),
          label: const Text('إضافة'),
        ),
        body: TabBarView(
          children: [
            _buildUnitsTab(),
            _buildBuildingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitsTab() {
    return FutureBuilder<List<Property>>(
      future: _unitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }
        if (snapshot.hasError) {
          return MessageView(
            icon: Icons.error_outline_rounded,
            title: 'فشل التحميل',
            message: '${snapshot.error}',
          );
        }
        final items = snapshot.data ?? const <Property>[];
        if (items.isEmpty) {
          return const MessageView(
            icon: Icons.home_work_outlined,
            title: 'لا توجد وحدات بعد',
            message: 'اضغط "إضافة" ثم اختر شقة/فيلا لبدء إضافة الوحدات.',
          );
        }
        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () async => _reload(),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => PropertyCard(
              property: items[index],
              onEdit: () => _openUnitForm(property: items[index]),
              onDelete: () => _confirmDeleteUnit(items[index]),
              onToggle: (v) => _togglePublishedUnit(items[index], v),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBuildingsTab() {
    return FutureBuilder<List<AdminBuilding>>(
      future: _buildingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          );
        }
        if (snapshot.hasError) {
          return MessageView(
            icon: Icons.error_outline_rounded,
            title: 'فشل التحميل',
            message: '${snapshot.error}',
          );
        }
        final items = snapshot.data ?? const <AdminBuilding>[];
        if (items.isEmpty) {
          return const MessageView(
            icon: Icons.business_outlined,
            title: 'لا توجد عمارات بعد',
            message: 'اضغط "إضافة" ثم اختر عمارة لبدء إضافة العمارات.',
          );
        }
        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () async => _reload(),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => AdminBuildingCard(
              building: items[index],
              onEdit: () => _openBuildingForm(building: items[index]),
              onDelete: () => _confirmDeleteBuilding(items[index]),
              onToggle: (v) => _togglePublishedBuilding(items[index], v),
            ),
          ),
        );
      },
    );
  }
}
