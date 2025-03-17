import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/contact.dart';
import 'package:the_eap_app/src/core/services/services.dart';

class EditContactViewModel extends BaseViewModel {
  final ContactService _contactService = ContactService();
  final StorageService _storageService = StorageService();

  Future<void> updateContact({
    required String id,
    required String name,
    required String organisation,
    String? phoneNumber1,
    String? phoneNumber2,
    String? emailAddress,
    String? physicalAddress,
    String? notes,
  }) async {
    setBusy(true);

    try {
      final userId = await _storageService.getString(StorageConstants.userId);
      if (userId == null) throw Exception('User not found');

      final contact = Contact(
        id: id,
        name: name,
        organisation: organisation,
        phoneNumber1: phoneNumber1,
        phoneNumber2: phoneNumber2,
        emailAddress: emailAddress,
        physicalAddress: physicalAddress,
        notes: notes,
      );

      await _contactService.updateContact(userId, contact);
    } finally {
      setBusy(false);
    }
  }
}
