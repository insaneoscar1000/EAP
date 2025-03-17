import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/constants/service_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class ContactService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<Contact>> getContacts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection(ServiceConstants.contacts)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Contact.fromFirestore(doc)).toList());
  }

  Future<void> addContact(String userId, Contact contact) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection(ServiceConstants.contacts)
        .add(contact.toMap());
  }

  Future<void> updateContact(String userId, Contact contact) async {
    if (contact.id == null) {
      throw Exception('Cannot update contact without an ID');
    }
    await _firestore
        .collection('users')
        .doc(userId)
        .collection(ServiceConstants.contacts)
        .doc(contact.id!)
        .update(contact.toMap());
  }

  Future<void> deleteContact(String userId, String contactId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection(ServiceConstants.contacts)
        .doc(contactId)
        .delete();
  }
}
