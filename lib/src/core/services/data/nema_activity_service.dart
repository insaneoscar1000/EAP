import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class NEMAActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<NEMAActivity>> getNEMAActivities() {
    return _firestore
        .collection(ServiceConstants.nemaActivities)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NEMAActivity.fromMap(doc.id, doc.data()))
            .toList());
  }
}
