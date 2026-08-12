import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/models/apartment.dart';
import 'package:the_5th_real_estate/features/website/area/widgets/apartment_card.dart';

void main() {
  Apartment bareApartment({
    UnitType? unitType,
    FinishingStatus? finishingStatus,
    ApartmentOrientation? orientation,
  }) {
    return Apartment(
      id: 'x',
      title: 'اختبار',
      description: 'وصف',
      area: 'منطقة غير معروفة',
      unitType: unitType,
      price: 1500000,
      floor: 0,
      areaSqm: 100,
      rooms: 2,
      bathrooms: 2,
      finishingStatus: finishingStatus,
      orientation: orientation,
      whatsappNumber: '+20',
    );
  }

  Widget wrap(Apartment apt) => MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 350, child: ApartmentCard(apartment: apt)),
        ),
      );

  testWidgets('renders without crashing when all enum labels are null',
      (tester) async {
    await tester.pumpWidget(wrap(bareApartment()));

    expect(find.text('شقة'), findsOneWidget);
    expect(find.text('غير محدد'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders with a normal apartment', (tester) async {
    await tester.pumpWidget(wrap(
      bareApartment(
        unitType: UnitType.duplex,
        finishingStatus: FinishingStatus.superLux,
        orientation: ApartmentOrientation.front,
      ),
    ));

    expect(find.text('دوبلكس'), findsOneWidget);
    expect(find.text('سوبر لوكس'), findsOneWidget);
    expect(find.text('أمامي'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
