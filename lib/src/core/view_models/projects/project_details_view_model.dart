import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
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

  Future<void> exportProject() async {
    try {
      final buffer = StringBuffer();
      buffer.writeln('Project Details Export');
      buffer.writeln('======================');
      buffer.writeln('Project Overview:');
      buffer.writeln('  Title: ${_project.overview.title}');
      buffer.writeln('  Code: ${_project.overview.code}');
      buffer.writeln(
          '  Department Reference: ${_project.overview.departmentReferenceNumber}');
      buffer.writeln(
          '  Property: ${_project.overview.propertyNameAddressFarmNo}');
      buffer.writeln('');
      buffer.writeln('Location:');
      buffer.writeln('  Province: ${_project.location.province ?? ''}');
      buffer.writeln(
          '  District/Metro Municipality: ${_project.location.districtOrMetroMunicipality ?? ''}');
      buffer.writeln(
          '  Local Municipality: ${_project.location.localMunicipality ?? ''}');
      buffer.writeln('');
      buffer.writeln('Applicant:');
      buffer.writeln(
          '  Name: ${_project.applicantLandowner.applicantName ?? ''}');
      buffer.writeln(
          '  Details: ${_project.applicantLandowner.applicantDetails ?? ''}');
      buffer.writeln('Landowner:');
      buffer.writeln('  Name: ${_project.applicantLandowner.landowner ?? ''}');
      buffer.writeln(
          '  Details: ${_project.applicantLandowner.landownerDetails ?? ''}');
      buffer.writeln('');
      buffer.writeln('Project Description:');
      buffer.writeln(
          '  Application Type: ${_project.projectDescription?.applicationType ?? ''}');
      buffer.writeln(
          '  Description: ${_project.projectDescription?.projectDescription ?? ''}');
      buffer.writeln('');
      buffer.writeln('Environmental Details:');
      buffer.writeln(
          '  Relevant Listing Notice: ${_project.environmentalDetails?.relevantListingNotice ?? ''}');
      buffer.writeln(
          '  Current Property Zoning: ${_project.environmentalDetails?.currentPropertyZoning ?? ''}');
      buffer.writeln(
          '  Property Size: ${_project.environmentalDetails?.propertySize ?? ''}');
      buffer.writeln(
          '  Existing Services On Site: ${_project.environmentalDetails?.existingServicesOnSite ?? ''}');
      buffer.writeln(
          '  Planned Services (Water): ${_project.environmentalDetails?.plannedServicesWater ?? ''}');
      buffer.writeln(
          '  Planned Services (Electricity): ${_project.environmentalDetails?.plannedServicesElectricity ?? ''}');
      buffer.writeln(
          '  Planned Services (Sanitation): ${_project.environmentalDetails?.plannedServicesSanitation ?? ''}');
      buffer.writeln('');
      buffer.writeln('EIA Team & Studies:');
      buffer.writeln(
          '  EIA Project Team: ${_project.eiaTeamAndStudies?.eiaProjectTeam?.join(', ') ?? ''}');
      buffer.writeln(
          '  Specialist Studies Required: ${_project.eiaTeamAndStudies?.specialistStudiesRequired?.join(', ') ?? ''}');
      buffer.writeln(
          '  Specialist Studies Completed: ${_project.eiaTeamAndStudies?.specialistStudiesCompleted?.join(', ') ?? ''}');
      buffer.writeln('');
      buffer.writeln('Public Review Periods:');
      buffer.writeln(
          '  First Review Period: ${getReviewPeriodText(_project.publicReviewPeriods?.publicReviewPeriod1StartDate, _project.publicReviewPeriods?.publicReviewPeriod1EndDate, _project.publicReviewPeriods?.publicReviewPeriod1Duration) ?? ''}');
      buffer.writeln(
          '  Second Review Period: ${getReviewPeriodText(_project.publicReviewPeriods?.publicReviewPeriod2StartDate, _project.publicReviewPeriods?.publicReviewPeriod2EndDate, _project.publicReviewPeriods?.publicReviewPeriod2Duration) ?? ''}');
      buffer.writeln('');
      buffer.writeln('Submission & Contacts:');
      buffer.writeln(
          '  Relevant Environmental Affairs Office: ${_project.submissionAndContacts?.relevantEnvironmentalAffairsOffice ?? ''}');
      buffer.writeln(
          '  Environmental Affairs Contacts: ${_project.submissionAndContacts?.environmentalAffairsContacts?.join(', ') ?? ''}');
      buffer.writeln(
          '  Pre-application Meeting Date: ${_project.submissionAndContacts?.dateOfPreapplicationMeeting?.toString() ?? ''}');
      buffer.writeln(
          '  Submission of Application Date: ${_project.submissionAndContacts?.dateOfSubmissionOfApplication?.toString() ?? ''}');
      buffer.writeln(
          '  Submission of Draft Documents Date: ${_project.submissionAndContacts?.dateOfSubmissionOfDraftDocuments?.toString() ?? ''}');
      buffer.writeln(
          '  Submission of Final Documents Date: ${_project.submissionAndContacts?.dateOfSubmissionOfFinalDocuments?.toString() ?? ''}');
      buffer.writeln('');
      buffer.writeln('Notes:');
      buffer.writeln('  ${_project.projectNotes?.notes ?? ''}');
      buffer.writeln('');
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/project_export.txt');
      await file.writeAsString(buffer.toString());
      await Share.shareXFiles([XFile(file.path)],
          text: 'Project Details Export');
    } catch (e) {
      _dialogService.showDialog(
        title: 'Export Failed',
        description:
            'An error occurred while exporting the project: ${e.toString()}',
      );
    }
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

  Future<void> archiveProject(BuildContext context) async {
    setBusy(true);
    try {
      // Update project status to 'Archived'
      final updatedProject = _project.copyWith(projectStatus: 'Archived');
      await _projectService.updateProject(updatedProject);
      _project = updatedProject;
      setBusy(false);
      _dialogService.showDialog(
        title: 'Project Archived',
        description:
            'The project has been archived successfully. You can find it in the Archived Projects section.',
      );
      notifyListeners();
    } catch (e) {
      setBusy(false);
      _dialogService.showDialog(
        title: 'Archive Failed',
        description: 'Failed to archive project: ${e.toString()}',
      );
    }
  }

  Future<void> unarchiveProject(BuildContext context) async {
    setBusy(true);
    try {
      // Update project status to 'Complete'
      final updatedProject = _project.copyWith(projectStatus: 'Complete');
      await _projectService.updateProject(updatedProject);
      _project = updatedProject;
      setBusy(false);
      _dialogService.showDialog(
        title: 'Project Restored',
        description: 'The project has been moved back to the Completed state.',
      );
      notifyListeners();
    } catch (e) {
      setBusy(false);
      _dialogService.showDialog(
        title: 'Unarchive Failed',
        description: 'Failed to unarchive project: ${e.toString()}',
      );
    }
  }
}
