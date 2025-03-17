import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/storage_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class ContactsViewModel extends StreamViewModel<List<Contact>> {
  final _contactService = locator<ContactService>();
  final _storageService = locator<StorageService>();

  String _searchQuery = '';
  List<Contact> _allContacts = [];

  List<Contact> get contacts {
    if (_searchQuery.isEmpty) return _allContacts;
    return _allContacts.where((contact) {
      final query = _searchQuery.toLowerCase();
      return contact.name.toLowerCase().contains(query) ||
          contact.organisation.toLowerCase().contains(query) ||
          (contact.emailAddress?.toLowerCase().contains(query) ?? false) ||
          (contact.phoneNumber1?.toLowerCase().contains(query) ?? false) ||
          (contact.phoneNumber2?.toLowerCase().contains(query) ?? false) ||
          (contact.physicalAddress?.toLowerCase().contains(query) ?? false) ||
          (contact.notes?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Stream<List<Contact>> get stream =>
      Stream.fromFuture(_storageService.getString(StorageConstants.userId))
          .asyncExpand((userId) {
        if (userId == null) return Stream.value([]);
        return _contactService.getContacts(userId);
      });

  @override
  void onData(List<Contact>? data) {
    if (data != null) {
      _allContacts = data;
      notifyListeners();
    }
  }

  void onSearchQueryChanged(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    final userId = await _storageService.getString(StorageConstants.userId);
    if (userId == null) return;
    await _contactService.addContact(userId, contact);
  }

  Future<void> updateContact(Contact contact) async {
    final userId = await _storageService.getString(StorageConstants.userId);
    if (userId == null) return;
    await _contactService.updateContact(userId, contact);
  }

  Future<void> deleteContact(String contactId) async {
    final userId = await _storageService.getString(StorageConstants.userId);
    if (userId == null) return;
    await _contactService.deleteContact(userId, contactId);
  }
}
