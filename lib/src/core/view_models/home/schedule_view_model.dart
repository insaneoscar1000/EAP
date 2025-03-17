import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class ScheduleViewModel extends BaseViewModel {
  final TaskService _taskService = locator<TaskService>();
  final UserService _userService = locator<UserService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  String _selectedCategory = 'General';
  String get selectedCategory => _selectedCategory;

  List<Task> _tasks = [];
  List<Task> get tasks => _tasks.where((task) => 
      task.category == _selectedCategory && 
      !task.isCompleted).toList();

  List<Task> get completedTasks => _tasks.where((task) => 
      task.category == _selectedCategory && 
      task.isCompleted).toList();

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    fetchTasks();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> initialize() async {
    setBusy(true);
    await fetchTasks();
    setBusy(false);
  }

  Future<void> fetchTasks() async {
    final firebaseUser = await _authService.getCurrentUser();
    if (firebaseUser != null) {
      final user = await _userService.getUser(firebaseUser.uid);
      if (user != null) {
        _taskService.getTasksForDate(user.id, _selectedDate).listen((taskList) {
          _tasks = taskList;
          notifyListeners();
        });
      }
    }
  }

  Future<void> addTask(String name, String? projectName, String? description) async {
    final firebaseUser = await _authService.getCurrentUser();
    if (firebaseUser != null) {
      final user = await _userService.getUser(firebaseUser.uid);
      if (user != null) {
        try {
          await _taskService.createTask({
            'name': name,
            'projectName': projectName,
            'description': description,
            'date': Timestamp.fromDate(_selectedDate),
            'isCompleted': false,
            'userId': user.id,
            'category': _selectedCategory,
          });
        } catch (e) {
          setError(e.toString());
        }
      }
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    try {
      await _taskService.toggleTaskCompletion(task.id, !task.isCompleted);
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
}
