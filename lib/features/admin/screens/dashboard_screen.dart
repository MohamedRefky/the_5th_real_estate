import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../auth/auth_controller.dart';
import '../models/property.dart';
import '../services/property_service.dart';
import '../widgets/message_view.dart';
import '../widgets/property_card.dart';
import 'property_form_screen.dart';

/// Hidden admin dashboard — lists all properties with edit / delete / publish
/// toggles. Reached only after login at `/admin/dashboard`.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<List<Property>> _future;

  @override
  void initState() {
    super.initState();
    _future = PropertyService.instance.fetchAll();
  }

  void _reload() {
    setState(() => _future = PropertyService.instance.fetchAll());
  }

  Future<void> _logout() async {
    await AuthController.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RoutesNames.adminLogin);
  }

  Future<void> _openForm({Property? property}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PropertyFormScreen(property: property),
      ),
    );
    if (saved == true) _reload();
  }

  Future<void> _confirmDelete(Property property) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider),
        ),
        title: const Text('حذف العقار؟',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'سيتم حذف "${property.projectName} - ${property.floor}" نهائياً و لا يمكن التراجع.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
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
    if (confirmed != true) return;
    await PropertyService.instance
        .delete(property.id!, property.imageUrls);
    _reload();
  }

  Future<void> _togglePublished(Property property, bool value) async {
    await PropertyService.instance.setPublished(property.id!, value);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            tooltip: 'تسجيل الخروج',
            onPressed: _logout,
            icon: const Icon(Icons.logout_rounded, color: AppColors.accent),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnPrimary,
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('إضافة عقار'),
      ),
      body: FutureBuilder<List<Property>>(
        future: _future,
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
              title: 'لا توجد عقارات بعد',
              message: 'اضغط "إضافة عقار" لبدء إضافة الوحدات.',
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
                onEdit: () => _openForm(property: items[index]),
                onDelete: () => _confirmDelete(items[index]),
                onToggle: (v) => _togglePublished(items[index], v),
              ),
            ),
          );
        },
      ),
    );
  }
}
