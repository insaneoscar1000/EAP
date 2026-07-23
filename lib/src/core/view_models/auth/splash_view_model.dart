import 'package:flutter/foundation.dart';
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

    // On web, respect deep links. If the user requested a specific path
    // (e.g. `/subscription`), Flutter has already placed it on top of
    // the splash route — we should not redirect over it, or the user
    // sees the destination flash and then get yanked away.
    if (kIsWeb) {
      final String path = Uri.base.path;
      if (path.isNotEmpty && path != '/' && path != '/splash') {
        return;
      }
    }

    final String? userId =
        await _storageService.getString(StorageConstants.userId);

    final String destination = (userId == null || userId.isEmpty)
        ? RoutePaths.welcome
        : '/landing';

    await Future<void>.delayed(const Duration(milliseconds: 2000));
    _navigationService.navigateToReplacement(destination);
  }
}
