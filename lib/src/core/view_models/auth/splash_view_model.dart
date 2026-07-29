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
  final SubscriptionService _subscriptionService =
      locator<SubscriptionService>();

  Future<void> initialiseApplication() async {
    await _pushNotificationService.requestNotificationPermissions();

    final String? userId =
        await _storageService.getString(StorageConstants.userId);

    // Re-bind the subscription listener for a returning session, on every
    // platform — a persisted login (app relaunch, PayStack's browser
    // redirect back to `/subscription/return`, Android killing and
    // restarting the app in the background) all boot through here rather
    // than through login/sign-up, which are the only other places that
    // call `bind()`. Without this, a returning paid subscriber's
    // in-memory subscription cache stays null/stale forever and every
    // gated page bounces them back to the paywall.
    if (userId != null && userId.isNotEmpty) {
      await _subscriptionService.bind(userId);
    }

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

    final String destination = (userId == null || userId.isEmpty)
        ? RoutePaths.welcome
        : '/landing';

    await Future<void>.delayed(const Duration(milliseconds: 2000));
    _navigationService.navigateToReplacement(destination);
  }
}
