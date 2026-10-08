import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class NEMService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<NEMWasteActivity>> getWasteActivities() {
    return _firestore
        .collection(ServiceConstants.nemWasteActivities)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final List<NEMWasteActivity> list = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              NEMWasteActivity.fromMap(doc.id, doc.data()))
          .toList();
      list.sort((NEMWasteActivity a, NEMWasteActivity b) =>
          a.sortOrder.compareTo(b.sortOrder));
      return list;
    });
  }

  Stream<List<NEMWasteNorm>> getWasteNorms() {
    return _firestore
        .collection(ServiceConstants.nemWasteNorms)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final List<NEMWasteNorm> list = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              NEMWasteNorm.fromMap(doc.id, doc.data()))
          .toList();
      list.sort((NEMWasteNorm a, NEMWasteNorm b) =>
          a.sortOrder.compareTo(b.sortOrder));
      return list;
    });
  }

  Stream<List<NEMAQActivity>> getAQActivities() {
    return _firestore
        .collection(ServiceConstants.nemAqActivities)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      final List<NEMAQActivity> list = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              NEMAQActivity.fromMap(doc.id, doc.data()))
          .toList();
      list.sort((NEMAQActivity a, NEMAQActivity b) =>
          a.sortOrder.compareTo(b.sortOrder));
      return list;
    });
  }
}
