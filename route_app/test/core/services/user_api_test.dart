import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:route_app/core/models/user_model.dart';
import 'package:route_app/core/services/API/user_service.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/locator.dart';
import '../../mocks/http_mock.dart';

class DatabaseMock extends Mock implements DatabaseService {}

void main() {
  HttpMock httpMock;
  UserAPI api;
  DatabaseMock db;
  List<Map<String, String>> table = <Map<String, String>>[];

  const String email = 'test@test.com';
  const String url = 'user/'; // ignore: unused_local_variable

  final Map<String, String> apiUserJson = <String, String>{'Email': email}; //ignore: unused_local_variable
  final User user = User('', email, 'bob', '123', '', DateTime(0), DateTime(0));
  final Map<String, String> userJson = <String, String>{
    'json': jsonEncode(user.toJson())
  };

  void setDatabaseCalls() {
    when(db.delete('user', where: '1')).thenAnswer((_) {
      table.clear();
      return Future<int>.value(1);
    });
    when(db.insert('user', userJson)).thenAnswer((_) {
      table.add(userJson);
      return Future<int>.value(1);
    });
    when(db.query('user', limit: 1))
        .thenAnswer((_) => Future<List<Map<String, dynamic>>>.value(table));
  }

  setUp(() {
    httpMock = HttpMock();
    db = DatabaseMock();
    table = <Map<String, String>>[];

    locator.reset();
    locator.registerSingleton<DatabaseService>(db);
    locator.registerSingleton<Http>(httpMock);

    api = UserService();
    setDatabaseCalls();
  });

  group('Active user', () {
    test('Should return the active User if set', () {
      api.setActiveUser(user);

      api.activeUser.then(expectAsync1((User value) {
        expect(value, user);
      }));
    });

    test('Should return null if no user set', () {
      api.activeUser.then(expectAsync1((User value) {
        expect(value, null);
      }));
    });

    test('Should return user if in database', (){
      table.add(userJson);

      api.activeUser.then(expectAsync1((User value) {
        expect(value.toJson(), user.toJson());
      }));
    });
  });
  
  group('Set active user', () {
    test('Should set active user', () {
      api.setActiveUser(user);

      api.activeUser.then(expectAsync1((User value) {
        expect(value, user);
      }));
    });
  });
}
