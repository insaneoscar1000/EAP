import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/storage_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class ContactDetailsViewModel extends BaseViewModel {
  Contact? _contact;

  Contact get contact => _contact!;

  void setContact(Contact contact) {
    _contact = contact;
    notifyListeners();
  }
  final _contactService = locator<ContactService>();
  final _storageService = locator<StorageService>();

  Future<void> deleteContact(String contactId) async {
    setBusy(true);
    try {
      final userId = await _storageService.getString(StorageConstants.userId);
      if (userId == null) {
        throw Exception('User not found');
      }
      await _contactService.deleteContact(userId, contactId);
      setBusy(false);
    } catch (e) {
      setBusy(false);
      rethrow;
    }
  }

  Future<void> updateContact(Contact contact) async {
    setBusy(true);
    try {
      final userId = await _storageService.getString(StorageConstants.userId);
      if (userId == null) {
        throw Exception('User not found');
      }
      await _contactService.updateContact(userId, contact);
      setBusy(false);
    } catch (e) {
      setBusy(false);
      rethrow;
    }
  }
}
