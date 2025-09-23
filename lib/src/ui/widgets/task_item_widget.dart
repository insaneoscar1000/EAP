import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/utils/project_color_utils.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool) onToggleCompletion;
  final bool showProjectName;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleCompletion,
    this.showProjectName = false,
  });

  @override
  Widget build(BuildContext context) {
    // Apply greyed-out style for completed tasks
    final bool isCompleted = task.isCompleted;
    final Color textColor = isCompleted ? Colors.grey : Colors.black87;

    // Format dates for display
    final DateFormat dateFormat = DateFormat('d MMMM yyyy');
    String dateText = '';

    dateText = dateFormat.format(task.date.toDate());
    if (task.endDate != null) {
      dateText =
          '${dateFormat.format(task.date.toDate())} - ${dateFormat.format(task.endDate!.toDate())}';
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ProjectColorUtils.getColorForProject(task.projectName),
          width: 2.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Checkbox
                  Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: task.isCompleted,
                      activeColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (bool? value) {
                        onToggleCompletion(value ?? false);
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  // Task details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Task name
                        Text(
                          task.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        // Date range
                        if (dateText.isNotEmpty)
                          Text(
                            dateText,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        // Project name
                        Text(
                          task.projectName ?? 'General',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
