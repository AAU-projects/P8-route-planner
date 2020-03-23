import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/layout/screens/confirm_login.dart';
import 'package:route_app/layout/widgets/buttons/custom_button.dart';
import 'package:route_app/layout/widgets/fields/custom_text_field.dart';
import 'package:route_app/locator.dart';

class MockApi extends Mock implements AuthAPI {}

void main() {
  setUp(() {
    locator.reset();
    locator.registerFactory<AuthAPI>(() => MockApi());
  });
  
  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ConfirmLoginScreen()));
    expect(find.byType(ConfirmLoginScreen), findsOneWidget);
  });

  testWidgets('Has one custom button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ConfirmLoginScreen()));
    expect(find.byType(CustomButton), findsOneWidget);
  });

  testWidgets('Has one PIN textfield', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ConfirmLoginScreen()));
    expect(find.byType(CustomTextField), findsOneWidget);
  });
}