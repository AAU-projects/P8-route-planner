import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_app/layout/screens/login.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';

void main() {
  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Has one custom button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.widgetWithText(CustomButton, 'Login'), findsOneWidget);
  });

  testWidgets('Has one login textfield', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.widgetWithText(CustomTextField, 'Email'), findsOneWidget);
  });

  testWidgets('Has one cancel button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.widgetWithText(Text, 'Cancel'), findsOneWidget);
  });
}