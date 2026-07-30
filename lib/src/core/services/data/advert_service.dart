import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:the_eap_app/src/core/constants/service_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class AdvertService {
  final CollectionReference _advertsCollection =
      FirebaseFirestore.instance.collection(ServiceConstants.adverts);

  Stream<List<Advert>> get adverts {
    return _advertsCollection
        .where('status', isEqualTo: 'Approved')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Advert.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<String> createAdvert(Map<String, dynamic> advert) async {
    try {
      // Validate required fields -- must match exactly what the create
      // form itself marks with a "*" (title, role, location, contact
      // name/email). Company and services are optional in the UI; this
      // check used to require them too, so leaving either blank silently
      // threw here with no error ever shown to the user (nothing in the
      // view displays the model's error state), making it look like
      // "Create Listing" just did nothing.
      if (advert['title'] == null || advert['title'].isEmpty ||
          advert['role'] == null || advert['role'].isEmpty ||
          advert['location'] == null || advert['location'].isEmpty ||
          advert['contact'] == null || advert['contact']['name'] == null || advert['contact']['name'].isEmpty ||
          advert['contact']['emailAddress'] == null || advert['contact']['emailAddress'].isEmpty) {
        throw Exception('Please fill in all required fields');
      }
      
      // Set default status to 'Pending' if not provided
      if (advert['status'] == null || advert['status'].isEmpty) {
        advert['status'] = 'Pending';
      }

      final doc = await _advertsCollection.add(advert);

      return doc.id;
    } catch (e) {

      throw Exception('Failed to create advert: $e');
    }
  }

  Future<void> updateAdvert(String advertId, Map<String, dynamic> data) async {
    try {
      await _advertsCollection.doc(advertId).update(data);
    } catch (e) {
      throw Exception('Failed to update advert: $e');
    }
  }

  // Takes an XFile (not dart:io's File) because this upload runs on the
  // web build only -- File's path-based APIs don't work there at all
  // (there's no filesystem), which is why advert/event images silently
  // never made it to Storage. XFile.readAsBytes()/mimeType work
  // identically on web and mobile.
  Future<String> uploadAdvertImage(String advertId, XFile file) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('adverts/$advertId/${file.name}');
    final bytes = await file.readAsBytes();
    firebase_storage.UploadTask uploadTask = storageReference.putData(
        bytes,
        firebase_storage.SettableMetadata(
            contentType: file.mimeType ?? 'image/jpeg'));
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask
        .then((firebase_storage.TaskSnapshot snapshot) => snapshot);
    return taskSnapshot.ref.getDownloadURL().then((String value) => value);
  }
}
