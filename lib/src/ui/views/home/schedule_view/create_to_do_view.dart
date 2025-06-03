import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:the_eap_app/src/core/models/task.dart';
import 'package:the_eap_app/src/core/view_models/home/schedule_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class CreateToDoView extends StatefulWidget {
  final Task? task; // Task to edit, null if creating a new task

  const CreateToDoView({Key? key, this.task}) : super(key: key);

  @override
  _CreateToDoViewState createState() => _CreateToDoViewState();
}

class _CreateToDoViewState extends State<CreateToDoView> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // For date and time selection
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  // For dropdown
  String selectedProject = 'General';

  // Track field validation
  bool _taskNameError = false;
  bool _startDateError = false;
  bool _startTimeError = false;
  bool _endDateError = false;
  bool _endTimeError = false;

  @override
  void initState() {
    super.initState();

    // If we're editing a task, prepopulate the fields
    if (widget.task != null) {
      final task = widget.task!;

      // Set task name
      taskNameController.text = task.name;

      // Set description
      if (task.description != null && task.description!.isNotEmpty) {
        descriptionController.text = task.description!;
      }

      // Set project
      selectedProject = task.projectName ?? 'General';

      // Set start date
      startDateController.text =
          DateFormat('dd/MM/yyyy').format(task.date.toDate());

      // Set start time
      if (task.startTime != null && task.startTime!.isNotEmpty) {
        startTimeController.text = task.startTime!;
      }

      // Set end date
      if (task.endDate != null) {
        endDateController.text =
            DateFormat('dd/MM/yyyy').format(task.endDate!.toDate());
      }

      // Set end time
      if (task.endTime != null && task.endTime!.isNotEmpty) {
        endTimeController.text = task.endTime!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScheduleViewModel>.reactive(
      viewModelBuilder: () => ScheduleViewModel(),
      onModelReady: (model) {
        model.fetchTasks();
        model.fetchProjects();
      },
      builder: (context, model, child) {
        // Determine if we're editing or creating
        final bool isEditing = widget.task != null;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            title: Text(
              isEditing ? 'Edit To Do' : 'Create To Do',
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.chevron_left,
                  size: 34, color: Theme.of(context).primaryColorLight),
              onPressed: model.navigateBack,
            ),
          ),
          body: BackgroundContainer(
            background: 'background-2',
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProjectDropdown(context),
                      SizedBox(height: 20),
                      _buildTaskNameField(context),
                      SizedBox(height: 20),
                      _buildDescriptionField(context),
                      SizedBox(height: 20),
                      _buildDateTimeFields(context),
                      SizedBox(height: 40),
                      _buildCreateButton(context, model),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectDropdown(BuildContext context) {
    return ViewModelBuilder<ScheduleViewModel>.reactive(
      viewModelBuilder: () => ScheduleViewModel(),
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.fetchProjects(),
      builder: (context, model, child) {
        // Debug: Print project names to console
        print('Available projects: ${model.projectNames.join(', ')}');
        print('Projects count: ${model.projects.length}');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Name (${model.projects.length} projects available)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: model.projectNames.contains(selectedProject)
                      ? selectedProject
                      : 'General',
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedProject = newValue;
                      });
                    }
                  },
                  items: model.projectNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text('Select a project...'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskNameField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Event/Task Name',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _taskNameError ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: TextField(
            controller: taskNameController,
            decoration: InputDecoration(
              hintText: 'Start typing...',
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: _taskNameError
                  ? Icon(Icons.error_outline, color: Colors.red)
                  : null,
            ),
            onChanged: (value) {
              if (value.trim().isNotEmpty && _taskNameError) {
                setState(() {
                  _taskNameError = false;
                });
              }
            },
          ),
        ),
        if (_taskNameError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              'Task name is required',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Add description (optional)',
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            maxLines: 3, // Allow multiple lines for the description
            textInputAction: TextInputAction.newline,
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeFields(BuildContext context) {
    return Column(
      children: [
        // First row - Start Date and Start Time
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                'Start Date *',
                startDateController,
                () => _selectDate(context, startDateController),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTimeField(
                context,
                'Start Time *',
                startTimeController,
                () => _selectTime(context, startTimeController),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        // Second row - End Date and End Time
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                'End Date',
                endDateController,
                () => _selectDate(context, endDateController),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTimeField(
                context,
                'End Time',
                endTimeController,
                () => _selectTime(context, endTimeController),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context, String label,
      TextEditingController controller, VoidCallback onTap) {
    bool isError = (controller == startDateController && _startDateError);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isError ? Colors.red : Colors.grey.shade300,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 20, color: isError ? Colors.red : Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? 'DD/MM/YYYY' : controller.text,
                    style: TextStyle(
                      color: controller.text.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
                if (isError)
                  Icon(Icons.error_outline, color: Colors.red, size: 20),
              ],
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              'Date is required',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeField(BuildContext context, String label,
      TextEditingController controller, VoidCallback onTap) {
    bool isError = (controller == startTimeController && _startTimeError) ||
        (controller == endTimeController && _endTimeError);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isError ? Colors.red : Colors.grey.shade300,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.access_time,
                    size: 20, color: isError ? Colors.red : Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? 'HH:MM' : controller.text,
                    style: TextStyle(
                      color: controller.text.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
                if (isError)
                  Icon(Icons.error_outline, color: Colors.red, size: 20),
              ],
            ),
          ),
        ),
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              'Time is required',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);

        // Clear error state if field is filled
        if (controller == startDateController) {
          _startDateError = false;
        }
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).primaryColor,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);

        // If user picked start time, auto-set end time 1 hour later if end time is empty
        if (controller == startTimeController) {
          _startTimeError = false;
          if (endTimeController.text.isEmpty) {
            // Calculate 1 hour later
            final end = TimeOfDay(
              hour: (picked.hour + 1) % 24,
              minute: picked.minute,
            );
            endTimeController.text = end.format(context);
          }
        } else if (controller == endTimeController) {
          _endTimeError = false;
        }
      });
    }
  }

  Widget _buildCreateButton(BuildContext context, ScheduleViewModel model) {
    // Determine if we're editing or creating
    final bool isEditing = widget.task != null;

    if (isEditing) {
      // For editing, show both delete and update buttons side by side
      return Row(
        children: [
          // Delete button
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text('Delete', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Task'),
                      content:
                          Text('Are you sure you want to delete this task?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            model.deleteTask(widget.task!.id);
                            model.navigateBack(); // Go back to schedule view
                          },
                          child: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16), // Spacing between buttons
          // Update button
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  _validateAndSubmit(context, model);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // For creating, show only the create button
      return SizedBox(
        height: 56,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _validateAndSubmit(context, model);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Create',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  void _validateAndSubmit(BuildContext context, ScheduleViewModel model) {
    // Validate all fields
    bool isValid = true;

    setState(() {
      // Check task name
      if (taskNameController.text.trim().isEmpty) {
        _taskNameError = true;
        isValid = false;
      } else {
        _taskNameError = false;
      }

      // Check start date - always required
      if (startDateController.text.isEmpty) {
        _startDateError = true;
        isValid = false;
      } else {
        _startDateError = false;
      }

      // Check start time - always required
      if (startTimeController.text.isEmpty) {
        _startTimeError = true;
        isValid = false;
      } else {
        _startTimeError = false;
      }

      // Check end time - required if end date is set
      if (endTimeController.text.isEmpty && endDateController.text.isNotEmpty) {
        _endTimeError = true;
        isValid = false;
      } else {
        _endTimeError = false;
      }
    });

    if (isValid) {
      // Parse date strings to DateTime objects
      DateTime? endDate;
      if (endDateController.text.isNotEmpty) {
        try {
          final parts = endDateController.text.split('/');
          if (parts.length == 3) {
            endDate = DateTime(
              int.parse(parts[2]), // year
              int.parse(parts[1]), // month
              int.parse(parts[0]), // day
            );
          }
        } catch (e) {
          // Handle date parsing error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid date format')),
          );
          return;
        }
      } else {
        endDate = DateTime(
          int.parse(startDateController.text.split('/')[2]), // year
          int.parse(startDateController.text.split('/')[1]), // month
          int.parse(startDateController.text.split('/')[0]), // day
        );
      }

      if (widget.task != null) {
        // Update existing task
        model.updateTask(
          widget.task!.id,
          taskNameController.text.trim(),
          selectedProject,
          descriptionController.text.trim(),
          startTime: startTimeController.text,
          endDate: endDate,
          endTime: endTimeController.text,
        );
      } else {
        // Create new task
        model.addTask(
          taskNameController.text.trim(),
          selectedProject,
          descriptionController.text.trim(),
          startTime: startTimeController.text,
          endDate: endDate,
          endTime: endTimeController.text,
        );
      }

      model.navigateBack();
    }
  }
}
