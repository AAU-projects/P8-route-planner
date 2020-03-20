import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_app/layout/screens/login.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';

void main() {
  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Has one custom button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.widgetWithText(CustomButton, 'Login'), findsOneWidget);
  });
}