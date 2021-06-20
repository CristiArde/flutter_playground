import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pim_app/tasks/TaskModel.dart';
import 'package:scoped_model/scoped_model.dart';
import '../utils.dart' as utils;


import 'TaskDBWorker.dart';

class TaskEntryWidget extends StatelessWidget {
  final TextEditingController _descriptionEditor = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TaskEntryWidget() {
    _descriptionEditor.addListener(() {
      taskModel.entityBeingEdited.description = _descriptionEditor.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Set value of controllers.
    if (taskModel.entityBeingEdited != null) {
      _descriptionEditor.text = taskModel.entityBeingEdited.description;
    }

    // Return widget.
    return ScopedModel(
        model : taskModel,
        child : ScopedModelDescendant<TaskModel>(
            builder : (BuildContext inContext, Widget? inChild, TaskModel inModel) {
              return Scaffold(
                  bottomNavigationBar : Padding(
                      padding : EdgeInsets.symmetric(vertical : 0, horizontal : 10),
                      child : Row(
                          children : [
                            TextButton(child : Text("Cancel"),
                                onPressed : () {
                                  // Hide soft keyboard.
                                  FocusScope.of(inContext).requestFocus(FocusNode());
                                  // Go back to the list view.
                                  inModel.setStackIndex(0);
                                }
                            ),
                            Spacer(),
                            TextButton(child : Text("Save"),
                                onPressed : () { _save(inContext, taskModel); }
                            )
                          ]
                      )
                  ),
                  body : Form(
                      key : _formKey,
                      child : ListView(
                          children : [
                            // Description.
                            ListTile(
                                leading : Icon(Icons.description),
                                title : TextFormField(
                                    keyboardType : TextInputType.multiline,
                                    maxLines : 4,
                                    decoration : InputDecoration(hintText : "Description"),
                                    controller : _descriptionEditor,
                                    validator : (String? inValue) {
                                      if (inValue!.length == 0) { return "Please enter a description"; }
                                      return null;
                                    }
                                )
                            ),
                            // Due date.
                            ListTile(
                                leading : Icon(Icons.today),
                                title : Text("Due Date"),
                                subtitle : Text(taskModel.chosenDate == null ? "" : taskModel.chosenDate!),
                                trailing : IconButton(
                                    icon : Icon(Icons.edit), color : Colors.blue,
                                    onPressed : () async {
                                      // Request a date from the user.  If one is returned, store it.
                                      String? chosenDate = await utils.selectDate(
                                          inContext, taskModel, taskModel.entityBeingEdited.dueDate
                                      );
                                      if (chosenDate != null) {
                                        taskModel.entityBeingEdited.dueDate = chosenDate;
                                      }
                                    }
                                )
                            )
                          ] /* End Column children. */
                      ) /* End ListView. */
                  ) /* End Form. */
              ); /* End Scaffold. */
            } /* End ScopedModelDescendant builder(). */
        ) /* End ScopedModelDescendant. */
    ); /* End ScopedModel. */

  } /* End build(). */


  /// Save this contact to the database.
  ///
  /// @param inContext The BuildContext of the parent widget.
  /// @param inModel   The TasksModel.
  void _save(BuildContext inContext, TaskModel inModel) async {
    print("## TasksEntry._save()");

    // // Abort if form isn't valid.
    // if (!_formKey.currentState!.validate()) { return; }

    // Creating a new task.
    if (inModel.entityBeingEdited.id == 0) {
      print("## TasksEntry._save(): Creating: ${inModel.entityBeingEdited}");
      await TaskDBWorker.instance.create(taskModel.entityBeingEdited);
    }
    else {
      print("## TasksEntry._save(): Updating: ${inModel.entityBeingEdited}");
      await TaskDBWorker.instance.update(taskModel.entityBeingEdited);
    }

    // Reload data from database to update list.
    taskModel.loadData("tasks", TaskDBWorker.instance);

    // Go back to the list view.
    inModel.setStackIndex(0);

    // Show SnackBar.
    ScaffoldMessenger.of(inContext).showSnackBar(
        SnackBar(
            backgroundColor : Colors.green,
            duration : Duration(seconds : 2),
            content : Text("Task saved")
        )
    );
  }
}
