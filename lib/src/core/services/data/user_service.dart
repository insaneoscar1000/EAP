import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createUser(String id, dynamic data) async {
    try {
      await _firestore.collection(ServiceConstants.users).doc(id).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<UserRecord> getUserStream(String userId) {
    return _firestore
        .collection(ServiceConstants.users)
        .doc(userId)
        .snapshots()
        .map((snapshot) => UserRecord.fromMap(snapshot.data(), snapshot.id));
  }

  Future<UserRecord?> getUser(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> result =
          await _firestore.collection(ServiceConstants.users).doc(userId).get();
      return UserRecord.fromMap(result.data(), result.id);
    } catch (e) {
      return null;
    }
  }

  Stream<List<UserRecord>> getAllUsers() {
    return _firestore.collection(ServiceConstants.users).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => UserRecord.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<bool> updateUser(String userId, dynamic data) async {
    try {
      await _firestore
          .collection(ServiceConstants.users)
          .doc(userId)
          .update(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(ServiceConstants.users).doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user data: $e');
    }
  }

  Future<int> getUserCount() async {
    try {
      final snapshot = await _firestore.collection(ServiceConstants.users).count().get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
