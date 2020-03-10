import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_app/layout/screens/login.dart';
import 'package:route_app/layout/screens/register.dart';
import 'package:route_app/layout/screens/welcome.dart';
import 'package:route_app/layout/widgets/button.dart';
import 'package:route_app/routes.dart';

void main() {
  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WelcomeScreen()));
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('Has login button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WelcomeScreen()));
    expect(find.widgetWithText(Button, 'Login'), findsOneWidget);
  });

  testWidgets('Has register button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WelcomeScreen()));
    expect(find.widgetWithText(Button, 'Register'), findsOneWidget);
  });

  testWidgets('Tap on register navigates to the register screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(routes: routes));
    await tester.tap(find.byKey(const Key('RegisterButton')));
    await tester.pumpAndSettle();
    expect(find.byType(RegisterScreen), findsOneWidget);
  });

  testWidgets('Tap on login navigates to the login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(routes: routes));
    await tester.tap(find.byKey(const Key('LoginButton')));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
