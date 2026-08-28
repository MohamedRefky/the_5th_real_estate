import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/contact_chooser_modal.dart';
import '../../../../models/building.dart';

/// Building card action row: Luxury WhatsApp CTA + "تفاصيل العمارة" button.
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

  void _openDetails(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesNames.buildingDetails,
      arguments: building.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Row(
      children: [
        // WhatsApp Button
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openWhatsapp(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 11),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0x2825D366),
                      Color(0x10121C2B),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF25D366).withValues(alpha: 0.55),
                    width: 1.1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: const Color(0xFF25D366),
                      size: isMobile ? 14 : 16,
                    ),
                    SizedBox(width: isMobile ? 5 : 7),
                    Text(
                      'واتساب',
                      style: TextStyle(
                        color: const Color(0xFF25D366),
                        fontWeight: FontWeight.w800,
                        fontSize: isMobile ? 11.5 : 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: isMobile ? 7 : 10),

        // View Details Button
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openDetails(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 11),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.accentGlow,
                      blurRadius: 12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'التفاصيل',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: isMobile ? 11.5 : 12.5,
                      ),
                    ),
                    SizedBox(width: isMobile ? 4 : 6),
                    Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textOnPrimary,
                      size: isMobile ? 13 : 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
