import 'package:flutter_test/flutter_test.dart';

import 'package:courtu/main.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CourtUApp());
    expect(find.text('COURTU'), findsOneWidget);
  });
}
