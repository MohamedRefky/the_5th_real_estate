import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/contact_chooser_modal.dart';
import '../../../../models/building.dart';

/// Building card action row: WhatsApp CTA + "تفاصيل العمارة" button.
class BuildingActionButtons extends StatelessWidget {
  final Building building;

  const BuildingActionButtons({super.key, required this.building});

  Future<void> _openWhatsapp(BuildContext context) async {
    await showContactChooserModal(
      context,
      message:
          'مرحباً، أود الاستفسار عن ${building.name} في حي ${building.area}.',
      platform: ContactPlatform.whatsapp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // WhatsApp Button
        Expanded(
          child: InkWell(
            onTap: () => _openWhatsapp(context),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF25D366),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.chat_rounded,
                    color: Color(0xFF25D366),
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'تواصل واتساب',
                    style: TextStyle(
                      color: Color(0xFF25D366),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // View Details Button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutesNames.buildingDetails,
                arguments: building.id,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'تفاصيل العمارة',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
