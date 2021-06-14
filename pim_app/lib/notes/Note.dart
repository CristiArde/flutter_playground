import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NoteDBWorker.dart';
import 'NoteEntry.dart';
import 'NoteList.dart';
import 'NoteModel.dart' show noteModel, NoteModel;

class Note extends StatelessWidget {
  Note() {
    noteModel.loadData("notes", NoteDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NoteModel>(model: noteModel,
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget? child, NoteModel model) {
            return IndexedStack(
              index: model.stackIndex,
              children: [NoteList(), NoteEntry()],
            );
          },
        ));
  }


}