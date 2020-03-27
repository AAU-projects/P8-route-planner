import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/models/directions_model.dart';
import 'package:route_app/core/services/gmaps_service.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';
import '../../mocks/http_mock.dart';

void main() {
  GoogleMapsService gmapsService;
  HttpMock httpMock;
  final String directionsStr =
      File('../../assets/directions_example.json').readAsStringSync();
  final Response testResponse = Response(null, jsonDecode(directionsStr));

  void setApiCalls() {
    when(httpMock.get(
            'https://maps.googleapis.com/maps/api/directions/json?origin=origin&destination=dest&key=apikey'))
        .thenAnswer((_) {
      return Future<Response>.value(testResponse);
    });
  }

  setUp(() {
    gmapsService = GoogleMapsService(apiKey: 'apikey');
    httpMock = HttpMock();

    locator.reset();
    locator.registerSingleton<Http>(httpMock);

    setApiCalls();
  });

  test('Asset file exists', () {
    expect(directionsStr.isNotEmpty, true);
  });

  group('getDirections', () {
    test('Should return a polyline', () {
      gmapsService
          .getDirections(origin: 'origin', destination: 'dest')
          .then(expectAsync1((Directions dir) {
        expect(dir.polyline, 'abcd');
      }));
    });

    test('Should return a status', () {
      gmapsService
          .getDirections(origin: 'origin', destination: 'dest')
          .then(expectAsync1((Directions dir) {
        expect(dir.status, 'OK');
      }));
    });

    test('Should return a start location', () {
      gmapsService
          .getDirections(origin: 'origin', destination: 'dest')
          .then(expectAsync1((Directions dir) {
        expect(dir.startLocation.address, 'start address');
        expect(dir.startLocation.latitude, 57.0189682);
        expect(dir.startLocation.longtitude, 9.9763342);
      }));
    });

    test('Should return an end location', () {
      gmapsService
          .getDirections(origin: 'origin', destination: 'dest')
          .then(expectAsync1((Directions dir) {
        expect(dir.endLocation.address, 'end address');
        expect(dir.endLocation.latitude, 57.04748129999999);
        expect(dir.endLocation.longtitude, 9.933803800000002);
      }));
    });

    test('Should return a distance in meters', () {
      gmapsService
          .getDirections(origin: 'origin', destination: 'dest')
          .then(expectAsync1((Directions dir) {
        expect(dir.distance, 4726);
      }));
    });

    test('Should return a duration in seconds', () {
      gmapsService
          .getDirections(origin: 'origin', destination: 'dest')
          .then(expectAsync1((Directions dir) {
        expect(dir.duration, 572);
      }));
    });
  });
}
