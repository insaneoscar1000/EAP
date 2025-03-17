import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/utils/utils.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/services/services.dart';

class SignUpViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final UserService _userService = locator<UserService>();
  final StorageService _storageService = locator<StorageService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  Future<void> handleSignUpProcess(
    BuildContext context,
    String email,
    String password,
    String firstName,
    String lastName,
    String? dateOfBirth,
  ) async {
    setBusy(true);

    User? user = await signUp(email.replaceAll(' ', ''), password);

    if (user != null) {
      bool createUserResult = (await createUser(
        user.uid,
        email.replaceAll(' ', ''),
        firstName,
        lastName,
        dateOfBirth?.isNotEmpty == true
            ? DateFormat('d MMMM yyyy').parse(dateOfBirth!)
            : null,
      ));
      if (createUserResult) {
        await _storageService.setString(StorageConstants.userId, user.uid);
        _navigationService.navigateToReplacement(RoutePaths.tabs);
      } else {
        showToast('Failed to create account. Please try again.');
      }
    } else {
      showToast('Failed to create account. Please try again.');
    }
    setBusy(false);
  }

  Future<User?> signUp(String email, String password) async {
    return await _authService.createUserWithEmailAndPassword(email, password);
  }

  Future<bool> createUser(
    String uid,
    String emailAddress,
    String firstName,
    String lastName,
    DateTime? dateOfBirth,
  ) async {
    setBusy(true);

    String? token = await _pushNotificationService.getToken();
    Map<String, dynamic> data = <String, dynamic>{
      'token': token ?? '',
      'details': <String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth
      },
      'contact': <String, dynamic>{'emailAddress': emailAddress},
      'meta': <String, dynamic>{
        'createdDate': FieldValue.serverTimestamp(),
        'modifiedDate': FieldValue.serverTimestamp()
      },
    };

    bool response = await _userService
        .createUser(uid, data)
        .whenComplete(() => setBusy(false));

    return response;
  }
}
