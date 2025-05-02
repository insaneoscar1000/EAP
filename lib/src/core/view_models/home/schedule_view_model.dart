import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/core/services/data/project_service.dart';
import 'package:the_eap_app/src/locator.dart';

class ScheduleViewModel extends BaseViewModel {
  final TaskService _taskService = locator<TaskService>();
  final UserService _userService = locator<UserService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final ProjectService _projectService = locator<ProjectService>();

  // List of projects for dropdown
  List<Project> _projects = [];
  List<Project> get projects => _projects;

  // Project names for dropdown (including 'General')
  List<String> get projectNames {
    final names = ['General'];

    // Debug the projects list
    if (_projects.isNotEmpty) {
      print('First project ID: ${_projects.first.id}');
      print('First project title: ${_projects.first.overview.title}');
    } else {
      print('No projects available');
    }

    // Add all project titles to the list
    names.addAll(_projects
        .where((p) => p.overview.title.isNotEmpty)
        .map((p) => p.overview.title));

    return names;
  }

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  CalendarFormat get calendarFormat => _calendarFormat;

  String _selectedCategory = 'General';
  String get selectedCategory => _selectedCategory;

  // Project type filter (General or Projects)
  bool _showGeneralOnly = true;
  bool get showGeneralOnly => _showGeneralOnly;

  // Completion status filter (To Do or Complete)
  bool _showCompletedOnly = false;
  bool get showCompletedOnly => _showCompletedOnly;

  List<Task> _allTasks = [];

  // Filter tasks based on selected date and category
  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Get all tasks for the selected date, filtered by project type and completion status
  List<Task> get allTasksForSelectedDate {
    // First filter the tasks
    final filtered = _allTasks.where((task) {
      // Check if the selected date falls within the task's date range
      bool isInDateRange = false;

      // Get start date
      final startDate = task.date.toDate();

      // Get end date (if available)
      final endDate = task.endDate?.toDate();

      if (endDate == null) {
        // If there's no end date, just check if it's the same day as the start date
        isInDateRange = _isSameDay(startDate, _selectedDate);
      } else {
        // If there is an end date, check if selected date is between start and end (inclusive)
        isInDateRange = (_selectedDate.isAtSameMomentAs(startDate) ||
                    _selectedDate.isAfter(startDate)) &&
                (_selectedDate.isAtSameMomentAs(endDate) ||
                    _selectedDate.isBefore(endDate)) ||
            _isSameDay(startDate, _selectedDate) ||
            _isSameDay(endDate, _selectedDate);
      }

      return isInDateRange &&
          // Filter by project type (General or Projects)
          (_showGeneralOnly
              ? task.projectName == 'General'
              : task.projectName != 'General') &&
          // Filter by completion status
          (task.isCompleted == _showCompletedOnly);
    }).toList();

    // Then sort based on completion status
    if (_showCompletedOnly) {
      // For completed tasks: sort from most recent to oldest
      filtered.sort((a, b) => b.date.compareTo(a.date));
    } else {
      // For to-do tasks: sort from closest date to furthest
      filtered.sort((a, b) => a.date.compareTo(b.date));
    }

    return filtered;
  }

  List<Task> get tasks {
    final filtered = _allTasks.where((task) {
      // Check if the selected date falls within the task's date range
      bool isInDateRange = false;

      // Get start date
      final startDate = task.date.toDate();

      // Get end date (if available)
      final endDate = task.endDate?.toDate();

      if (endDate == null) {
        // If there's no end date, just check if it's the same day as the start date
        isInDateRange = _isSameDay(startDate, _selectedDate);
      } else {
        // If there is an end date, check if selected date is between start and end (inclusive)
        isInDateRange = (_selectedDate.isAtSameMomentAs(startDate) ||
                    _selectedDate.isAfter(startDate)) &&
                (_selectedDate.isAtSameMomentAs(endDate) ||
                    _selectedDate.isBefore(endDate)) ||
            _isSameDay(startDate, _selectedDate) ||
            _isSameDay(endDate, _selectedDate);
      }

      return isInDateRange &&
          task.projectName == _selectedCategory &&
          !task.isCompleted;
    }).toList();

    // Sort to-do tasks from closest date to furthest
    filtered.sort((a, b) => a.date.compareTo(b.date));

    return filtered;
  }

  List<Task> get completedTasks {
    final filtered = _allTasks.where((task) {
      // Check if the selected date falls within the task's date range
      bool isInDateRange = false;

      // Get start date
      final startDate = task.date.toDate();

      // Get end date (if available)
      final endDate = task.endDate?.toDate();

      if (endDate == null) {
        // If there's no end date, just check if it's the same day as the start date
        isInDateRange = _isSameDay(startDate, _selectedDate);
      } else {
        // If there is an end date, check if selected date is between start and end (inclusive)
        isInDateRange = (_selectedDate.isAtSameMomentAs(startDate) ||
                    _selectedDate.isAfter(startDate)) &&
                (_selectedDate.isAtSameMomentAs(endDate) ||
                    _selectedDate.isBefore(endDate)) ||
            _isSameDay(startDate, _selectedDate) ||
            _isSameDay(endDate, _selectedDate);
      }

      return isInDateRange &&
          task.projectName == _selectedCategory &&
          task.isCompleted;
    }).toList();

    // Sort completed tasks from most recent to oldest
    filtered.sort((a, b) => b.date.compareTo(a.date));

    return filtered;
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    fetchTasks();
  }

