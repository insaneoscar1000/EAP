import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/ui/widgets/widgets.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/home/my_to_do_list_view_model.dart';

class MyToDoListView extends StatelessWidget {
  final List<Task>? tasks;
  const MyToDoListView({Key? key, this.tasks}) : super(key: key);

  // Helper method to navigate to edit task screen
  void _navigateToEditToDo(BuildContext context, Task task) {
    // Get the MyToDoListViewModel from the nearest provider
    final model = MyToDoListViewModel();
    model.navigateToEditToDo(task);
  }

  // Helper method to toggle task completion
  void _toggleTaskCompletion(
      BuildContext context, String taskId, bool isCompleted) {
    // Get the MyToDoListViewModel from the nearest provider
    final model = MyToDoListViewModel();
    model.toggleTaskCompletion(taskId, isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    if (tasks != null) {
      // Render a simple list of provided tasks (no filters, no FAB, no appbar)
      if (tasks!.isEmpty) {
        return Center(child: Text('No tasks found'));
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: tasks!.length,
        itemBuilder: (context, index) {
          final task = tasks![index];
          return TaskItemWidget(
            task: task,
            onTap: () => _navigateToEditToDo(context, task),
            onToggleCompletion: (isCompleted) =>
                _toggleTaskCompletion(context, task.id, isCompleted),
            showProjectName: false,
          );
        },
      );
    }
    // Default: full-featured To Do List
    return ViewModelBuilder<MyToDoListViewModel>.reactive(
      viewModelBuilder: () => MyToDoListViewModel(),
      onViewModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'My To Do List',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => model.navigateBack(),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background-2.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: model.isBusy
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFilterTabs(context, model),
                          SizedBox(height: 16),
                          Expanded(
                            child: model.filteredTasks.isEmpty
                                ? _buildEmptyState(context)
                                : _buildTaskList(context, model),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => model.navigateToCreateToDo(),
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildFilterTabs(BuildContext context, MyToDoListViewModel model) {
    return Row(
      children: [
        // Completed / To do toggle pill
        InkWell(
          onTap: () =>
              model.toggleCompletionStatusFilter(!model.showCompletedOnly),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: model.showCompletedOnly
                  ? Theme.of(context).primaryColor
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Completed',
              style: TextStyle(
                color: model.showCompletedOnly
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        // Search/filter by project
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                isExpanded: true,
                value: model.selectedProjectName,
                icon: Icon(Icons.search, size: 18, color: Colors.grey),
                hint: Text('Search by project',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                style: TextStyle(fontSize: 13, color: Colors.black87),
                items: <DropdownMenuItem<String?>>[
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All to-dos'),
                  ),
                  ...model.projectNames.map(
                    (String name) => DropdownMenuItem<String?>(
                      value: name,
                      child: Text(name),
                    ),
                  ),
                ],
                onChanged: model.setSelectedProject,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        // Jump to the calendar view
        InkWell(
          onTap: () => model.navigateToSchedule(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today,
                    size: 16, color: Theme.of(context).primaryColor),
                SizedBox(width: 6),
                Text(
                  'Open Schedule',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            'No tasks found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add a new task to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, MyToDoListViewModel model) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: model.filteredTasks.length,
      itemBuilder: (context, index) {
        final task = model.filteredTasks[index];
        return _buildTaskItem(context, model, task);
      },
    );
  }

  Widget _buildTaskItem(
      BuildContext context, MyToDoListViewModel model, Task task) {
    return TaskItemWidget(
      task: task,
      onTap: () => model.navigateToEditToDo(task),
      onToggleCompletion: (isCompleted) =>
          model.toggleTaskCompletion(task.id, isCompleted),
      showProjectName: true,
    );
  }
}
