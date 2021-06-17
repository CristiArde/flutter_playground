import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pim_app/notes/NoteModel.dart' show NoteModel, noteModel;
import 'package:scoped_model/scoped_model.dart';

import 'NoteDBWorker.dart';

class NoteEntryWidget extends StatelessWidget {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NoteEntryWidget() {
    _titleEditingController.addListener(() => noteModel.entityBeingEdited.title = _titleEditingController.text);
    _contentEditingController.addListener(() => noteModel.entityBeingEdited.content = _contentEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    print("## NotesEntry.build()");

    // Set value of controllers.
    if (noteModel.entityBeingEdited != null) {
      _titleEditingController.text = noteModel.entityBeingEdited.title;
      _contentEditingController.text = noteModel.entityBeingEdited.content;
    }

    // Return widget.
    return ScopedModel(
        model: noteModel,
        child: ScopedModelDescendant<NoteModel>(builder: (BuildContext inContext, Widget? inChild, NoteModel inModel) {
          return Scaffold(
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(children: [
                    TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          // Hide soft keyboard.
                          FocusScope.of(inContext).requestFocus(FocusNode());
                          // Go back to the list view.
                          inModel.setStackIndex(0);
                        }),
                    Spacer(),
                    TextButton(
                        child: Text("Save"),
                        onPressed: () {
                          _save(inContext, noteModel);
                        })
                  ])),
              body: Form(
                  key: _formKey,
                  child: ListView(children: [
                    // Title.
                    ListTile(
                        leading: Icon(Icons.title),
                        title: TextFormField(
                          decoration: InputDecoration(hintText: "Title"),
                          controller: _titleEditingController,
                        )),
                    // Content.
                    ListTile(
                        leading: Icon(Icons.content_paste),
                        title: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration: InputDecoration(hintText: "Content"),
                          controller: _contentEditingController,
                        )),
                    // Note color.
                    ListTile(
                        leading: Icon(Icons.color_lens),
                        title: Row(children: [
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(color: Colors.red, width: 18) + Border.all(width: 6, color: noteModel.color == "red" ? Colors.red : Theme.of(inContext).canvasColor))),
                              onTap: () {
                                noteModel.entityBeingEdited.color = "red";
                                noteModel.setColor("red");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(color: Colors.green, width: 18) + Border.all(width: 6, color: noteModel.color == "green" ? Colors.green : Theme.of(inContext).canvasColor))),
                              onTap: () {
                                noteModel.entityBeingEdited.color = "green";
                                noteModel.setColor("green");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(color: Colors.blue, width: 18) + Border.all(width: 6, color: noteModel.color == "blue" ? Colors.blue : Theme.of(inContext).canvasColor))),
                              onTap: () {
                                noteModel.entityBeingEdited.color = "blue";
                                noteModel.setColor("blue");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(color: Colors.yellow, width: 18) + Border.all(width: 6, color: noteModel.color == "yellow" ? Colors.yellow : Theme.of(inContext).canvasColor))),
                              onTap: () {
                                noteModel.entityBeingEdited.color = "yellow";
                                noteModel.setColor("yellow");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(color: Colors.grey, width: 18) + Border.all(width: 6, color: noteModel.color == "grey" ? Colors.grey : Theme.of(inContext).canvasColor))),
                              onTap: () {
                                noteModel.entityBeingEdited.color = "grey";
                                noteModel.setColor("grey");
                              }),
                          Spacer(),
                          GestureDetector(
                              child: Container(
                                  decoration: ShapeDecoration(
                                      shape: Border.all(color: Colors.purple, width: 18) + Border.all(width: 6, color: noteModel.color == "purple" ? Colors.purple : Theme.of(inContext).canvasColor))),
                              onTap: () {
                                noteModel.entityBeingEdited.color = "purple";
                                noteModel.setColor("purple");
                              })
                        ]))
                  ] /* End Column children. */
                      ) /* End ListView. */
                  ) /* End Form. */
              ); /* End Scaffold. */
        } /* End ScopedModelDescendant builder(). */
            ) /* End ScopedModelDescendant. */
        ); /* End ScopedModel. */
  }

  Future<void> _save(BuildContext inContext, NoteModel inModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Creating a new note.
    if (inModel.entityBeingEdited.id == -1) {
      print("## NotesEntry._save(): Creating: ${inModel.entityBeingEdited}");
      await NoteDBWorker.db.create(noteModel.entityBeingEdited);

      // Updating an existing note.
    } else {
      print("## NotesEntry._save(): Updating: ${inModel.entityBeingEdited}");
      await NoteDBWorker.db.update(noteModel.entityBeingEdited);
    }

    // Reload data from database to update list.
    noteModel.loadData("notes", NoteDBWorker.db);

    // Go back to the list view.
    noteModel.setStackIndex(0);

    // Show SnackBar.
    ScaffoldMessenger.of(inContext).showSnackBar(SnackBar(backgroundColor: Colors.green, duration: Duration(seconds: 2), content: Text("Note saved")));
  }
/* End build(). */

}
