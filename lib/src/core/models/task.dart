import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String name;
  final String? projectName;
  final String? description;
  final Timestamp date;
  final bool isCompleted;
  final String userId;
  final String category; // 'General' or 'Projects'

  Task({
    required this.id,
    required this.name,
    this.projectName,
    this.description,
    required this.date,
    required this.isCompleted,
    required this.userId,
    required this.category,
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      name: map['name'] ?? '',
      projectName: map['projectName'],
      description: map['description'],
      date: map['date'] ?? Timestamp.now(),
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'] ?? '',
      category: map['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'projectName': projectName,
      'description': description,
      'date': date,
      'isCompleted': isCompleted,
      'userId': userId,
      'category': category,
    };
  }

  Task copyWith({
    String? id,
    String? name,
    String? projectName,
    String? description,
    Timestamp? date,
    bool? isCompleted,
    String? userId,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
      category: category ?? this.category,
    );
  }
}
