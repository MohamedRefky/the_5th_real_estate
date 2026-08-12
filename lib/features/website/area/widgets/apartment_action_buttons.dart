import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../app/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/contact_chooser_modal.dart';
import '../../../../models/apartment.dart';

/// Apartment card action row: Luxury WhatsApp CTA + "تفاصيل الشقة" button.
class ApartmentActionButtons extends StatelessWidget {
  final Apartment apartment;

  const ApartmentActionButtons({super.key, required this.apartment});

  Future<void> _openWhatsapp(BuildContext context) async {
    await showContactChooserModal(
      context,
      message:
          'مرحباً، أود الاستفسار عن ${apartment.title} في ${apartment.area}.',
      platform: ContactPlatform.whatsapp,
    );
  }

  void _openDetails(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesNames.apartmentDetails,
      arguments: apartment.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // WhatsApp Button
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openWhatsapp(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0x2825D366),
                      Color(0x10121C2B),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF25D366).withValues(alpha: 0.55),
                    width: 1.2,
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
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Color(0xFF25D366),
                      size: 16,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'تواصل واتساب',
                      style: TextStyle(
                        color: Color(0xFF25D366),
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // View Details Button
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openDetails(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(14),
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
                  children: const [
                    Text(
                      'تفاصيل الشقة',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textOnPrimary,
                      size: 15,
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
