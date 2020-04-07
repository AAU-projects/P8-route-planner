import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/layout/screens/login.dart';
import 'package:route_app/layout/screens/register.dart';
import 'package:route_app/layout/screens/welcome.dart';
import 'package:route_app/layout/widgets/buttons/button.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/routes.dart';

class MockApi extends Mock implements AuthAPI {}

void main() {
  setUp(() {
    final MockApi api = MockApi();
    locator.reset();
    locator.registerSingleton<AuthAPI>(api);
  });

  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: WelcomeScreen(
      isTest: true,
    )));
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('Has login button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen(isTest: true)));
    expect(find.widgetWithText(Button, 'Login'), findsOneWidget);
  });

  testWidgets('Has register button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen(isTest: true)));
    expect(find.widgetWithText(Button, 'Register'), findsOneWidget);
  });

  group('Integration Tests', () {
    final Map<String, Widget Function(BuildContext)> testRoutes =
        <String, Widget Function(BuildContext)>{
      '/welcometest': (_) => const WelcomeScreen(isTest: true),
    };

    testWidgets('Tap on register navigates to the register screen',
        (WidgetTester tester) async {
      testRoutes.addEntries(routes.entries);
      await tester.pumpWidget(MaterialApp(
        routes: testRoutes,
        initialRoute: '/welcometest',
      ));
      await tester.tap(find.byKey(const Key('RegisterButton')));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);
    });

    testWidgets('Tap on login navigates to the login screen',
        (WidgetTester tester) async {
      testRoutes.addEntries(routes.entries);
      await tester.pumpWidget(MaterialApp(
        routes: testRoutes,
        initialRoute: '/welcometest',
      ));
      await tester.tap(find.byKey(const Key('LoginButton')));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
