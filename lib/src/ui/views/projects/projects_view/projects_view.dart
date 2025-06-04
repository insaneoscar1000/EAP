import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/projects/projects_view_model.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class ProjectsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectsViewModel>.reactive(
      viewModelBuilder: () => ProjectsViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          leading: (ModalRoute.of(context)?.settings.arguments is Map &&
                  (ModalRoute.of(context)?.settings.arguments
                          as Map)['fromHome'] ==
                      true)
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          title: Text('My Projects', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.transparent,
        body: BackgroundContainer(
          background: 'background-2',
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: model.navigateToCreateProject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconsaxPlusLinear.add_circle,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'New',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: model.navigateToArchivedProjects,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(IconsaxPlusLinear.archive,
                            color: Theme.of(context).primaryColor),
                        SizedBox(width: 10),
                        Text(
                          'Archived',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SearchInput(
                  hintText: 'Search projects...',
                  onChanged: model.onSearchQueryChanged,
                ),
                SizedBox(height: 16),
                _buildProjectsList(context, model),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context, ProjectsViewModel model) {
    return Expanded(
      child: model.isBusy
          ? Center(child: LoadingIndicator())
          : model.projects.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        IconsaxPlusLinear.document_text,
                        size: 48,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No projects found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: model.projects.length,
                  separatorBuilder: (context, index) => SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final project = model.projects[index];
                    return _buildProjectCard(context, project);
                  },
                ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    // Different colors for different projects (just for visual variety)
    final List<Color> cardColors = [
      Color(0xFFFFF3E0), // Light Orange
      Color(0xFFE3F2FD), // Light Blue
      Color(0xFFE8F5E9), // Light Green
      Color(0xFFF3E5F5), // Light Purple
    ];

    // Use the project id hash to determine the color
    final colorIndex = project.id.hashCode % cardColors.length;

    // Format the date if available
    String dateText = 'No date';
    if (project.createdAt != null) {
      final date = project.createdAt!.toDate();
      dateText = DateFormat('dd MMMM yyyy').format(date);
    }

    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          final model = ProjectsViewModel.of(context);
          model.navigateToProjectDetails(project);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cardColors[colorIndex],
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  project.overview.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  project.applicantLandowner.applicantName ?? 'No applicant',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                if (!project.isComplete)
                  _buildProgressIndicator(context, project),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectStatus(BuildContext context, Project project) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: project.isComplete
            ? Colors.green.withOpacity(0.2)
            : Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: project.isComplete ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            project.isComplete
                ? IconsaxPlusLinear.tick_circle
                : IconsaxPlusLinear.timer,
            size: 14,
            color: project.isComplete ? Colors.green[800] : Colors.orange[800],
          ),
          SizedBox(width: 4),
          Text(
            project.isComplete ? 'Complete' : 'Draft',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
                  project.isComplete ? Colors.green[800] : Colors.orange[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, Project project) {
    final progress = project.currentStep / 9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Text(
              'Step ${project.currentStep} of 9',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
