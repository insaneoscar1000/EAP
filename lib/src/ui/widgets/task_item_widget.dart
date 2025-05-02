import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_eap_app/src/core/models/models.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool) onToggleCompletion;
  final bool showProjectName;

  const TaskItemWidget({
    Key? key,
    required this.task,
    required this.onTap,
    required this.onToggleCompletion,
    this.showProjectName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Apply greyed-out style for completed tasks
    final isCompleted = task.isCompleted;
    final cardColor = isCompleted ? Colors.grey.withOpacity(0.2) : Colors.white;
    final textColor = isCompleted ? Colors.grey : Colors.black87;
    final dateFormat = DateFormat('dd MMMM yyyy');

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 1,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: task.isCompleted
              ? Colors.green.withOpacity(0.5)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Checkbox on the left
                  GestureDetector(
                    onTap: () {
                      // Toggle completion without navigating to edit
                      onToggleCompletion(!task.isCompleted);
                    },
                    child: Checkbox(
                      value: task.isCompleted,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        onToggleCompletion(value ?? false);
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  // Date display (start date - end date if different)
                  Expanded(
                    child: task.endDate != null && 
                          !_isSameDay(task.date.toDate(), task.endDate!.toDate()) ?
                      // Show start date - end date
                      Text(
                        "${dateFormat.format(task.date.toDate())} - ${dateFormat.format(task.endDate!.toDate())}",
                        style: TextStyle(
                          fontSize: 14,
                          color: isCompleted ? Colors.grey : Colors.grey[700],
                        ),
                      ) :
                      // Show only start date
                      Text(
                        dateFormat.format(task.date.toDate()),
                        style: TextStyle(
                          fontSize: 14,
                          color: isCompleted ? Colors.grey : Colors.grey[700],
                        ),
                      ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 8, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task name
                    Text(
                      task.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                        color: textColor,
                      ),
                    ),
                    // Project name (only shown in My To Do List view)
                    if (showProjectName) ...[
                      SizedBox(height: 4),
                      Text(
                        task.projectName ?? 'General',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                    SizedBox(height: 8),
                    // Task description
                    if (task.description != null && task.description!.isNotEmpty)
                      Text(
                        task.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: isCompleted ? Colors.grey : Colors.black54,
                        ),
                      ),
                    // Display time information if available
                    if (task.startTime != null && task.startTime!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              task.startTime!,
                              style: TextStyle(
                                fontSize: 14,
                                color: isCompleted ? Colors.grey : Colors.grey[700],
                              ),
                            ),
                            if (task.endTime != null && task.endTime!.isNotEmpty) ...[  
                              Text(' - ', style: TextStyle(color: Colors.grey[700])),
                              Text(
                                task.endTime!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isCompleted ? Colors.grey : Colors.grey[700],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
