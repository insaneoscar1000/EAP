import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String name;
  final String? projectId;    // Project ID for project-specific tasks
  final String? projectName;  // 'General' or custom project name
  final String? description;
  final Timestamp date;        // Start date
  final String? startTime;     // Start time as string (HH:MM)
  final Timestamp? endDate;    // End date
  final String? endTime;       // End time as string (HH:MM)
  final bool isCompleted;
  final String userId;

  Task({
    required this.id,
    required this.name,
    this.projectId,
    this.projectName,
    this.description,
    required this.date,
    this.startTime,
    this.endDate,
    this.endTime,
    required this.isCompleted,
    required this.userId,
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      name: map['name'] ?? '',
      projectId: map['projectId'],
      projectName: map['projectName'] ?? map['category'] ?? 'General', // Support for legacy data
      description: map['description'],
      date: map['date'] ?? Timestamp.now(),
      startTime: map['startTime'],
      endDate: map['endDate'],
      endTime: map['endTime'],
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'projectId': projectId,
      'projectName': projectName,
      'description': description,
      'date': date,
      'startTime': startTime,
      'endDate': endDate,
      'endTime': endTime,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }

  Task copyWith({
    String? id,
    String? name,
    String? projectId,
    String? projectName,
    String? description,
    Timestamp? date,
    String? startTime,
    Timestamp? endDate,
    String? endTime,
    bool? isCompleted,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endDate: endDate ?? this.endDate,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }
}
