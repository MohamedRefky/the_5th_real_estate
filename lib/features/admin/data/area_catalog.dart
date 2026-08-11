import 'package:flutter/material.dart';

/// One district on the admin dashboard overview, grouping its sub-areas
/// (e.g. "النرجس" groups الجديدة/عمارات/فيلات) so the dashboard stays
/// navigable as new areas are added.
class AdminAreaGroup {
  final String title;
  final IconData icon;
  final List<String> areas;

  const AdminAreaGroup({
    required this.title,
    required this.icon,
    required this.areas,
  });
}

/// All admin neighborhoods grouped by district. The dashboard overview renders
/// one section per group; every [areas] entry must also exist in `areaOptions`
/// so the admin forms and Firestore folders stay in sync.
const List<AdminAreaGroup> adminAreaGroups = [
  AdminAreaGroup(
    title: 'مناطق أساسية',
    icon: Icons.star_rounded,
    areas: ['المستثمرين', 'جاردينيا', 'بيت الوطن'],
  ),
  AdminAreaGroup(
    title: 'الأندلس',
    icon: Icons.holiday_village_rounded,
    areas: ['الأندلس 1 و 2', 'الأندلس عائلي'],
  ),
  AdminAreaGroup(
    title: 'النرجس',
    icon: Icons.landscape_rounded,
    areas: ['النرجس الجديدة', 'النرجس عمارات', 'النرجس فيلات'],
  ),
  AdminAreaGroup(
    title: 'البنفسج',
    icon: Icons.landscape_rounded,
    areas: ['البنفسج عمارات', 'البنفسج فيلات'],
  ),
  AdminAreaGroup(
    title: 'الياسمين',
    icon: Icons.landscape_rounded,
    areas: ['الياسمين الزوجي فيلات', 'الياسمين الفردي فيلات'],
  ),
];
