import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/utils/show_toast.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final UserService _userService = locator<UserService>();
  final StorageService _storageService = locator<StorageService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  Future<void> login(
      BuildContext context, String email, String password) async {
    setBusy(true);
    String? userId =
        await _authService.signInWithEmailAndPassword(email, password);

    if (userId != null) {
      String? token = await _pushNotificationService.getToken();

      if (token != null) {
        await _userService.updateUser(userId, {'token': token});
      }

      _storageService.setString(StorageConstants.userId, userId);
      _navigationService.navigateToReplacement(RoutePaths.home);
    } else {
      showToast('Invalid email or password. Please try again.');
    }
    setBusy(false);
  }
}
