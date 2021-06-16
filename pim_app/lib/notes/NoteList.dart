import "package:flutter/material.dart";
import 'package:pim_app/notes/NoteDBWorker.dart';
import "package:scoped_model/scoped_model.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "NoteDBWorker.dart" show NoteDBWorker;
import "NoteModel.dart" show Note, NoteModel, noteModel;
import 'package:flutter/cupertino.dart';

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext inContext) {
    print("## noteList.build()");

    // Return widget.
    return ScopedModel<NoteModel>(
        model: noteModel,
        child: ScopedModelDescendant<NoteModel>(builder:
                (BuildContext inContext, Widget? inChild, NoteModel inModel) {
          return Scaffold(
              // Add note.
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    noteModel.entityBeingEdited = Note();
                    noteModel.setColor("grey");
                    noteModel.setStackIndex(1);
                  }),
              body: ListView.builder(
                  itemCount: noteModel.entityList.length,
                  itemBuilder: (BuildContext inBuildContext, int inIndex) {
                    Note note = noteModel.entityList[inIndex];
                    // Determine note background color (default to white if none was selected).
                    Color color = Colors.white;
                    switch (note.color) {
                      case "red":
                        color = Colors.red;
                        break;
                      case "green":
                        color = Colors.green;
                        break;
                      case "blue":
                        color = Colors.blue;
                        break;
                      case "yellow":
                        color = Colors.yellow;
                        break;
                      case "grey":
                        color = Colors.grey;
                        break;
                      case "purple":
                        color = Colors.purple;
                        break;
                    }
                    return Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Slidable(
                            actionPane: SlidableDrawerActionPane(),

                            actionExtentRatio: .25,
                            secondaryActions: [
                              IconSlideAction(
                                  caption: "Delete",
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () => _deleteNote(inContext, note))
                            ],
                            child: Card(
                                elevation: 8,
                                color: color,
                                child: ListTile(
                                    title: Text("${note.title}"),
                                    subtitle: Text("${note.content}"),
                                    // Edit existing note.
                                    onTap: () async {
                                      // Get the data from the database and send to the edit view.
                                      noteModel.entityBeingEdited =
                                          await NoteDBWorker.db.get(note.id);
                                      noteModel.setColor(
                                          noteModel.entityBeingEdited.color);
                                      noteModel.setStackIndex(1);
                                    })) /* End Card. */
                            ) /* End Slidable. */
                        ); /* End Container. */
                  } /* End itemBuilder. */
                  ) /* End End ListView.builder. */
              ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder. */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  }

/* End build(). */

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext The BuildContext of the parent Widget.
  /// @param  inNote    The note (potentially) being deleted.
  /// @return           Future.
  Future _deleteNote(BuildContext parentContext, Note note) async {
    print("## NotestList._deleteNote(): inNote = $note");

    return showDialog(
        context: parentContext,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
              title: Text("Delete Note"),
              content: Text("Are you sure you want to delete ${note.title}?"),
              actions: [
                TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      // Just hide dialog.
                      Navigator.of(alertContext).pop();
                    }),
                TextButton(
                    child: Text("Delete"),
                    onPressed: () async {
                      // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                      await NoteDBWorker.db.delete(note.id);
                      Navigator.of(alertContext).pop();
                      ScaffoldMessenger.of(parentContext).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                              content: Text("Note deleted")));
                      // Reload data from database to update list.
                      noteModel.loadData("notes", NoteDBWorker.db);
                    })
              ]);
        });
  }
/* End _deleteNote(). */

}
