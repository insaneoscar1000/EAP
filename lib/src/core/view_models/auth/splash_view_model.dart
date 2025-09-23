import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';

class SplashViewModel extends BaseViewModel {
  final StorageService _storageService = locator<StorageService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  Future<void> initialiseApplication() async {
    await _pushNotificationService.requestNotificationPermissions();
    String? userId = await _storageService.getString(StorageConstants.userId);

    if (userId == '' || userId == null) {
      Future<void>.delayed(const Duration(milliseconds: 2000)).then(
          (dynamic onValue) =>
              _navigationService.navigateToReplacement(RoutePaths.welcome));
    } else {
      Future<void>.delayed(const Duration(milliseconds: 2000)).then(
          (dynamic onValue) =>
              _navigationService.navigateToReplacement('/landing'));
    }
  }
}
