import 'package:get_it/get_it.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/core/services/API/auth_service.dart';
import 'package:route_app/core/services/API/http_service.dart';
import 'package:route_app/core/services/API/user_service.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/core/utils/environment.dart' as environment;

/// Instantiates the dependency injection
GetIt locator = GetIt.instance;

/// Register all dependencies
void setupLocator() {
  // Example of Singleton, One instance thought the app
  // locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton<DatabaseService>(() => DatabaseService(
      databaseName: 'testDBv2',
      version: environment.getVar<int>('DATABASE_VERSION')
      ));

  locator.registerLazySingleton<UserAPI>(() => UserService());

  // Example of factory, New instance with each call
  // locator.registerFactory(() => Api());

  locator.registerFactory<Http>(() => HttpService(
      baseUrl: environment.getVar('SERVER_URL'), tokenTable: 'auth'));

  locator.registerFactory<AuthAPI>(() => AuthenticationService());
}