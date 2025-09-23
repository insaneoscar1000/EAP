import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:the_eap_app/src/ui/widgets/widgets.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class ScheduleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScheduleViewModel>.reactive(
      viewModelBuilder: () => ScheduleViewModel(),
      onModelReady: (model) => model.fetchTasks(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
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
            title: Text('Schedule', style: TextStyle(color: Colors.white)),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => model.navigateToCreateToDo(),
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.add, color: Colors.white),
          ),
          body: BackgroundContainer(
            background: 'background-2',
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: model.isBusy
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCalendar(context, model),
                            SizedBox(height: 12),
                            _buildMyToDoListButton(context, model),
                            SizedBox(height: 12),
                            _buildCategorySelector(context, model),

                            SizedBox(height: 8),
                            // Task list
                            model.allTasksForSelectedDate
                                    .where(
                                        (task) => !(task.isCompleted ?? false))
                                    .isEmpty
                                ? Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    child: Center(
                                      child: Text(
                                        'No tasks for this day',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.allTasksForSelectedDate
                                        .where((task) =>
                                            !(task.isCompleted ?? false))
                                        .length,
                                    itemBuilder: (context, index) {
                                      final tasks = model
                                          .allTasksForSelectedDate
                                          .where((task) =>
                                              !(task.isCompleted ?? false))
                                          .toList();
                                      final task = tasks[index];
                                      return _buildTaskItem(
                                          context, model, task);
                                    },
                                  ),
                            // Add some bottom padding for better scrolling experience
                            SizedBox(height: 80),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendar(BuildContext context, ScheduleViewModel model) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: model.selectedDate,
          calendarFormat: model.calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(model.selectedDate, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            model.setSelectedDate(selectedDay);
          },
          onFormatChanged: (format) {
            model.setCalendarFormat(format);
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            formatButtonShowsNext: false,
            titleCentered: true,
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
            formatButtonDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            formatButtonTextStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: true,
            outsideTextStyle: TextStyle(color: Colors.grey),
            markersMaxCount: 3,
            cellMargin: EdgeInsets.all(4),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context, ScheduleViewModel model) {
    return Column(
      children: [
        // Removed Project Type Filter (General or Projects)
      ],
    );
  }

  Widget _buildTaskItem(
      BuildContext context, ScheduleViewModel model, Task task) {
    return TaskItemWidget(
      task: task,
      onTap: () => model.navigateToEditToDo(task),
      onToggleCompletion: (isCompleted) =>
          model.toggleTaskCompletion(task.id, isCompleted),
      showProjectName: false,
    );
  }

  Widget _buildMyToDoListButton(BuildContext context, ScheduleViewModel model) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => model.navigateToMyToDoList(),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.list_alt,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'My To Do List',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
