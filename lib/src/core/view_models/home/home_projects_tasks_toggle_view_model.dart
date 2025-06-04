import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';

enum HomeProjectsTasksTab { tasks, projects }

class HomeProjectsTasksToggleViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final TaskService _taskService = locator<TaskService>();
  final ProjectService _projectService = locator<ProjectService>();
  final UserService _userService = locator<UserService>();
  final AuthService _authService = locator<AuthService>();

  StreamSubscription<List<Task>>? _taskSubscription;
  StreamSubscription<List<Project>>? _projectSubscription;

  HomeProjectsTasksTab selectedTab = HomeProjectsTasksTab.tasks;

  // Tasks
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  // Projects
  List<Project> _projects = [];
  List<Project> get projects => _projects;

  void selectTab(HomeProjectsTasksTab tab) {
    selectedTab = tab;
    notifyListeners();
  }

  Future<void> initialize() async {
    setBusy(true);
    await Future.wait([
      _loadTasks(),
      _loadProjects(),
    ]);
    setBusy(false);
  }

  Future<void> _loadTasks() async {
    // Cancel any existing subscription
    await _taskSubscription?.cancel();
    final firebaseUser = await _authService.getCurrentUser();
    if (firebaseUser != null) {
      final user = await _userService.getUser(firebaseUser.uid);
      if (user != null && user.id != null) {
        _taskSubscription =
            _taskService.getAllTasksForUser(user.id!).listen((tasks) {
          _tasks = tasks;
          notifyListeners();
        });
      }
    }
  }

  Future<void> _loadProjects() async {
    // Cancel any existing subscription
    await _projectSubscription?.cancel();
    _projectSubscription = _projectService.getProjects().listen((projects) {
      _projects = projects;
      notifyListeners();
    });
  }

  void navigateToCreateProject() {
    _navigationService.navigateTo(RoutePaths.createProject);
  }

  void navigateToProjectDetails(Project project) {
    _navigationService.navigateTo(
      RoutePaths.projectDetails,
      arguments: project,
    );
  }

  void navigateToCreateToDo() {
    _navigationService.navigateTo(RoutePaths.createToDo);
  }

  void navigateToTasks() {
    _navigationService.navigateTo(RoutePaths.myToDoList);
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    _projectSubscription?.cancel();
    super.dispose();
  }
}
