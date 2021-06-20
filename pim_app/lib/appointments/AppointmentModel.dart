import 'package:pim_app/BaseModel.dart';

class Appointment {
  int id = 0;
  String title = "";
  String description = "";
  String date = "";
  String time = "";
}


class AppointmentModel extends BaseModel {
  String? _time;

  void setTime(String time){
    this._time = time;
    notifyListeners();
  }

  String? get time => _time;
}
