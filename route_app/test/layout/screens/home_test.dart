import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/models/suggestion_result_model.dart';
import 'package:route_app/core/services/API/logging_service.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/core/services/interfaces/API/logging.dart';
import 'package:route_app/core/models/directions_model.dart';
import 'package:route_app/core/models/location_model.dart';
import 'package:route_app/core/services/interfaces/gmaps.dart';
import 'package:route_app/core/services/interfaces/gsuggestions.dart';
import 'package:route_app/layout/screens/home.dart';
import 'package:route_app/layout/widgets/fields/search_text_field.dart';
import 'package:route_app/locator.dart';

class GoogleMapsServiceMock extends Mock implements GoogleMapsAPI {}

class MockDatabase extends Mock implements DatabaseService {}

class MockLogging extends Mock implements LoggingService {}

class SuggestionMock extends Mock implements GoogleAutocompleteAPI {}

void main() {
  GoogleMapsServiceMock mockGmaps;
  SuggestionMock mockSuggestion;
  final Directions testDirections = Directions(
      polyline: 'polystring',
      status: 'OK',
      startLocation: Location('TestAddr', 1.00, 1.00),
      endLocation: Location('TestAddr', 2.00, 2.00),
      distance: 25,
      duration: 20,
      polylinePoints: <LatLng>[const LatLng(1.00, 1.00)]);

  void _setupServiceCalls() {
    when(mockGmaps.getDirections(origin: 'testOrigin', destination: 'testDest'))
        .thenAnswer((_) {
      return Future<Directions>.value(testDirections);
    });
    when(mockGmaps.getDirections(
            origin: 'testOrigin',
            destination: 'testDest',
            travelMode: 'transit'))
        .thenAnswer((_) {
      return Future<Directions>.value(testDirections);
    });
    when(mockGmaps.getDirections(
            origin: 'testOrigin',
            destination: 'testDest',
            travelMode: 'bicycling'))
        .thenAnswer((_) {
      return Future<Directions>.value(testDirections);
    });
    when(mockSuggestion.getSuggestions(any, any)).thenAnswer((_) {
      return Future<List<SuggestionResult>>.value(
          <SuggestionResult>[SuggestionResult(5, 'aalborg')]);
    });
  }

  setUp(() {
    final MockDatabase db = MockDatabase();
    final MockLogging mockLog = MockLogging();

    mockGmaps = GoogleMapsServiceMock();
    mockSuggestion = SuggestionMock();
    locator.reset();
    locator.registerFactory<GoogleMapsAPI>(() => mockGmaps);
    locator.registerSingleton<DatabaseService>(db);
    locator.registerSingleton<LoggingAPI>(mockLog);
    locator.registerSingleton<GoogleAutocompleteAPI>(mockSuggestion);
    _setupServiceCalls();
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

    testWidgets('Has a Scrollable bottom sheet', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    });

    testWidgets('Scrollable bottom sheet is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));
      expect(find.byKey(const Key('BottomSheetContainer')), findsNothing);
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

  group('After Search', () {
    testWidgets('Scrollable bottom sheet is not empty after search result',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      await tester.tap(find.byType(SearchTextField));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('OriginTextField')), 'testOrigin');

      await tester.enterText(
          find.byKey(const Key('DestinationTextField')), 'testDest');

      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('BottomSheetContainer')), findsOneWidget);
    });

    testWidgets('Back button removes bottom sheet after search',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      await tester.tap(find.byType(SearchTextField));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('OriginTextField')), 'testOrigin');

      await tester.enterText(
          find.byKey(const Key('DestinationTextField')), 'testDest');

      await tester.testTextInput.receiveAction(TextInputAction.done);

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('SearchBackButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('BottomSheetContainer')), findsNothing);
    });
  });

  group('Autocomplete', () {
    testWidgets('Shows suggestions', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomeScreen()));

      await tester.tap(find.byType(SearchTextField));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('DestinationTextField')), 'aal');

      await tester.pumpAndSettle();

      expect(find.text('aalborg'), findsOneWidget);
    });
  });
}
