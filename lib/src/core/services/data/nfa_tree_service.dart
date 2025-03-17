import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class NFATreeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<NFATree>> getNFATrees() {
    return _firestore
        .collection(ServiceConstants.nfaTrees)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NFATree.fromMap(doc.id, doc.data()))
            .toList());
  }
}
