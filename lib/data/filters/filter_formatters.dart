import '../../models/apartment.dart';

/// Smart truncated label: shows the first [max] entries plus a `(+n)` tail.
String _truncatedLabel(String prefix, List<String> list, {int max = 2}) {
  if (list.isEmpty) return prefix;
  if (list.length <= max) return '$prefix: ${list.join("، ")}';
  return '$prefix: ${list.take(max).join("، ")} (+${list.length - max})';
}

String _floorName(int f) {
  if (f == -1) return 'بيزمنت';
  if (f == 0) return 'أرضي';
  if (f == 6) return 'روف';
  return '$f';
}

String _finishingName(String s) {
  if (s == 'superLux') return 'سوبر لوكس';
  if (s == 'semiFinished') return 'نص تشطيب';
  if (s == 'underConstruction') return 'تحت الإنشاء';
  return s;
}

/// Selected floors → pill label (e.g. "الدور: 1، 2 (+1)").
String floorFilterLabel(Set<int> floors) {
  return _truncatedLabel('الدور', floors.map(_floorName).toList());
}

/// Selected finishing statuses → pill label.
String finishingFilterLabel(Set<String> statuses) {
  return _truncatedLabel('التشطيب', statuses.map(_finishingName).toList());
}

/// Selected orientations → pill label.
String orientationFilterLabel(Set<ApartmentOrientation> orientations) {
  return _truncatedLabel(
    'الواجهة',
    orientations.map((o) => o.label).toList(),
  );
}

/// Selected room counts → pill label.
String roomsFilterLabel(Set<int> rooms) {
  return _truncatedLabel('الغرف', rooms.map((r) => '$r').toList());
}

/// Selected bathroom counts → pill label.
String bathroomsFilterLabel(Set<int> bathrooms) {
  return _truncatedLabel('الحمامات', bathrooms.map((r) => '$r').toList());
}

/// Selected area ranges → pill label.
String areaFilterLabel(Set<(double, double)> ranges) {
  return _truncatedLabel(
    'المساحة',
    ranges.map(formatAreaRange).toList(),
    max: 1,
  );
}

/// Formats an area range: "115م²", "<150م²", "+300م²" or "125 – 150م²".
String formatAreaRange((double, double) range) {
  if (range.$1 == range.$2) return '${range.$1.toInt()}م²';
  if (range.$1 == 0.0) return '<${range.$2.toInt()}م²';
  if (range.$2 >= 99999.0) return '+${range.$1.toInt()}م²';
  return '${range.$1.toInt()} – ${range.$2.toInt()}م²';
}

/// Compacts a price to "1.2M" / "350K" style.
String formatPriceShort(double price) {
  if (price >= 1000000) {
    return '${(price / 1000000).toStringAsFixed(1)}M';
  }
  return '${(price / 1000).toStringAsFixed(0)}K';
}

/// Selected price range → pill label, or "السعر" when inactive.
String priceFilterLabel({required double min, required double max}) {
  final hasPriceFilter = min > 0 || max < 10000000;
  if (!hasPriceFilter) return 'السعر';
  return 'السعر: ${formatPriceShort(min)}-${formatPriceShort(max)}';
}
