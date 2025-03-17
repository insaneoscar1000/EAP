import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/services/services.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();

  Future<bool> resetPassword(BuildContext context, String email) async {
    setBusy(true);

    bool response = await _authService.sendForgotPasswordEmail(email);

    setBusy(false);

    return response;
  }
}
