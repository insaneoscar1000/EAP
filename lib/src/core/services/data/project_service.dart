import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = locator<AuthService>();

  // Collection reference
  CollectionReference get _projectsCollection =>
      _firestore.collection('projects');

  // Get all projects for the current user
  Stream<List<Project>> getProjects() async* {
    final user = await _authService.getCurrentUser();
    final userId = user?.uid;
    if (userId == null) {
      yield [];
      return;
    }

    yield* _projectsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Project.fromSnapshot(doc))
            .toList());
  }

  // Get a specific project by ID
  Future<Project?> getProject(String projectId) async {
    final doc = await _projectsCollection.doc(projectId).get();
    if (!doc.exists) {
      return null;
    }
    return Project.fromSnapshot(doc);
  }

  // Create a new project
  Future<String> createProject(Project project) async {
    final user = await _authService.getCurrentUser();
    final userId = user?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Add userId to the project data
    final projectData = project.copyWith(
      userId: userId,
      createdAt: Timestamp.now(),
    ).toMap();

    // Add the project to Firestore
    final docRef = await _projectsCollection.add(projectData);
    return docRef.id;
  }

  // Update an existing project
  Future<void> updateProject(Project project) async {
    if (project.id == null) {
      throw Exception('Project ID is required for update');
    }

    await _projectsCollection.doc(project.id).update(project.toMap());
  }

  // Delete a project
  Future<void> deleteProject(String projectId) async {
    await _projectsCollection.doc(projectId).delete();
  }

  // Update the current step of a project
  Future<void> updateProjectStep(String projectId, int step) async {
    await _projectsCollection.doc(projectId).update({
      'currentStep': step,
    });
  }

  // Mark a project as complete
  Future<void> completeProject(String projectId) async {
    await _projectsCollection.doc(projectId).update({
      'isComplete': true,
    });
  }
}
