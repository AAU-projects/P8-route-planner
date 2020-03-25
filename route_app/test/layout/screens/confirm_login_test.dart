import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/layout/screens/arguments/confirm_arguments.dart';
import 'package:route_app/layout/screens/confirm_login.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/locator.dart';

class MockApi extends Mock implements AuthAPI {}

void main() {
  setUp(() {
    final MockApi api = MockApi();
    locator.reset();
    locator.registerSingleton<AuthAPI>(api);
  });

  Future<void> pumpConfirmWithArgs(WidgetTester tester) async {
    final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: key,
          home: FlatButton(
            onPressed: () => key.currentState.push(
              MaterialPageRoute<ConfirmLoginScreen>(
                settings: RouteSettings(
                  arguments: ConfirmScreenArguments(
                  'validEmail@test.com',
                  'login')),
                builder: (_) => ConfirmLoginScreen(),
              ),
            ),
            child: const SizedBox(),
          ),
        ),
      );
  }

  testWidgets('Screen renders', (WidgetTester tester) async {
    await pumpConfirmWithArgs(tester);
    await tester.tap(find.byType(FlatButton));
    await tester.pumpAndSettle();

    expect(find.byType(ConfirmLoginScreen), findsOneWidget);
  });

  testWidgets('Has one custom button', (WidgetTester tester) async {
    await pumpConfirmWithArgs(tester);
    await tester.tap(find.byType(FlatButton));
    await tester.pumpAndSettle();

    expect(find.byType(CustomButton), findsOneWidget);
  });

  testWidgets('Has one PIN textfield', (WidgetTester tester) async {
    await pumpConfirmWithArgs(tester);
    await tester.tap(find.byType(FlatButton));
    await tester.pumpAndSettle();

    expect(find.byType(CustomTextField), findsOneWidget);
  });
}
