import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// How the rows of a [DetailsTable] lay out their content.
enum DetailsTableLayout {
  /// Icon tile + label on the right, value pushed to the far left.
  spaced,

  /// Plain icon, label/value distributed with flex factors.
  flex,
}

/// A single details row: icon + label + value.
typedef DetailsRow = ({IconData icon, String label, String value});

/// Alternating-row details table shared by the apartment and building
/// detail screens. Each row is an [DetailsRow] record.
class DetailsTable extends StatelessWidget {
  final List<DetailsRow> rows;
  final DetailsTableLayout layout;

  const DetailsTable({
    super.key,
    required this.rows,
    this.layout = DetailsTableLayout.spaced,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          final row = rows[index];
          final icon = row.icon;
          final label = row.label;
          final value = row.value;
          final isLast = index == rows.length - 1;
          final isEven = index.isEven;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isEven
                  ? AppColors.surface
                  : AppColors.cream.withValues(alpha: 0.7),
              borderRadius: isLast
                  ? const BorderRadius.vertical(bottom: Radius.circular(20))
                  : (index == 0
                        ? const BorderRadius.vertical(top: Radius.circular(20))
                        : null),
              border: layout == DetailsTableLayout.spaced
                  ? (isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              width: 0.8,
                            ),
                          ))
                  : null,
            ),
            child: layout == DetailsTableLayout.spaced
                ? _buildSpacedRow(theme, icon, label, value)
                : _buildFlexRow(theme, icon, label, value),
          );
        }),
      ),
    );
  }

  Widget _buildSpacedRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.accent),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: label == 'السعر الإجمالي'
                ? AppColors.accent
                : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFlexRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 14),
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
