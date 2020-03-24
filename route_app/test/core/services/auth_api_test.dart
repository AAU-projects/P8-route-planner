import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/API/auth_service.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';
import '../../mocks/http_mock.dart';

class UserAPIMock extends Mock implements UserAPI {}

void main() {
  HttpMock httpMock;
  AuthAPI api;

  const String email = 'test@test.com';
  const String url = 'user/';

  final Map<String, String> userJson = <String, String>{'Email': email};

  setUp(() {
    httpMock = HttpMock();

    locator.reset();
    locator.registerFactory<UserAPI>(() => UserAPIMock());
    locator.registerSingleton<Http>(httpMock);

    api = AuthenticationService();
  });



  group('Login', () {

    test('Should call login endpoint', () {
      api.login('', email: email).then(expectAsync1((User user) {
        expect(user.email, email);
      }));

      httpMock
          .expectOne(url: url + 'login', method: Method.post)
          .flush(userJson);
    });

    test('Should throw error if no email is set', () {
      api.login('bob').catchError((Object e) {
        expect(e, isA<String>());
      });
    });

    test('Should throw error from API', () {
      api.login('', email: email).catchError(expectAsync1((Object e) {
        expect(e, isA<Exception>());
      }));

      httpMock
          .expectOne(url: url + 'login', method: Method.post)
          .throwError('[401] Unauthorized');
    });

  });

  group('Send Pin', () {
    test('Should call pin endpoint', () {
      api.sendPin(email).then(expectAsync1((bool value) {
        expect(value, true);
      }));

      httpMock
          .expectOne(url: url + 'pincode', method: Method.post)
          .flush('true');
    });

    test('Should throw error from API', () {
      api.sendPin(email).catchError(expectAsync1((Object e) {
        expect(e, isA<Exception>());
      }));

      httpMock
          .expectOne(url: url + 'pincode', method: Method.post)
          .throwError('[401] Unauthorized');
    });
  });

  group('Register', () {
    test('Should call pin endpoint without license plate', () {
      api.register(email).then(expectAsync1((User value) {
        expect(value.email, email);
      }));

      httpMock
          .expectOne(url: url + 'register', method: Method.post)
          .flush(userJson);
    });

    test('Should call pin endpoint with license plate', () {
      api.register(email, licensePlate: '123').then(expectAsync1((User value) {
        expect(value.licensePlate, '123');
      }));

      userJson['LicensePlate'] = '123';

      httpMock
          .expectOne(url: url + 'register', method: Method.post)
          .flush(userJson);
    });

    test('Should throw error from API', () {
      api.register(email).catchError(expectAsync1((Object e) {
        expect(e, isA<Exception>());
      }));

      httpMock
          .expectOne(url: url + 'register', method: Method.post)
          .throwError('[401] Unauthorized');
    });
  });
}
