import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';

class NWARegService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<NWAReg>> getNWARegs() {
    return _firestore.collection(ServiceConstants.nwaRegs).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => NWAReg.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Editable "How to do a WULA" card (subtitle + PDF link), or null if unset.
  Future<Map<String, dynamic>?> getWulaGuide() async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection(ServiceConstants.appSettings)
        .doc(ServiceConstants.wulaGuideDoc)
        .get();
    return doc.data();
  }
}
