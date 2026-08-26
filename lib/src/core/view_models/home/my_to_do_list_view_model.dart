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
  final ProjectService _projectService = locator<ProjectService>();

  List<Task> _allTasks = [];
  List<Task> get allTasks => _allTasks;

  List<Project> _projects = <Project>[];

  // Project names for the "search by project" filter, 'General' always first.
  List<String> get projectNames {
    final List<String> names = <String>['General'];
    names.addAll(_projects
        .where((Project p) =>
            p.projectStatus != 'Archived' && p.overview.title.isNotEmpty)
        .map((Project p) => p.overview.title));
    return names;
  }

  // Selected project filter. Null means show every to-do (General and every
  // project) together, which is the default merged view Sandy asked for.
  String? _selectedProjectName;
  String? get selectedProjectName => _selectedProjectName;

  // Completion status filter (To Do or Complete)
  bool _showCompletedOnly = false;
  bool get showCompletedOnly => _showCompletedOnly;

  // Get filtered tasks based on the selected filters
  List<Task> get filteredTasks {
    // First filter the tasks
    final filtered = _allTasks
        .where((task) =>
            // Only narrow by project when one has been picked
            (_selectedProjectName == null ||
                task.projectName == _selectedProjectName) &&
            // Filter by completion status
            (task.isCompleted == _showCompletedOnly))
        .toList();

    // Then sort based on completion status. Quick to-dos with no date sink
    // to the bottom of the to-do list (there's nothing to sort them by),
    // sorted alphabetically among themselves.
    if (_showCompletedOnly) {
      filtered.sort((a, b) => _compareByDate(a, b, mostRecentFirst: true));
    } else {
      filtered.sort((a, b) => _compareByDate(a, b, mostRecentFirst: false));
    }

    return filtered;
  }

  int _compareByDate(Task a, Task b, {required bool mostRecentFirst}) {
    if (a.date == null && b.date == null) {
      return a.name.compareTo(b.name);
    }
    if (a.date == null) return 1;
    if (b.date == null) return -1;
    return mostRecentFirst ? b.date!.compareTo(a.date!) : a.date!.compareTo(b.date!);
  }

  // Narrow the merged list down to a single project ('General' included),
  // or pass null to show everything again.
  void setSelectedProject(String? projectName) {
    _selectedProjectName = projectName;
    notifyListeners();
  }

  // Toggle between To Do and Complete filter
  void toggleCompletionStatusFilter(bool showCompletedOnly) {
    _showCompletedOnly = showCompletedOnly;
    notifyListeners();
  }

  Future<void> initialize() async {
    await fetchAllTasks();
    await fetchProjects();
  }

  // Store the current stream subscriptions to cancel them when needed
  StreamSubscription? _taskSubscription;
  StreamSubscription? _projectSubscription;

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

  Future<void> fetchProjects() async {
    try {
      await _projectSubscription?.cancel();
      _projectSubscription =
          _projectService.getProjects().listen((List<Project> projectList) {
        _projects = projectList
            .where((Project p) => p.projectStatus != 'Archived')
            .toList();
        notifyListeners();
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

  void navigateBack() {
    _navigationService.pop();
  }

  void navigateToCreateToDo() {
    _navigationService.navigateTo(RoutePaths.createToDo);
  }

  void navigateToEditToDo(Task task) {
    _navigationService.navigateTo(RoutePaths.editToDo, arguments: task);
  }

  void navigateToSchedule() {
    _navigationService.navigateTo(RoutePaths.schedule);
  }

  @override
  void dispose() {
    // Clean up the subscriptions when the view model is disposed
    _taskSubscription?.cancel();
    _projectSubscription?.cancel();
    super.dispose();
  }
}