  void setSelectedDate(DateTime date) {
    // Just update the selected date and notify listeners
    // No need to fetch tasks again since we're filtering from _allTasks
    _selectedDate = date;
    notifyListeners();
  }

  // These methods now just update the category and notify listeners
  // No need to fetch tasks again since we're filtering from _allTasks
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category ?? 'General';
    notifyListeners();
  }

  // Toggle between General and Projects filter
  void toggleProjectTypeFilter(bool showGeneralOnly) {
    _showGeneralOnly = showGeneralOnly;
    notifyListeners();
  }

  // Toggle between To Do and Complete filter
  void toggleCompletionStatusFilter(bool showCompletedOnly) {
    _showCompletedOnly = showCompletedOnly;
    notifyListeners();
  }

  void setCalendarFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  Future<void> initialize() async {
    // We only need to fetch tasks once when the view is initialized
    await fetchTasks();
  }

  // Store the current stream subscriptions to cancel them when needed
  StreamSubscription? _taskSubscription;
  StreamSubscription? _projectSubscription;

  Future<void> fetchTasks() async {
    try {
      setBusy(true);
      // Cancel any existing subscription to avoid memory leaks
      await _taskSubscription?.cancel();

      final firebaseUser = await _authService.getCurrentUser();
      if (firebaseUser != null) {
        final user = await _userService.getUser(firebaseUser.uid);
        if (user != null && user.id != null) {
          // Fetch all tasks for the user instead of just for the selected date
          _taskSubscription =
              _taskService.getAllTasksForUser(user.id!).listen((taskList) {
            _allTasks = taskList;
            notifyListeners();
            setBusy(false);
          });

          // Also fetch all projects
          await fetchProjects();
        }
      }
    } catch (e) {
      setError(e.toString());
      setBusy(false);
    }
  }

  Future<void> fetchProjects() async {
    try {
      print('Fetching projects...');
      // Cancel any existing subscription to avoid memory leaks
      await _projectSubscription?.cancel();

      _projectSubscription =
          _projectService.getProjects().listen((projectList) {
        print('Projects received: ${projectList.length}');
        if (projectList.isNotEmpty) {
          projectList.forEach((project) {
            print('Project: ${project.id} - ${project.overview.title}');
          });
        }

        _projects = projectList;
        notifyListeners();
      });
    } catch (e) {
      print('Error fetching projects: ${e.toString()}');
      setError(e.toString());
    }
  }

  Future<void> addTask(String name, String? projectName, String? description,
      {String? startTime, DateTime? endDate, String? endTime}) async {
    final firebaseUser = await _authService.getCurrentUser();
    if (firebaseUser != null) {
      final user = await _userService.getUser(firebaseUser.uid);
      if (user != null && user.id != null) {
        try {
          await _taskService.createTask({
            'name': name,
            'projectName': projectName ?? _selectedCategory,
            'description': description,
            'date': Timestamp.fromDate(_selectedDate),
            'startTime': startTime,
            'endDate': endDate != null ? Timestamp.fromDate(endDate) : null,
            'endTime': endTime,
            'isCompleted': false,
            'userId': user.id!,
          });
        } catch (e) {
          setError(e.toString());
        }
      }
    }
  }

  Future<void> updateTask(
      String taskId, String name, String? projectName, String? description,
      {String? startTime, DateTime? endDate, String? endTime}) async {
    try {
      // Get the existing task to preserve its completion status
      final existingTask = _allTasks.firstWhere((task) => task.id == taskId);

      await _taskService.updateTask(taskId, {
        'name': name,
        'projectName': projectName ?? existingTask.projectName,
        'description': description,
        'date': existingTask.date, // Preserve the original date
        'startTime': startTime,
        'endDate': endDate != null
            ? Timestamp.fromDate(endDate)
            : existingTask.endDate, // Preserve existing endDate if no new one
        'endTime': endTime ??
            existingTask.endTime, // Preserve existing endTime if no new one
        'isCompleted': existingTask.isCompleted, // Preserve completion status
      });
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _taskService.toggleTaskCompletion(taskId, isCompleted);
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
    } catch (e) {
      setError(e.toString());
    }
  }

  void navigateBack() {
    _navigationService.pop();
  }

  void navigateToCreateToDo() {
    _navigationService.navigateTo(RoutePaths.createToDo);
  }

  void navigateToEditToDo(Task task) {
    _navigationService.navigateTo(RoutePaths.editToDo, arguments: task);
  }

  void navigateToMyToDoList() {
    _navigationService.navigateTo(RoutePaths.myToDoList);
  }

  @override
  void dispose() {
    // Clean up the subscriptions when the view model is disposed
    _taskSubscription?.cancel();
    _projectSubscription?.cancel();
    super.dispose();
  }
}
