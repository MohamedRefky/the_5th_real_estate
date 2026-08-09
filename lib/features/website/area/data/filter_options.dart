import '../../../../models/apartment.dart';

/// Static option lists for the apartment filter popovers.
///
/// Pure data extracted from `FilterSection` so the UI layer only renders
/// chips against these lists.
abstract final class FilterOptions {
  /// Floor options: label + internal value.
  static const List<(String, int)> floors = [
    ('بيزمنت', -1),
    ('أرضي', 0),
    ('الأول', 1),
    ('الثاني', 2),
    ('الثالث', 3),
    ('الرابع', 4),
    ('الروف', 6),
  ];

  /// Finishing status options: label + enum name.
  static const List<(String, String)> finishingStatuses = [
    ('سوبر لوكس', 'superLux'),
    ('نص تشطيب', 'semiFinished'),
    ('تحت الإنشاء', 'underConstruction'),
  ];

  /// Orientation options: label + enum value.
  static const List<(String, ApartmentOrientation)> orientations = [
    ('أمامي', ApartmentOrientation.front),
    ('خلفي', ApartmentOrientation.rear),
    ('جانبي', ApartmentOrientation.side),
  ];

  /// Room-count options.
  static List<(String, int)> rooms() =>
      List.generate(5, (i) => ('${i + 1} غرف', i + 1));

  /// Bathroom-count options.
  static List<(String, int)> bathrooms() =>
      List.generate(4, (i) => ('${i + 1} حمام', i + 1));

  /// Area range options: label + (min, max) sqm.
  static const List<(String, (double, double))> areaRanges = [
    ('115م²', (115.0, 115.0)),
    ('125م²', (125.0, 125.0)),
    ('125 : 150م²', (125.0, 150.0)),
    ('150 : 200م²', (150.0, 200.0)),
    ('200 : 250م²', (200.0, 250.0)),
    ('250 : 300م²', (250.0, 300.0)),
    ('+300م²', (300.0, 99999.0)),
  ];
}
