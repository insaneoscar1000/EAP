import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/core/services/data/project_service.dart';
import 'package:the_eap_app/src/locator.dart';

class ProjectDetailsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _projectService = locator<ProjectService>();

  late Project _project;
  Project get project => _project;

  String? _projectId;
  StreamSubscription<List<Project>>? _projectSubscription;

  void initialize(Project project) {
    _project = project;
    _projectId = project.id;

    // Start listening to project updates
    _setupProjectListener();
  }

  @override
  void dispose() {
    _projectSubscription?.cancel();
    super.dispose();
  }

  void _setupProjectListener() {
    if (_projectId == null) return;

    _projectSubscription?.cancel();
    _projectSubscription = _projectService.getProjects().listen((projects) {
      final updatedProject = projects.firstWhere(
        (p) => p.id == _projectId,
        orElse: () => _project,
      );

      if (updatedProject.id == _projectId) {
        _project = updatedProject;
        notifyListeners();
      }
    });
  }

  String? getFormattedDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('dd MMMM yyyy').format(date);
  }

  String? getTeamMembersText() {
    if (_project.eiaTeamAndStudies?.eiaProjectTeam == null ||
        _project.eiaTeamAndStudies!.eiaProjectTeam!.isEmpty) {
      return null;
    }

    return _project.eiaTeamAndStudies!.eiaProjectTeam!.join('\n');
  }

  Future<void> deleteProject(BuildContext context) async {
    // Show confirmation dialog directly in the view
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Project'),
          content: Text(
              'Are you sure you want to delete this project? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed ?? false) {
      setBusy(true);
      try {
        await _projectService.deleteProject(_project.id!);
        setBusy(false);
        _navigationService.pop();
      } catch (e) {
        setBusy(false);
        _dialogService.showDialog(
          title: 'Error',
          description: 'Failed to delete project: ${e.toString()}',
        );
      }
    }
  }

  void editProject() {
    _navigationService.navigateTo(
      RoutePaths.createProject,
      arguments: _project.id,
    );
  }

  void navigateToIAPs() {
    // Navigate to the I&AP database view with the current project ID
    print(
        'Project details: ID=${_project.id}, Title=${_project.overview.title}');

    if (_project.id != null && _project.id!.isNotEmpty) {
      print('Navigating to IAP database with projectId: ${_project.id}');
      _navigationService.navigateTo(
        RoutePaths.iapDatabase,
        arguments: _project.id,
      );
    } else {
      print('Project ID is null or empty, cannot navigate to IAP database');
      _dialogService.showDialog(
        title: 'Error',
        description:
            'Unable to navigate to I&AP database. Project ID is missing.',
      );
    }
  }

  void exportProject() {
    // Export project functionality (to be implemented)
    _dialogService.showDialog(
      title: 'Coming Soon',
      description: 'The export feature will be available in a future update.',
    );
  }

  String? getSpecialistStudiesRequiredText() {
    if (_project.eiaTeamAndStudies?.specialistStudiesRequired == null ||
        _project.eiaTeamAndStudies!.specialistStudiesRequired!.isEmpty) {
      return null;
    }

    return _project.eiaTeamAndStudies!.specialistStudiesRequired!.join('\n');
  }

  String? getSpecialistStudiesCompletedText() {
    if (_project.eiaTeamAndStudies?.specialistStudiesCompleted == null ||
        _project.eiaTeamAndStudies!.specialistStudiesCompleted!.isEmpty) {
      return null;
    }

    return _project.eiaTeamAndStudies!.specialistStudiesCompleted!.join('\n');
  }

  String? getReviewPeriodText(
      DateTime? startDate, DateTime? endDate, int? duration) {
    if (startDate == null && endDate == null) {
      return null;
    }

    String result = '';

    if (startDate != null) {
      result += 'Start: ${getFormattedDate(startDate)}\n';
    }

    if (endDate != null) {
      result += 'End: ${getFormattedDate(endDate)}\n';
    }

    if (duration != null) {
      result += 'Duration: $duration days';
    }

    return result.isEmpty ? null : result;
  }

  String? getEnvironmentalAffairsContactsText() {
    if (_project.submissionAndContacts?.environmentalAffairsContacts == null ||
        _project.submissionAndContacts!.environmentalAffairsContacts!.isEmpty) {
      return null;
    }

    return _project.submissionAndContacts!.environmentalAffairsContacts!
        .join('\n');
  }
}
