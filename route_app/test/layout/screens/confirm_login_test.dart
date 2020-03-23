import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_app/layout/screens/confirm_login.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';

void main() {
  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ConfirmLoginScreen()));
    expect(find.byType(ConfirmLoginScreen), findsOneWidget);
  });

  testWidgets('Has one custom button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ConfirmLoginScreen()));
    expect(find.widgetWithText(CustomButton, 'Confirm'), findsOneWidget);
  });

  testWidgets('Has one PIN textfield', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ConfirmLoginScreen()));
    expect(find.widgetWithText(CustomTextField, 'PIN'), findsOneWidget);
  });
}