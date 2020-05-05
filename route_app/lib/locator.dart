import 'package:get_it/get_it.dart';
import 'package:route_app/core/services/API/trip_service.dart';
import 'package:route_app/core/services/API/web_service.dart';
import 'package:route_app/core/services/gmaps_service.dart';
import 'package:route_app/core/services/gsuggestions_service.dart';
import 'package:route_app/core/services/interfaces/API/auth.dart';
import 'package:route_app/core/services/interfaces/API/logging.dart';
import 'package:route_app/core/services/interfaces/API/user.dart';
import 'package:route_app/core/services/interfaces/gmaps.dart';
import 'package:route_app/core/services/interfaces/gsuggestions.dart';
import 'package:route_app/core/services/interfaces/http.dart';
import 'package:route_app/core/services/API/auth_service.dart';
import 'package:route_app/core/services/API/http_service.dart';
import 'package:route_app/core/services/API/user_service.dart';
import 'package:route_app/core/services/database.dart';
import 'package:route_app/core/utils/environment.dart' as environment;
import 'package:route_app/core/services/interfaces/web.dart';
import 'package:route_app/core/services/API/logging_service.dart';

/// Instantiates the dependency injection
GetIt locator = GetIt.instance;

/// Register all dependencies
void setupLocator() {
  // Example of Singleton, One instance thought the app
  // locator.registerLazySingleton(() => Api());
  locator.registerLazySingleton<DatabaseService>(() => DatabaseService(
      databaseName: 'testDBv3',
      version: environment.getVar<int>('DATABASE_VERSION')));

  locator.registerLazySingleton<UserAPI>(() => UserService());
  locator.registerLazySingleton<AuthAPI>(() => AuthenticationService());
  locator.registerLazySingleton<LoggingAPI>(() => LoggingService());
  locator.registerLazySingleton<TripService>(() => TripService());

  // Example of factory, New instance with each call
  // locator.registerFactory(() => Api());

  locator.registerFactory<Http>(() => HttpService(
      baseUrl: environment.getVar('SERVER_URL'), tokenTable: 'auth'));
  locator.registerFactory<GoogleMapsAPI>(
      () => GoogleMapsService(environment.getVar('GOOGLE_API_KEY')));
  locator.registerFactory<GoogleAutocompleteAPI>(
    () => GoogleAutocompleteService(environment.getVar('GOOGLE_API_KEY')));
  locator.registerFactoryParam<Web, String, void>(
      (String str, _) => WebService(baseUrl: str));
}
