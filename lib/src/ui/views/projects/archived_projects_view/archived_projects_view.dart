import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';
import 'package:the_eap_app/src/core/view_models/projects/archived_projects_view_model.dart';

class ArchivedProjectsView extends StatelessWidget {
  const ArchivedProjectsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ArchivedProjectsViewModel>.reactive(
      viewModelBuilder: () => ArchivedProjectsViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            'Archived Projects',
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
        ),
        body: BackgroundContainer(
          background: 'background-2',
          child: SafeArea(
            child: model.isBusy
                ? const Center(child: CircularProgressIndicator())
                : model.projects.isEmpty
                    ? const Center(child: Text('No archived projects'))
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: model.projects.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final project = model.projects[index];
                          return _buildProjectCard(context, project, model);

                        },
                      ),
          ),
        ),
      ),
    );
  }
}

Widget _buildProjectCard(BuildContext context, project, ArchivedProjectsViewModel model) {
  final List<Color> cardColors = [
    Color(0xFFFFF3E0), // Light Orange
    Color(0xFFE3F2FD), // Light Blue
    Color(0xFFE8F5E9), // Light Green
    Color(0xFFF3E5F5), // Light Purple
  ];
  final colorIndex = project.id.hashCode % cardColors.length;
  String dateText = 'No date';
  if (project.createdAt != null) {
    final date = project.createdAt!.toDate();
    dateText = '${date.day}/${date.month}/${date.year}';
  }
  return GestureDetector(
    onTap: () => model.openProjectDetails(project),
    child: Card(
      elevation: 2,
      color: cardColors[colorIndex],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.overview.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  dateText,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              project.applicantLandowner.applicantName ?? 'No applicant',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12),
            // Optionally show status or other archived info here
          ],
        ),
      ),
    ),
  );
}
