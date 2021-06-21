import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pim_app/tasks/TaskDBWorker.dart';
import 'package:pim_app/tasks/TaskModel.dart';
import 'package:scoped_model/scoped_model.dart';

class TaskListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("## taskList.build()");

    return ScopedModel<TaskModel>(
        model: taskModel,
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget? child, TaskModel model) {
            return Scaffold(floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                taskModel.entityBeingEdited = new Task();
                taskModel.setStackIndex(1);
                taskModel.setChosenDate("");
              },
            ), body: ListView.builder(
              itemCount: taskModel.entityList.length,
              itemBuilder: (BuildContext context, int index) {
                Task task = taskModel.entityList[index];
                String? dueDate;
                if (task.dueDate.isNotEmpty) {
                  List datePart = task.dueDate.split(",");
                  DateTime dateTime = DateTime(int.parse(datePart[0]), int.parse(datePart[1]), int.parse(datePart[2]));
                  dueDate = DateFormat.yMMMMd("en_US").format(dateTime.toLocal());
                }
                return Slidable(
                  child: ListTile(
                    leading: Checkbox(
                        value: task.complete,
                        onChanged: (inValue) async {
                          // Update the completed value for this task and refresh the list.
                          task.complete = inValue!;
                          await TaskDBWorker.instance.update(task);
                          taskModel.loadData("tasks", TaskDBWorker.instance);
                        }),
                    title: Text("${task.description}",
                        // Dim and strikethrough the text when the task is completed.
                        style:
                            task.complete ? TextStyle(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough) : TextStyle(color: Theme.of(context).textTheme.headline1!.color)),
                    subtitle: task.dueDate.isEmpty
                        ? null
                        : Text(dueDate!,
                            // Dim and strikethrough the text when the task is completed.
                            style: task.complete
                                ? TextStyle(color: Theme.of(context).disabledColor, decoration: TextDecoration.lineThrough)
                                : TextStyle(color: Theme.of(context).textTheme.headline1!.color)),
                    onTap: () async {
                      if (task.complete) {
                        return;
                      }
                      taskModel.entityBeingEdited = await TaskDBWorker.instance.get(task.id);
                      taskModel.setChosenDate(dueDate!);
                      taskModel.setStackIndex(1);
                    },
                  ),
                  secondaryActions: [  IconSlideAction(
                      caption : "Delete",
                      color : Colors.red,
                      icon : Icons.delete,
                      onTap : () => _deleteTask(context, task)
                  )],
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: .25,
                );
              },
            ));
          },
        ));
  }
}

Future _deleteTask(BuildContext inContext, Task inTask) async {
  print("## TasksList._deleteTask(): inTask = $inTask");
  return showDialog(
      context : inContext,
      barrierDismissible : false,
      builder : (BuildContext inAlertContext) {
        return AlertDialog(
            title : Text("Delete Task"),
            content : Text("Are you sure you want to delete ${inTask.description}?"),
            actions : [
              TextButton(child : Text("Cancel"),
                  onPressed: () {
                    // Just hide dialog.
                    Navigator.of(inAlertContext).pop();
                  }
              ),
              TextButton(child : Text("Delete"),
                  onPressed : () async {
                    // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                    await TaskDBWorker.instance.delete(inTask.id);
                    Navigator.of(inAlertContext).pop();
                    ScaffoldMessenger.of(inContext).showSnackBar(
                        SnackBar(
                            backgroundColor : Colors.red,
                            duration : Duration(seconds : 2),
                            content : Text("Task deleted")
                        )
                    );
                    // Reload data from database to update list.
                    taskModel.loadData("tasks", TaskDBWorker.instance);
                  }
              )
            ]
        );
      }
  );
}

