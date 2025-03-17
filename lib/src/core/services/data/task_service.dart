import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class TaskService {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Stream<List<Task>> getTasksForUser(String userId) {
    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Task.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Stream<List<Task>> getTasksForDate(String userId, DateTime date) {
    // Create DateTime range for the selected date (start of day to end of day)
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _tasksCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              Task.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<String> createTask(Map<String, dynamic> task) async {
    try {
      if (task['name'] == null || task['name'].isEmpty || 
          task['userId'] == null || task['userId'].isEmpty) {
        throw Exception('Please fill in all required fields');
      }

      final doc = await _tasksCollection.add(task);
      return doc.id;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    try {
      await _tasksCollection.doc(taskId).update(data);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _tasksCollection.doc(taskId).update({'isCompleted': isCompleted});
    } catch (e) {
      throw Exception('Failed to update task completion status: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
