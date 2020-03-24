import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/layout/screens/confirm_login.dart';
import 'package:route_app/layout/screens/login.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/locator.dart';

class MockApi extends Mock implements AuthAPI {
}

void main() {
  setUp(() {
    final MockApi api = MockApi();
    locator.reset();
    locator.registerSingleton<AuthAPI>(api);

    when(api.sendPin('validEmail@test.com')).thenAnswer((_) {
      return Future<bool>.value(true);
    });
  });

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
    expect(find.byKey(const Key('cancelButton')), findsOneWidget);
  });

  testWidgets('Tap on confirm successfully navigates to confirm screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Enter a valid email
    await tester.enterText(
      find.byKey(const Key('emailField')), 'validEmail@test.com');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Tap the confirm key
    await tester.tap(find.byType(CustomButton));
    await tester.pumpAndSettle();

    // Expect to see the confirm screen
    expect(find.byType(ConfirmLoginScreen), findsOneWidget);
  });
}
