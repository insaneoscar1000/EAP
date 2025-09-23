import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/core/view_models/projects/project_details_view_model.dart';
import 'package:the_eap_app/src/ui/views/projects/project_to_do_list_view.dart';

class ProjectDetailsView extends StatelessWidget {
  final Project project;

  const ProjectDetailsView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectDetailsViewModel>.reactive(
      viewModelBuilder: () => ProjectDetailsViewModel(),
      onModelReady: (ProjectDetailsViewModel model) =>
          model.initialize(project),
      builder: (BuildContext context, ProjectDetailsViewModel model,
              Widget? child) =>
          Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            'Project Details',
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.chevron_left,
                size: 34, color: Theme.of(context).primaryColorLight),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.download,
                  color: Theme.of(context).primaryColorLight),
              onPressed: () => model.exportProject(),
              tooltip: 'Export Project',
            ),
            IconButton(
              icon: Icon(
                IconsaxPlusLinear.edit,
                color: Theme.of(context).primaryColorLight,
              ),
              onPressed: () => model.editProject(),
              tooltip: 'Edit Project',
            ),
          ],
        ),
        body: BackgroundContainer(
          background: 'background-2',
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHeader(context, model),
                  const SizedBox(height: 16),
                  _buildIAPsButton(context, model),
                  const SizedBox(height: 16),
                  _buildDetailsSection(context, model),
                  const SizedBox(height: 24),
                  _buildBottomButtons(context, model),
                  const SizedBox(height: 16), // Extra padding at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ProjectDetailsViewModel model) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        project.overview.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Code: ${project.overview.code}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(
      BuildContext context, ProjectDetailsViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDetailItem(context, 'Project Code', project.overview.code),
          _buildDetailItem(context, 'Department Reference',
              project.overview.departmentReferenceNumber),
          _buildDetailItem(context, 'Address/Farm Number',
              project.overview.propertyNameAddressFarmNo),

          // Location Section
          _buildDetailItem(context, 'Province',
              project.location.province ?? 'Not specified'),
          _buildDetailItem(context, 'District/Metro Municipality',
              project.location.districtOrMetroMunicipality ?? 'Not specified'),
          _buildDetailItem(context, 'Local Municipality',
              project.location.localMunicipality ?? 'Not specified'),
          _buildDetailItem(context, 'Project Location',
              project.location.projectLocation ?? 'Not specified'),

          // Applicant and Landowner Section
          _buildDetailItem(context, 'Applicant',
              project.applicantLandowner.applicantName ?? 'Not specified'),
          _buildDetailItem(context, 'Applicant Details',
              project.applicantLandowner.applicantDetails ?? 'Not specified',
              multiline: true),
          _buildDetailItem(context, 'Land Owner',
              project.applicantLandowner.landowner ?? 'Not specified'),
          _buildDetailItem(context, 'Landowner Details',
              project.applicantLandowner.landownerDetails ?? 'Not specified',
              multiline: true),

          // Project Description Section
          _buildDetailItem(context, 'Application Type',
              project.projectDescription?.applicationType ?? 'Not specified'),
          _buildDetailItem(context, 'Description',
              project.projectDescription?.projectDescription ?? 'Not specified',
              multiline: true),

          // Environmental Details Section
          _buildDetailItem(
              context,
              'Relevant Listing Notice',
              project.environmentalDetails?.relevantListingNotice ??
                  'Not specified'),
          _buildDetailItem(
              context,
              'Current Property Zoning',
              project.environmentalDetails?.currentPropertyZoning ??
                  'Not specified'),
          _buildDetailItem(context, 'Property Size',
              project.environmentalDetails?.propertySize ?? 'Not specified'),
          _buildDetailItem(
              context,
              'Existing Services On Site',
              project.environmentalDetails?.existingServicesOnSite ??
                  'Not specified',
              multiline: true),
          _buildDetailItem(
              context,
              'Planned Services - Water',
              project.environmentalDetails?.plannedServicesWater ??
                  'Not specified',
              multiline: true),
          _buildDetailItem(
              context,
              'Planned Services - Electricity',
              project.environmentalDetails?.plannedServicesElectricity ??
                  'Not specified',
              multiline: true),
          _buildDetailItem(
              context,
              'Planned Services - Sanitation',
              project.environmentalDetails?.plannedServicesSanitation ??
                  'Not specified',
              multiline: true),

          // EIA Team and Studies Section
          _buildDetailItem(context, 'Project Team',
              model.getTeamMembersText() ?? 'Not specified',
              multiline: true),
          _buildDetailItem(context, 'Specialist Studies Required',
              model.getSpecialistStudiesRequiredText() ?? 'Not specified',
              multiline: true),
          _buildDetailItem(context, 'Specialist Studies Completed',
              model.getSpecialistStudiesCompletedText() ?? 'Not specified',
              multiline: true),

          // Public Review Periods Section
          _buildDetailItem(
              context,
              'First Review Period',
              model.getReviewPeriodText(
                      project.publicReviewPeriods?.publicReviewPeriod1StartDate,
                      project.publicReviewPeriods?.publicReviewPeriod1EndDate,
                      project
                          .publicReviewPeriods?.publicReviewPeriod1Duration) ??
                  'Not specified'),
          _buildDetailItem(
              context,
              'Second Review Period',
              model.getReviewPeriodText(
                      project.publicReviewPeriods?.publicReviewPeriod2StartDate,
                      project.publicReviewPeriods?.publicReviewPeriod2EndDate,
                      project
                          .publicReviewPeriods?.publicReviewPeriod2Duration) ??
                  'Not specified'),

          // Submission and Contacts Section
          _buildDetailItem(
              context,
              'Environmental Affairs Office',
              project.submissionAndContacts
                      ?.relevantEnvironmentalAffairsOffice ??
                  'Not specified'),
          _buildDetailItem(context, 'Environmental Affairs Contacts',
              model.getEnvironmentalAffairsContactsText() ?? 'Not specified',
              multiline: true),
          _buildDetailItem(
              context,
              'Pre-application Meeting Date',
              model.getFormattedDate(project
                      .submissionAndContacts?.dateOfPreapplicationMeeting) ??
                  'Not specified'),
          _buildDetailItem(
              context,
              'Application Submission Date',
              model.getFormattedDate(project
                      .submissionAndContacts?.dateOfSubmissionOfApplication) ??
                  'Not specified'),
          _buildDetailItem(
              context,
              'Submission of Draft Documents Submission Date',
              model.getFormattedDate(project.submissionAndContacts
                      ?.dateOfSubmissionOfDraftDocuments) ??
                  'Not specified'),
          _buildDetailItem(
              context,
              'Submission of Final Documents Submission Date',
              model.getFormattedDate(project.submissionAndContacts
                      ?.dateOfSubmissionOfFinalDocuments) ??
                  'Not specified'),

          // Notes Section
          _buildDetailItem(
              context, 'Notes', project.projectNotes?.notes ?? 'No notes added',
              multiline: true),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Divider(color: Colors.grey[300], thickness: 1),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value,
      {bool multiline = false, String? subtitle}) {
    final bool isEmptyOrDefault = value.trim().isEmpty ||
        value == 'Not specified' ||
        value == 'No notes added';
    if (isEmptyOrDefault) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 4),
              if (subtitle != null)
                Expanded(
                  child: Text(
                    '($subtitle)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: multiline
                ? Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildIAPsButton(BuildContext context, ProjectDetailsViewModel model) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => model.navigateToIAPs(),
            icon: Icon(Icons.people, color: Colors.white),
            label: Text('I&APs'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ProjectToDoListView(project: model.project),
                ),
              );
            },
            icon: Icon(Icons.list_alt, color: Colors.white),
            label: Text('To Do List'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(
      BuildContext context, ProjectDetailsViewModel model) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => model.deleteProject(context),
                  icon: const Icon(IconsaxPlusLinear.trash,
                      color: Colors.white, size: 20),
                  label: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: model.project.projectStatus == 'Archived'
                    ? ElevatedButton.icon(
                        onPressed: () async {
                          final bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Unarchive Project'),
                              content: const Text(
                                  'Do you want to unarchive this project? It will be restored to the Completed state.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Unarchive'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            model.unarchiveProject(context);
                          }
                        },
                        icon: const Icon(IconsaxPlusLinear.refresh,
                            color: Colors.black, size: 20),
                        label: const Text(
                          'Unarchive',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[100],
                          foregroundColor: Colors.green[800],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.green),
                          ),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: () async {
                          final bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('Archive Project'),
                              content: const Text(
                                  'Are you sure you want to archive this project? You can restore it later from the Archived Projects section.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Archive'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            model.archiveProject(context);
                          }
                        },
                        icon: const Icon(IconsaxPlusLinear.archive,
                            color: Colors.black, size: 20),
                        label: const Text(
                          'Archive',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
