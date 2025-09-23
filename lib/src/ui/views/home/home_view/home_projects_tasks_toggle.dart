import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/project.dart';
import 'package:the_eap_app/src/core/models/task.dart';
import 'package:the_eap_app/src/core/view_models/home/home_projects_tasks_toggle_view_model.dart';
import 'package:the_eap_app/src/ui/views/home/schedule_view/my_to_do_list_view.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class HomeProjectsTasksToggle extends StatelessWidget {
  const HomeProjectsTasksToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeProjectsTasksToggleViewModel>.reactive(
      viewModelBuilder: () => HomeProjectsTasksToggleViewModel(),
      onModelReady: (HomeProjectsTasksToggleViewModel model) =>
          model.initialize(),
      builder: (BuildContext context, HomeProjectsTasksToggleViewModel model,
          Widget? child) {
        return Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildToggleButton(
                  context,
                  'To do list',
                  model.selectedTab == HomeProjectsTasksTab.tasks,
                  () => model.selectTab(HomeProjectsTasksTab.tasks),
                ),
                SizedBox(width: 10),
                _buildToggleButton(
                  context,
                  'Projects',
                  model.selectedTab == HomeProjectsTasksTab.projects,
                  () => model.selectTab(HomeProjectsTasksTab.projects),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (model.selectedTab == HomeProjectsTasksTab.tasks)
              Flexible(
                child: MyToDoListView(
                  tasks: model.tasks
                      .where((Task task) =>
                          (task.projectName ?? 'General') == 'General' &&
                          (task.isCompleted == false))
                      .toList(),
                ),
              )
            else if (model.selectedTab == HomeProjectsTasksTab.projects)
              Flexible(
                child: ProjectsListCompact(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildToggleButton(
      BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectsListCompact
    extends ViewModelWidget<HomeProjectsTasksToggleViewModel> {
  @override
  Widget build(BuildContext context, HomeProjectsTasksToggleViewModel model) {
    if (model.isBusy) {
      return Center(child: CircularProgressIndicator());
    }
    final List<Project> visibleProjects = model.projects
        .where((Project p) => p.projectStatus != 'Archived')
        .toList();
    if (visibleProjects.isEmpty) {
      return Center(child: Text('No projects found'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: visibleProjects.length,
      itemBuilder: (BuildContext context, int index) {
        final Project project = visibleProjects[index];
        return _ProjectCardCompact(project: project, model: model);
      },
    );
  }
}

class _ProjectCardCompact extends StatelessWidget {
  final Project project;
  final HomeProjectsTasksToggleViewModel model;
  const _ProjectCardCompact({required this.project, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () {
          model.navigateToProjectDetails(project);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
