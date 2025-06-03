import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/locator.dart';

class ArchivedProjectsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final ProjectService _projectService = locator<ProjectService>();

  List<Project> _projects = [];
  List<Project> get projects => _projects;

  void initialize() {
    setBusy(true);
    _loadProjects();
  }

  void _loadProjects() {
    _projectService.getProjects().listen((projectList) {
      _projects =
          projectList.where((p) => p.projectStatus == 'Archived').toList();
      setBusy(false);
      notifyListeners();
    });
  }

  void openProjectDetails(Project project) {
    _navigationService.navigateTo(
      RoutePaths.projectDetails,
      arguments: project,
    );
  }
}
