import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:route_app/core/models/trip.dart';
import 'package:route_app/core/services/API/trip_service.dart';
import 'package:route_app/core/services/interfaces/API/trips.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';

import '../../mocks/http_mock.dart';

void main() {
  HttpMock httpMock;
  TripsAPI api;

  const String url = 'trip/';
  final String directionsStr =
    File('assets/trips_example.json').readAsStringSync();

  setUp(() {
    httpMock = HttpMock();

    locator.reset();
    locator.registerSingleton<Http>(httpMock);

    api = TripService();
  });

  group('GetTrips', () {
    test('Should call login endpoint', () {
      api.getTrips().then(expectAsync1((List<Trip> res) {
        expect(res.length, 3);
      }));

      httpMock
          .expectOne(url: url, method: Method.get)
          .flush(directionsStr);
    });

    test('Should return empty list if no content', () {
      api.getTrips().then(expectAsync1((List<Trip> res) {
        expect(res.length, 0);
      }));

      httpMock
          .expectOne(url: url, method: Method.get)
          .flush('[]');
    });
  });
}