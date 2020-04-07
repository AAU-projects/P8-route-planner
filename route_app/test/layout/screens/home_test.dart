import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/services/API/logging_service.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/core/services/interfaces/API/logging.dart';
import 'package:route_app/layout/screens/home.dart';
import 'package:route_app/layout/widgets/fields/search_text_field.dart';
import 'package:route_app/locator.dart';

class MockDatabase extends Mock implements DatabaseService {}
class MockLogging extends Mock implements LoggingService {}

void main() {
  setUp(() {
    final MockDatabase db = MockDatabase();
    final MockLogging mockLog = MockLogging();
    locator.reset();
    locator.registerSingleton<DatabaseService>(db);
    locator.registerSingleton<LoggingAPI>(mockLog);
  });

  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen()));
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  group('Initial state', () {
    testWidgets('Has two floating buttons', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      expect(find.byType(FloatingActionButton), findsNWidgets(2));
    });

    testWidgets('Google map is rendered', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets('Has one search textfield', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      expect(find.byType(SearchTextField), findsOneWidget);
    });
  });

  group('Search state', () {
    testWidgets('Has two textfields when selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      expect(find.byType(SearchTextField), findsNWidgets(1));

      await tester.tap(find.byType(SearchTextField));
      await tester.pumpAndSettle();

      expect(find.byType(SearchTextField), findsNWidgets(2));
    });

    testWidgets('Has three floatingbuttons when selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      expect(find.byType(FloatingActionButton), findsNWidgets(2));

      await tester.tap(find.byType(SearchTextField));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsNWidgets(3));
    });
  });
}
