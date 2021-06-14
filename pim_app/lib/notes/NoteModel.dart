import "../BaseModel.dart";

/// A class representing this PIM entity type.
class Note {
  /// The fields this entity type contains.
  int id = -1;
  String title = "Default Title";
  String content = "Default content";
  String color = "Grey";



  /// Just for debugging, so we get something useful in the console.
  String toString() {
    return "{ id=$id, title=$title, content=$content, color=$color }";
  }
}


class NoteModel extends BaseModel {
  var _color = "Grey";

  void setColor(String color){
    this._color = color;
    notifyListeners();
  }

  get color => _color;
}

NoteModel noteModel = NoteModel();