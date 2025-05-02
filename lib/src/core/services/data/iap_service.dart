import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class IAPService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = locator<AuthService>();

  // Collection reference
  CollectionReference get _iapsCollection => _firestore.collection('iaps');

  // Get all I&APs for a specific project
  Stream<List<IAP>> getIAPsForProject(String projectId) async* {
    final user = await _authService.getCurrentUser();
    final userId = user?.uid;
    if (userId == null) {
      yield [];
      return;
    }
    
    // Debug print to verify projectId
    print('Fetching IAPs for projectId: $projectId');

    yield* _iapsCollection
        .where('projectId', isEqualTo: projectId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final iaps = snapshot.docs
              .map((doc) => IAP.fromSnapshot(doc))
              .toList();
          
          // Debug print to verify results
          print('Found ${iaps.length} IAPs for project $projectId');
          return iaps;
        });
  }

  // Get a specific I&AP by ID
  Future<IAP?> getIAP(String iapId) async {
    final doc = await _iapsCollection.doc(iapId).get();
    if (!doc.exists) {
      return null;
    }
    return IAP.fromSnapshot(doc);
  }

  // Create a new I&AP
  Future<String> createIAP(IAP iap) async {
    final user = await _authService.getCurrentUser();
    final userId = user?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    
    // Debug print to verify the IAP data before saving
    print('Creating IAP with projectId: ${iap.projectId}');
    print('IAP data: ${iap.toMap()}');

    // Add the I&AP to Firestore
    final docRef = await _iapsCollection.add(iap.toMap());
    print('IAP created with ID: ${docRef.id}');
    return docRef.id;
  }

  // Update an existing I&AP
  Future<void> updateIAP(IAP iap) async {
    if (iap.id == null) {
      throw Exception('I&AP ID is required for update');
    }

    await _iapsCollection.doc(iap.id).update(iap.toMap());
  }

  // Delete an I&AP
  Future<void> deleteIAP(String iapId) async {
    await _iapsCollection.doc(iapId).delete();
  }
}
