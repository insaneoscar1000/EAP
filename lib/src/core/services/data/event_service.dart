import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:the_eap_app/src/core/constants/service_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class EventService {
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection(ServiceConstants.events);

  Stream<List<Event>> get events {
    return _eventsCollection
        .where('status', isEqualTo: 'Approved')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Event.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<String> createEvent(Map<String, dynamic> event) async {
    try {
      // Validate required fields -- must match exactly what the create
      // form itself marks with a "*" (title/name, contact name/email).
      // Organization is optional in the UI; this check used to require
      // it too, so leaving it blank silently threw here with no error
      // ever shown to the user (nothing in the view displays the
      // model's error state), making it look like "Create Event" just
      // did nothing.
      if (event['name'] == null || event['name'].isEmpty ||
          event['contact'] == null || event['contact']['name'] == null || event['contact']['name'].isEmpty ||
          event['contact']['emailAddress'] == null || event['contact']['emailAddress'].isEmpty) {
        throw Exception('Please fill in all required fields');
      }

      // Set default status to 'Pending' if not provided
      if (event['status'] == null || event['status'].isEmpty) {
        event['status'] = 'Pending';
      }

      final doc = await _eventsCollection.add(event);
      return doc.id;
    } catch (e) {
      throw Exception('Failed to create event: $e');
    }
  }

  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    try {
      await _eventsCollection.doc(eventId).update(data);
    } catch (e) {
      throw Exception('Failed to update event: $e');
    }
  }

  // Takes an XFile (not dart:io's File) because this upload runs on the
  // web build only -- File's path-based APIs don't work there at all
  // (there's no filesystem), which is why event flyer images silently
  // never made it to Storage. XFile.readAsBytes()/mimeType work
  // identically on web and mobile.
  Future<String> uploadEventImage(String eventId, XFile file) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('events/$eventId/${file.name}');
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
