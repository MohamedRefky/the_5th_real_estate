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
    if (building.areaSqm != null && building.areaSqm! > 0)
      (
        icon: Icons.square_foot_rounded,
        label: 'مساحة الأرض الإجمالية',
        value: '${building.areaSqm!.toInt()} م²',
      ),
    if (building.buildingStructure != null && building.buildingStructure!.isNotEmpty)
      (
        icon: Icons.foundation_rounded,
        label: 'هيكل البناء',
        value: building.buildingStructure!,
      ),
    if (building.orientation != null && building.orientation!.isNotEmpty)
      (
        icon: Icons.explore_rounded,
        label: 'الواجهة والفيو',
        value: building.orientation!,
      ),
    if (building.layoutNote != null && building.layoutNote!.isNotEmpty)
      (
        icon: Icons.space_dashboard_rounded,
        label: 'ملاحظة تقسيم الدور',
        value: building.layoutNote!,
      ),
    if (building.startingPrice > 0)
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
  ];
}
