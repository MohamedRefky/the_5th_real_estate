/// Arabic month names used across date formatting.
const List<String> kArabicMonths = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

/// Formats a [date] as Arabic month + year (e.g., "يناير 2026").
String formatArabicMonthYear(DateTime date) {
  return '${kArabicMonths[date.month - 1]} ${date.year}';
}
