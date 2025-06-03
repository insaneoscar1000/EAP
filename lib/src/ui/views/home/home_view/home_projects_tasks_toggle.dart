import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/project.dart';
import 'package:the_eap_app/src/core/view_models/home/home_projects_tasks_toggle_view_model.dart';
import 'package:the_eap_app/src/ui/views/home/schedule_view/my_to_do_list_view.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class HomeProjectsTasksToggle extends StatelessWidget {
  const HomeProjectsTasksToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeProjectsTasksToggleViewModel>.reactive(
      viewModelBuilder: () => HomeProjectsTasksToggleViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton(
                  context,
                  'To do',
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
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: model.navigateToCreateToDo,
                          icon: Icon(IconsaxPlusLinear.add_square,
                              color: Colors.white),
                          label: Text('Add a task'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: model.navigateToSchedule,
                          icon: Icon(IconsaxPlusLinear.task_square,
                              color: Theme.of(context).primaryColor),
                          label: Text('Go to all tasks'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 320, // Adjust as needed
                    child: MyToDoListView(
                      tasks: model.tasks
                          .where((task) =>
                              (task.projectName ?? 'General') == 'General' &&
                              (task.isCompleted == false ||
                                  task.isCompleted == null))
                          .toList(),
                    ),
                  ),
                ],
              )
            else if (model.selectedTab == HomeProjectsTasksTab.projects)
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: model.navigateToCreateProject,
                          icon: Icon(
                            IconsaxPlusLinear.briefcase,
                            color: Colors.white,
                          ),
                          label: Text('Add a project'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/projects');
                          },
                          icon: Icon(IconsaxPlusLinear.briefcase,
                              color: Theme.of(context).primaryColor),
                          label: Text('Go to all projects'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 320, // Adjust as needed
                    child: ProjectsListCompact(),
                  ),
                ],
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
    if (model.projects.isEmpty) {
      return Center(child: Text('No projects found'));
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: model.projects.length,
      itemBuilder: (context, index) {
        final project = model.projects[index];
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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          model.navigateToProjectDetails(project);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
