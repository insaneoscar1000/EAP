import 'package:get_it/get_it.dart';
import 'package:the_eap_app/src/core/services/services.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // App Services
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => StorageService());
  locator.registerLazySingleton(() => PushNotificationService());
  locator.registerLazySingleton(() => DialogService());

  // Firebase Services
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => MailService());
  locator.registerLazySingleton(() => AssociationService());
  locator.registerLazySingleton(() => AcronymService());
  locator.registerLazySingleton(() => DefinitionService());
  locator.registerLazySingleton(() => LawHubService());
  locator.registerLazySingleton(() => ContactService());
  locator.registerLazySingleton(() => NWARegService());
  locator.registerLazySingleton(() => NFATreeService());
  locator.registerLazySingleton(() => NEMAActivityService());
  locator.registerLazySingleton(() => AdvertService());
  locator.registerLazySingleton(() => EventService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => TaskService());
  locator.registerLazySingleton(() => ProjectService());
  locator.registerLazySingleton(() => IAPService());
  locator.registerLazySingleton(() => SubscriptionService());
}
