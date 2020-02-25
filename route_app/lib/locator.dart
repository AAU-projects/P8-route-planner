import 'package:get_it/get_it.dart';

/// Instantiates the dependency injection
GetIt locator = GetIt.instance;

/// Register all dependencies
void setupLocator() {
  // Example of Singleton, One instance thought the app
  // locator.registerLazySingleton(() => Api());

  // Example of factory, New instance with each call
  // locator.registerFactory(() => Api());
}