import 'package:flutter_test/flutter_test.dart';

import 'package:the_5th_real_estate/app/app.dart';

void main() {
  testWidgets('App builds the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TheApp());
    // The ambient background animation repeats forever, so advance time
    // explicitly instead of pumpAndSettle.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('The 5th Real Estate'), findsWidgets);
  });
}
