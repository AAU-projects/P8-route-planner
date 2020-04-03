import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/layout/screens/confirm_login.dart';
import 'package:route_app/layout/screens/register.dart';
import 'package:route_app/layout/screens/welcome.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/layout/constants/colors.dart' as color;
import 'package:route_app/routes.dart';

class MockApi extends Mock implements AuthAPI {}

void main() {
  setUp(() {
    final MockApi api = MockApi();
    locator.reset();
    locator.registerSingleton<AuthAPI>(api);

    when(api.register('validEmail@test.com', kml: 0, fuelType: null)).thenAnswer
      ((_) async {
      final Map<String, dynamic> json = <String, dynamic>{
        'Email': 'validEmail@test.com',
      };
      return Future<User>.value(User.fromJson(json));
    });

    when(api.sendPin('validEmail@test.com')).thenAnswer((_) {
      return Future<bool>.value(true);
    });
  });

  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterScreen()));
    expect(find.byType(RegisterScreen), findsOneWidget);
  });

  testWidgets('Has one custom button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterScreen()));
    expect(find.widgetWithText(CustomButton, 'Register'), findsOneWidget);
  });

  testWidgets('Has one email textfield', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterScreen()));
    expect(find.widgetWithText(CustomTextField, 'Email'), findsOneWidget);
  });

  testWidgets('Has one fuel consumption textfield',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterScreen()));
    expect(find.byKey(const Key('fuelConsumptionField')), findsOneWidget);
  });

  testWidgets('Has one cancel button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterScreen()));
    expect(find.byKey(const Key('cancelButton')), findsOneWidget);
  });

  /// Tests for the FormProvider integration:
  testWidgets('CustomTextField changes to error color on invalid input',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterScreen()));

    // Initial color is neutral grey
    final Icon emailIconInitial =
        tester.firstWidget(find.byKey(const Key('emailIcon')));
    expect(emailIconInitial.color, color.NeturalGrey);

    // Inputs an invalid email and exits textbox
    await tester.enterText(find.byKey(const Key('emailField')), 'invalidEmail');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Checks if the color changed
    final Icon emailIconFinal =
        tester.firstWidget(find.byKey(const Key('emailIcon')));
    expect(emailIconFinal.color, color.ErrorColor);
  });

  /// Tests for the FormProvider integration:
  testWidgets('CustomTextField changes to correct color on valid input',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterScreen()));

    // Initial color is neutral grey
    final Icon emailIconInitial =
        tester.firstWidget(find.byKey(const Key('emailIcon')));
    expect(emailIconInitial.color, color.NeturalGrey);

    // Inputs a valid email and exits textbox
    await tester.enterText(
        find.byKey(const Key('emailField')), 'validEmail@test.com');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Checks if the color changed
    final Icon emailIconFinal =
        tester.firstWidget(find.byKey(const Key('emailIcon')));
    expect(emailIconFinal.color, color.CorrectColor);
  });

  testWidgets('CustomButton changes color on correct input',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterScreen()));

    // Expect initial button color
    final RawMaterialButton customButtonInitial =
        tester.firstWidget(find.byType(RawMaterialButton));
    expect(customButtonInitial.fillColor, color.CustomButtonInactive);

    // Write valid input
    await tester.enterText(
        find.byKey(const Key('emailField')), 'validEmail@test.com');
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Expect change on button color
    final RawMaterialButton customButtonFinal =
        tester.firstWidget(find.byType(RawMaterialButton));
    expect(customButtonFinal.fillColor, color.CorrectColor);
  });

  group('Integration Tests', () {
    testWidgets('Tap on register navigates to the confirm screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(routes: routes, initialRoute: '/register',));

      await tester.enterText(
          find.byKey(const Key('emailField')), 'validEmail@test.com');
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('RegisterKey')));
      await tester.pumpAndSettle(const Duration(seconds: 10));
      expect(find.byType(ConfirmLoginScreen), findsOneWidget);
    });

    testWidgets('Tap on cancel navigates to the welcome screen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(MaterialApp(routes: routes, initialRoute: '/register'));
      await tester.tap(find.byKey(const Key('cancelButton')));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });
  });
}
