import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/storage_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class AddContactViewModel extends BaseViewModel {
  final _contactService = locator<ContactService>();
  final _storageService = locator<StorageService>();

  Future<void> createContact({
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
      if (userId == null) {
        throw Exception('User not found');
      }

      final contact = Contact(
        name: name,
        organisation: organisation,
        phoneNumber1: phoneNumber1,
        phoneNumber2: phoneNumber2,
        emailAddress: emailAddress,
        physicalAddress: physicalAddress,
        notes: notes,
      );

      await _contactService.addContact(userId, contact);
      setBusy(false);
    } catch (e) {
      setBusy(false);
      rethrow;
    }
  }
}
