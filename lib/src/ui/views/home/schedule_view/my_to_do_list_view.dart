import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/ui/widgets/widgets.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/home/my_to_do_list_view_model.dart';

class MyToDoListView extends StatelessWidget {
  const MyToDoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyToDoListViewModel>.reactive(
      viewModelBuilder: () => MyToDoListViewModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
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
    return Column(
      children: [
        // Project Type Filter (General or Projects)
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton(
                  context,
                  'General',
                  model.showGeneralOnly,
                  () => model.toggleProjectTypeFilter(true),
                ),
                _buildFilterButton(
                  context,
                  'Projects',
                  !model.showGeneralOnly,
                  () => model.toggleProjectTypeFilter(false),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(height: 10),
        
        // Completion Status Filter (To Do or Complete)
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton(
                  context,
                  'To do',
                  !model.showCompletedOnly,
                  () => model.toggleCompletionStatusFilter(false),
                ),
                _buildFilterButton(
                  context,
                  'Complete',
                  model.showCompletedOnly,
                  () => model.toggleCompletionStatusFilter(true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(
      BuildContext context, String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
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
      onToggleCompletion: (isCompleted) => model.toggleTaskCompletion(task.id, isCompleted),
      showProjectName: true,
    );
  }
  

}
