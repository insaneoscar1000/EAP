import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/task.dart';
import 'package:the_eap_app/src/core/services/data/task_service.dart';
import 'package:the_eap_app/src/core/services/data/auth_service.dart';
import 'package:the_eap_app/src/core/services/app/navigation_service.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/locator.dart';

class ProjectToDoListViewModel extends BaseViewModel {
  final String projectId;
  final TaskService _taskService = locator<TaskService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<Task> _allTasks = [];
  List<Task> get allTasks => _allTasks;

  List<Task> _filteredTasks = [];
  List<Task> get filteredTasks => _filteredTasks;

  bool _showCompletedOnly = false;
  bool get showCompletedOnly => _showCompletedOnly;

  StreamSubscription<List<Task>>? _taskSubscription;

  ProjectToDoListViewModel({required this.projectId});

  Future<void> initialize() async {
    setBusy(true);
    _taskSubscription?.cancel();
    final authService = locator<AuthService>();
    final user = await authService.getCurrentUser();
    final userId = user?.uid;
    if (userId == null) {
      _allTasks = [];
      _applyFilters();
      setBusy(false);
      return;
    }
    _taskSubscription = _taskService
        .getTasksForProject(projectId, userId)
        .listen((tasks) {
      _allTasks = tasks;
      _applyFilters();
      setBusy(false);
    });
  }

  void _applyFilters() {
    if (_showCompletedOnly) {
      _filteredTasks = _allTasks.where((task) => task.isCompleted).toList();
    } else {
      _filteredTasks = _allTasks.where((task) => !task.isCompleted).toList();
    }
    notifyListeners();
  }

  void toggleCompletionStatusFilter(bool showCompletedOnly) {
    _showCompletedOnly = showCompletedOnly;
    _applyFilters();
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    await _taskService.toggleTaskCompletion(taskId, isCompleted);
  }

  void navigateToCreateToDo(project) {
    _navigationService.navigateTo(RoutePaths.createToDo, arguments: {'project': project});
  }

  void navigateToEditToDo(Task task) {
    _navigationService.navigateTo(RoutePaths.editToDo, arguments: task);
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }
}
