import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model {
  int stackIndex = 0;
  List entityList = [];
  var entityBeingEdited;
  String? chosenDate;

  /// For display of the date chosen by the user.
  ///
  /// @param inDate The date in MM/DD/YYYY form.
  void setChosenDate(String inDate) {
    print("## BaseModel.setChosenDate(): inDate = $inDate");

    chosenDate = inDate;
    notifyListeners();
  }

  /* End setChosenDate(). */

  /// Load data from database.
  ///
  /// @param inEntityType The type of entity being loaded ("appointments", "contacts", "notes" or "tasks").
  /// @param inDatabase   The DBProvider.db instance for the entity.
  void loadData(String inEntityType, dynamic inDatabase) async {
    print("## ${inEntityType}Model.loadData()");

    // Load entities from database.
    entityList = await inDatabase.getAll();

    // Notify listeners that the data is available so they can paint themselves.
    notifyListeners();
  }

  /* End loadData(). */

  /// For navigating between entry and list views.
  ///
  /// @param inStackIndex The stack index to make current.
  void setStackIndex(int inStackIndex) {
    print("## BaseModel.setStackIndex(): inStackIndex = $inStackIndex");

    stackIndex = inStackIndex;
    notifyListeners();
  }
/* End setStackIndex(). */
}
