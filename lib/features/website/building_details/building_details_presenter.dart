import 'package:flutter/material.dart';

import '../../../core/widgets/details_table.dart';
import '../../../models/building.dart';

/// Builds the details table rows for a [Building].
///
/// Pure presentation mapping extracted from the detail screen so the UI only
/// renders rows against a model.
List<DetailsRow> buildingDetailsRows(Building building) {
  return [
    (
      icon: Icons.location_on_rounded,
      label: 'الحي والمنطقة',
      value: building.area,
    ),
    if (building.areaSqm != null)
      (
        icon: Icons.square_foot_rounded,
        label: 'مساحة الأرض الإجمالية',
        value: '${building.areaSqm!.toInt()} م²',
      ),
    if (building.buildingStructure != null)
      (
        icon: Icons.foundation_rounded,
        label: 'هيكل البناء',
        value: building.buildingStructure!,
      ),
    if (building.orientation != null)
      (
        icon: Icons.explore_rounded,
        label: 'الواجهة والفيو',
        value: building.orientation!,
      ),
    if (building.layoutNote != null)
      (
        icon: Icons.space_dashboard_rounded,
        label: 'ملاحظة تقسيم الدور',
        value: building.layoutNote!,
      ),
    (
      icon: Icons.layers_rounded,
      label: 'إجمالي عدد الأدوار',
      value: '${building.totalFloors} أدوار',
    ),
    (
      icon: Icons.grid_view_rounded,
      label: 'إجمالي وحدات المبنى',
      value: '${building.totalUnits} شقة',
    ),
    (
      icon: Icons.door_front_door_rounded,
      label: 'الوحدات المتاحة للبيع',
      value: '${building.availableUnits} شقة',
    ),
    (
      icon: Icons.brush_rounded,
      label: 'مستوى التشطيب',
      value: building.finishingStatus.label,
    ),
    (
      icon: Icons.monetization_on_rounded,
      label: 'السعر المطلوب',
      value: building.formattedStartingPrice,
    ),
    if (building.formattedDeliveryDate != null)
      (
        icon: Icons.event_rounded,
        label: 'موعد التسليم المتوقع',
        value: building.formattedDeliveryDate!,
      ),
    (
      icon: Icons.phone_iphone_rounded,
      label: 'رقم التواصل والمعاينة',
      value: building.whatsappNumber,
    ),
  ];
}
