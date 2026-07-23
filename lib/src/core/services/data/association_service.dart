import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/association.dart';

class AssociationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Association>> getAssociations() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection(ServiceConstants.associations).get();

      final List<Association> associations = snapshot.docs
          .map((doc) => Association.fromMap(
                doc.data() as Map<String, dynamic>,
                id: doc.id,
              ))
          .toList();
      associations.sort((Association a, Association b) =>
          a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      return associations;
    } catch (e) {
      throw Exception('Failed to fetch associations: $e');
    }
  }
}
