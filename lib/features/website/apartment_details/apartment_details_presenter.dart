import 'package:flutter/material.dart';

import '../../../core/widgets/details_table.dart';
import '../../../models/apartment.dart';

/// Builds the details table rows for an [Apartment].
///
/// Pure presentation mapping extracted from the detail screen so the UI only
/// renders rows against a model.
List<DetailsRow> apartmentDetailsRows(Apartment apartment) {
  return [
    (
      icon: Icons.home_work_rounded,
      label: 'نوع الوحدة',
      value: apartment.unitType.label,
    ),
    (icon: Icons.location_on_rounded, label: 'الحي', value: apartment.area),
    (
      icon: Icons.square_foot_rounded,
      label: 'المساحة الإجمالية',
      value: '${apartment.areaSqm.toInt()} م²',
    ),
    (
      icon: Icons.bed_rounded,
      label: 'عدد غرف النوم',
      value: '${apartment.rooms} غرف',
    ),
    (
      icon: Icons.bathtub_rounded,
      label: 'عدد الحمامات',
      value: '${apartment.bathrooms} حمام',
    ),
    if (apartment.reception != null)
      (
        icon: Icons.chair_rounded,
        label: 'الريسبشن',
        value: apartment.reception!,
      ),
    (
      icon: Icons.soup_kitchen_rounded,
      label: 'المطبخ',
      value: apartment.hasSeparateKitchen ? 'مطبخ منفصل' : 'مطبخ أمريكي / مفتوح',
    ),
    (icon: Icons.layers_rounded, label: 'الدور الحالي', value: apartment.floorLabel),
    (
      icon: Icons.apartment_rounded,
      label: 'إجمالي أدوار المبنى',
      value: '${apartment.totalFloors} أدوار',
    ),
    (
      icon: Icons.brush_rounded,
      label: 'مستوى التشطيب',
      value: apartment.finishingStatus.label,
    ),
    (
      icon: Icons.explore_rounded,
      label: 'واجهة الشقة',
      value: apartment.orientation.label,
    ),
    (
      icon: Icons.monetization_on_rounded,
      label: 'السعر الإجمالي',
      value: apartment.formattedPrice,
    ),
    if (apartment.formattedPriceNotes != null)
      (
        icon: Icons.sell_rounded,
        label: 'ملاحظات السعر والدفع',
        value: apartment.formattedPriceNotes!,
      ),
    if (apartment.formattedDeliveryDate != null)
      (
        icon: Icons.event_rounded,
        label: 'موعد التسليم المتوقع',
        value: apartment.formattedDeliveryDate!,
      ),
  ];
}
