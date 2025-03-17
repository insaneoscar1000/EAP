import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  final StorageService _storageService = locator<StorageService>();
  final MailService _mailService = locator<MailService>();

  Future<void> createSupportTicket(String title, String message) async {
    setBusy(true);

    String userId = (await _storageService.getString(StorageConstants.userId))!;
    UserRecord? user = await _userService.getUser(userId);

    // Send email to admins
    await _mailService.sendSupportEmailToAdmins(
        title,
        message,
        '${user!.details!.firstName!} ${user.details!.lastName!}',
        user.contact!.emailAddress!);

    // Create support ticket in Firestore
    await FirebaseFirestore.instance
        .collection(ServiceConstants.supportTickets)
        .add({
      'title': title,
      'message': message,
      'isResolved': false,
      'user': {
        'id': userId,
        'name': '${user.details!.firstName!} ${user.details!.lastName!}',
        'emailAddress': user.contact!.emailAddress!,
      },
      'meta': {
        'createdDate': FieldValue.serverTimestamp(),
        'modifiedDate': FieldValue.serverTimestamp(),
      }
    });

    setBusy(false);
    notifyListeners();
  }
}
