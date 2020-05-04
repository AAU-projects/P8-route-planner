import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/API/logging_service.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/core/services/interfaces/gmaps.dart';
import 'package:route_app/core/services/interfaces/API/logging.dart';
import 'package:route_app/core/services/interfaces/gsuggestions.dart';
import 'package:route_app/layout/screens/arguments/confirm_arguments.dart';
import 'package:route_app/layout/screens/confirm_login.dart';
import 'package:route_app/layout/screens/home.dart';
import 'package:route_app/layout/screens/welcome.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/locator.dart';
import 'package:route_app/routes.dart';

class MockApi extends Mock implements AuthAPI {}
class MockLogging extends Mock implements LoggingService {}
class MockDatabase extends Mock implements DatabaseService {}
class GoogleMapsServiceMock extends Mock implements GoogleMapsAPI {}
class SuggestionMock extends Mock implements GoogleAutocompleteAPI {}
class UserAPIMock extends Mock implements UserAPI {}

void main() {
  setUp(() {
    final MockApi api = MockApi();
    final MockLogging mockLog = MockLogging();
    final MockDatabase db = MockDatabase();
    final SuggestionMock mockSuggestion = SuggestionMock();
    final UserAPIMock userAPIMock = UserAPIMock();
    locator.reset();
    locator.registerSingleton<AuthAPI>(api);
    locator.registerSingleton<UserAPI>(userAPIMock);
    locator.registerSingleton<LoggingAPI>(mockLog);
    locator.registerSingleton<DatabaseService>(db);
    locator.registerSingleton<GoogleAutocompleteAPI>(mockSuggestion);
    locator.registerFactory<GoogleMapsAPI>(() => GoogleMapsServiceMock());

    when(api.sendPin('validEmail@test.com')).thenAnswer(
            (_) => Future<bool>.value(true));

    when(api.login('1234')).thenAnswer((_) => Future<User>.value(null));
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
                  arguments:
                      ConfirmScreenArguments('validEmail@test.com', 'login')),
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

  group('Integration Tests', () {
    Future<void> setup(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        routes: routes,
        initialRoute: '/login',
      ));

      await tester.enterText(
          find.byKey(const Key('emailField')), 'validEmail@test.com');
      await tester.pumpAndSettle();
 
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('ConfirmBtn')));
      await tester.pumpAndSettle(const Duration(seconds: 10));
      expect(find.byType(ConfirmLoginScreen), findsOneWidget);
    }

    testWidgets('Tap on login navigates to the home screen',
        (WidgetTester tester) async {
      await setup(tester);

      await tester.enterText(find.byKey(const Key('pinField')), '1234');
      await tester.pumpAndSettle();

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirmBtn')));
      await tester.pumpAndSettle(const Duration(seconds: 10));
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Tap on cancel navigates to the welcome screen',
        (WidgetTester tester) async {
      await setup(tester);

      await tester.tap(find.byKey(const Key('cancelBtn')));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });
  });
}
