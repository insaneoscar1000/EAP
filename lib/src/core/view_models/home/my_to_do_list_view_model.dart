import 'dart:async';

import 'package:stacked/stacked.dart';

import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class MyToDoListViewModel extends BaseViewModel {
  final TaskService _taskService = locator<TaskService>();
  final UserService _userService = locator<UserService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();

  List<Task> _allTasks = [];
  List<Task> get allTasks => _allTasks;

  // Project type filter (General or Projects)
  bool _showGeneralOnly = true;
  bool get showGeneralOnly => _showGeneralOnly;

  // Completion status filter (To Do or Complete)
  bool _showCompletedOnly = false;
  bool get showCompletedOnly => _showCompletedOnly;

  // Get filtered tasks based on the selected filters
  List<Task> get filteredTasks {
    // First filter the tasks
    final filtered = _allTasks
        .where((task) =>
            // Filter by project type (General or Projects)
            (_showGeneralOnly
                ? task.projectName == 'General'
                : task.projectName != 'General') &&
            // Filter by completion status
            (task.isCompleted == _showCompletedOnly))
        .toList();

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

  Future<void> initialize() async {
    await fetchAllTasks();
  }

  // Store the current stream subscription to cancel it when needed
  StreamSubscription? _taskSubscription;

  Future<void> fetchAllTasks() async {
    setBusy(true);

    final firebaseUser = await _authService.getCurrentUser();
    if (firebaseUser != null) {
      final user = await _userService.getUser(firebaseUser.uid);
      if (user != null && user.id != null) {
        try {
          // Cancel any existing subscription
          _taskSubscription?.cancel();

          // Set up a stream to listen for task changes
          _taskSubscription =
              _taskService.getAllTasksForUser(user.id!).listen((tasks) {
            _allTasks = tasks;
            notifyListeners();
            setBusy(false);
          });
        } catch (e) {
          setError(e.toString());
          setBusy(false);
        }
      } else {
        setBusy(false);
      }
    } else {
      setBusy(false);
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _taskService.toggleTaskCompletion(taskId, isCompleted);
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

  @override
  void dispose() {
    // Clean up the subscription when the view model is disposed
    _taskSubscription?.cancel();
    super.dispose();
  }
}
