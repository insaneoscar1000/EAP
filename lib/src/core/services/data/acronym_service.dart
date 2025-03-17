import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/acronym.dart';

class AcronymService {
  final CollectionReference _acronymsCollection =
      FirebaseFirestore.instance.collection(ServiceConstants.acronyms);

  Stream<List<Acronym>> getAcronyms() {
    return _acronymsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Acronym.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
