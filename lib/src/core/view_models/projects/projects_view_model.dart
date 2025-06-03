import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/locator.dart';

class ProjectsViewModel extends BaseViewModel {
  void navigateToArchivedProjects() {
    _navigationService.navigateTo(RoutePaths.archivedProjects);
  }
  final NavigationService _navigationService = locator<NavigationService>();
  final ProjectService _projectService = locator<ProjectService>();
  
  List<Project> _projects = [];
  List<Project> _filteredProjects = [];
  
  List<Project> get projects => _filteredProjects;
  
  void initialize() {
    setBusy(true);
    _loadProjects();
  }
  
  void _loadProjects() {
    // Set up a stream subscription to listen for projects
    _projectService.getProjects().listen((projectList) {
      _projects = projectList;
      // Only include non-archived projects by default
      _filteredProjects = _projects.where((p) => p.projectStatus != 'Archived').toList();
      setBusy(false);
      notifyListeners();
    });
  }
  
  void onSearchQueryChanged(String query) {
    if (query.isEmpty) {
      _filteredProjects = _projects.where((p) => p.projectStatus != 'Archived').toList();
    } else {
      _filteredProjects = _projects
          .where((project) =>
              project.projectStatus != 'Archived' &&
              (project.overview.title.toLowerCase().contains(query.toLowerCase()) ||
              (project.applicantLandowner.applicantName != null && 
               project.applicantLandowner.applicantName!.toLowerCase().contains(query.toLowerCase()))))
          .toList();
    }
    notifyListeners();
  }
  
  void navigateToCreateProject() {
    _navigationService.navigateTo(RoutePaths.createProject);
  }
  
  void navigateBack() {
    _navigationService.pop();
  }
  
  void navigateToProjectDetails(Project project) {
    _navigationService.navigateTo(
      RoutePaths.projectDetails,
      arguments: project,
    );
  }
  
  // Static method to access the ViewModel from a BuildContext
  static ProjectsViewModel of(BuildContext context) {
    return getParentViewModel<ProjectsViewModel>(context, listen: false);
  }
}


