import 'package:flutter/cupertino.dart';
import 'package:pim_app/tasks/TaskDBWorker.dart';
import 'package:pim_app/tasks/TaskEntryWidget.dart';
import 'package:pim_app/tasks/TaskListWidget.dart';
import 'package:pim_app/tasks/TaskModel.dart';
import 'package:scoped_model/scoped_model.dart';

class TaskWidget extends StatelessWidget {
  TaskWidget() {
    taskModel.loadData("tasks", TaskDBWorker.instance);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TaskModel>(model: taskModel, child: ScopedModelDescendant(builder: (BuildContext context, Widget? child, TaskModel taskModel) {
      return IndexedStack(
          index : taskModel.stackIndex,
          children : [
            TaskListWidget(),
            TaskEntryWidget()
          ] /* End IndexedStack children. */
      );
    },));
  }
}