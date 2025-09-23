import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/models/task.dart';
import 'package:the_eap_app/src/ui/widgets/widgets.dart';

import 'package:the_eap_app/src/core/models/project.dart';
import 'package:the_eap_app/src/core/view_models/projects/project_to_do_list_view_model.dart';

class ProjectToDoListView extends StatelessWidget {
  final Project project;
  const ProjectToDoListView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectToDoListViewModel>.reactive(
      viewModelBuilder: () => ProjectToDoListViewModel(projectId: project.id!),
      onModelReady: (ProjectToDoListViewModel model) => model.initialize(),
      builder: (BuildContext context, ProjectToDoListViewModel model,
              Widget? child) =>
          Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            'To Do List',
            style: const TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              _buildFilterTabs(context, model),
              const SizedBox(height: 10),
              Expanded(
                child: model.filteredTasks.isEmpty
                    ? _buildEmptyState(context)
                    : _buildTaskList(context, model),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => model.navigateToCreateToDo(project),
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFilterTabs(
      BuildContext context, ProjectToDoListViewModel model) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildFilterButton(context, 'To do', !model.showCompletedOnly,
                () => model.toggleCompletionStatusFilter(false)),
            _buildFilterButton(context, 'Completed', model.showCompletedOnly,
                () => model.toggleCompletionStatusFilter(true)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
      BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, ProjectToDoListViewModel model) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: model.filteredTasks.length,
      itemBuilder: (BuildContext context, int index) {
        final Task task = model.filteredTasks[index];
        return TaskItemWidget(
          task: task,
          onTap: () => model.navigateToEditToDo(task),
          onToggleCompletion: (bool isCompleted) =>
              model.toggleTaskCompletion(task.id, isCompleted),
          showProjectName: false,
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add a new task to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
