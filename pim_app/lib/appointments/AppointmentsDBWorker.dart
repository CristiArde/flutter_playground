import 'package:sqflite/sqflite.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import "../utils.dart" as utils;
import 'AppointmentModel.dart';



class AppointmentsDBWorker {
  late Future<Database> _db;
  static final AppointmentsDBWorker _instance = new AppointmentsDBWorker._();
  static final _initDBMemoizer = AsyncMemoizer<Database>();

  AppointmentsDBWorker._()  {
    _db = _initDBMemoizer.runOnce(() => _initDB());
  }

  Future<Database> _initDB() async {
    String path = join(utils.docsDir!.path, "appointments.db");
    print("## appointments AppointmentsDBWorker.init(): path = $path");
    Database db = await openDatabase(path, version : 1, onOpen : (db) { },
        onCreate : (Database inDB, int inVersion) async {
          await inDB.execute(
              "CREATE TABLE IF NOT EXISTS appointments ("
                  "id INTEGER PRIMARY KEY,"
                  "title TEXT,"
                  "description TEXT,"
                  "date TEXT,"
                  "time TEXT"
                  ")"
          );
        }
    );
    return db;
  }

  static AppointmentsDBWorker get instance => _instance;

  /// Create a Appointment from a Map.
  Appointment appointmentFromMap(Map map) {
    print("## appointments AppointmentsDBWorker.appointmentFromMap(): inMap = $map");
    Appointment appointment = Appointment();
    appointment.id = map["id"];
    appointment.title = map["title"];
    appointment.description = map["description"];
    appointment.date = map["date"];
    appointment.time = map["time"];
    print("## appointments AppointmentsDBWorker.appointmentFromMap(): appointment = $appointment");

    return appointment;

  } /* End appointmentFromMap(); */


  /// Create a Map from a Appointment.
  Map<String, dynamic> appointmentToMap(Appointment appointment) {
    print("## appointments AppointmentsDBWorker.appointmentToMap(): inAppointment = $appointment");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = appointment.id;
    map["title"] = appointment.title;
    map["description"] = appointment.description;
    map["date"] = appointment.date;
    map["time"] = appointment.time;
    print("## appointments AppointmentsDBWorker.appointmentToMap(): map = $map");

    return map;

  } /* End appointmentToMap(). */


  /// Create a appointment.
  ///
  /// @param inAppointment the Appointment object to create.
  Future create(Appointment inAppointment) async {
    print("## appointments AppointmentsDBWorker.create(): inAppointment = $inAppointment");
    Database db = await _db;
    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM appointments");
    var id = val.first["id"];
    if (id == null) { id = 1; }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO appointments (id, title, description, date, time) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inAppointment.title,
          inAppointment.description,
          inAppointment.date,
          inAppointment.time
        ]
    );

  } /* End create(). */


  /// Get a specific appointment.
  ///
  /// @param  inID The ID of the appointment to get.
  /// @return      The corresponding Appointment object.
  Future<Appointment> get(int inID) async {

    print("## appointments AppointmentsDBWorker.get(): inID = $inID");

    Database db = await _db;
    var rec = await db.query("appointments", where : "id = ?", whereArgs : [ inID ]);
    print("## appointments AppointmentsDBWorker.get(): rec.first = $rec.first");
    return appointmentFromMap(rec.first);

  } /* End get(). */


  /// Get all appointments.
  ///
  /// @return A List of Appointment objects.
  Future<List> getAll() async {

    Database db = await _db;
    var recs = await db.query("appointments");
    var list = recs.isNotEmpty ? recs.map((m) => appointmentFromMap(m)).toList() : [ ];

    print("## appointments AppointmentsDBWorker.getAll(): list = $list");

    return list;

  } /* End getAll(). */


  /// Update a appointment.
  ///
  /// @param inAppointment The appointment to update.
  Future update(Appointment inAppointment) async {

    print("## appointments AppointmentsDBWorker.update(): inAppointment = $inAppointment");

    Database db = await _db;
    return await db.update(
        "appointments", appointmentToMap(inAppointment), where : "id = ?", whereArgs : [ inAppointment.id ]
    );

  } /* End update(). */


  /// Delete a appointment.
  ///
  /// @param inID The ID of the appointment to delete.
  Future delete(int inID) async {

    print("## appointments AppointmentsDBWorker.delete(): inID = $inID");

    Database db = await _db;
    return await db.delete("appointments", where : "id = ?", whereArgs : [ inID ]);

  } /* End delete(). */
  
}
