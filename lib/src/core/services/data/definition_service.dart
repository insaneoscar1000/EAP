import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/constants/service_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class DefinitionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Definition>> getDefinitions() {
    return _firestore
        .collection(ServiceConstants.definitions)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Definition.fromMap(doc.id, doc.data()))
            .toList());
  }
}
