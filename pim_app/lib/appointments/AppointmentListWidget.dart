import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:pim_app/appointments/AppointmentsDBWorker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'AppointmentModel.dart';

class AppointmentListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EventList<Event> _markedDates = EventList(events: {});
    for (int i = 0; i < appointmentModel.entityList.length; i++) {
      Appointment appointment = appointmentModel.entityList[i];
      List dateParts = appointment.date.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
      _markedDates.add(apptDate, Event(date: apptDate, icon: Container(decoration: BoxDecoration(color: Colors.blue))));
    }
    return ScopedModel<AppointmentModel>(
        model: appointmentModel,
        child: ScopedModelDescendant<AppointmentModel>(
          builder: (context, child, model) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    appointmentModel.entityBeingEdited = new Appointment();
                    DateTime nowDate = DateTime.now();
                    appointmentModel.entityBeingEdited.date = "${nowDate.year},${nowDate.month},${nowDate.day}";
                    appointmentModel.setChosenDate(DateFormat.yMMMMd("en_US").format(nowDate.toLocal()));
                    appointmentModel.setTime("");
                    appointmentModel.setStackIndex(1);
                  },
                ),
                body: Column(
                  children: [
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: CalendarCarousel<Event>(
                        thisMonthDayBorderColor: Colors.grey,
                        daysHaveCircularBorder: false,
                        markedDatesMap: _markedDates,
                        onDayPressed: (date, events) {
                          _showAppointments(date, context);
                        },
                      ),
                    ))
                  ],
                ));
          },
        ));
  }

  void _showAppointments(DateTime date, BuildContext context) {
    print("## AppointmentsList._showAppointments(): inDate = $date (${date.year},${date.month},${date.day})");
    print("## AppointmentsList._showAppointments(): appointmentModel.entityList.length = ${appointmentModel.entityList.length}");
    print("## AppointmentsList._showAppointments(): appointmentModel.entityList = ${appointmentModel.entityList}");

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ScopedModel<AppointmentModel>(
            model: appointmentModel,
            child: ScopedModelDescendant<AppointmentModel>(
              builder: (context, child, model) {
                return Scaffold(
                    body: Container(
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: GestureDetector(
                                child: Column(children: [
                              Text(DateFormat.yMMMMd("en_US").format(date.toLocal()), textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).accentColor, fontSize: 24)),
                              Divider(),
                              Expanded(
                                  child: ListView.builder(
                                      itemCount: appointmentModel.entityList.length,
                                      itemBuilder: (BuildContext inBuildContext, int inIndex) {
                                        Appointment appointment = appointmentModel.entityList[inIndex];
                                        print("## AppointmentsList._showAppointments().ListView.builder(): "
                                            "appointment = $appointment");
                                        // Filter out any appointment that isn't for the specified date.
                                        if (appointment.date != "${date.year},${date.month},${date.day}") {
                                          return Container(height: 0);
                                        }
                                        print("## AppointmentsList._showAppointments().ListView.builder(): "
                                            "INCLUDING appointment = $appointment");
                                        // If the appointment has a time, format it for display.
                                        String apptTime = "";
                                        if (appointment.time.isNotEmpty) {
                                          List timeParts = appointment.time.split(",");
                                          TimeOfDay at = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
                                          apptTime = " (${at.format(context)})";
                                        }
                                        // Return a widget for the appointment since it's for the correct date.
                                        return Slidable(
                                            actionPane: SlidableDrawerActionPane(),
                                            actionExtentRatio: .25,
                                            child: Container(
                                                margin: EdgeInsets.only(bottom: 8),
                                                color: Colors.grey.shade300,
                                                child: ListTile(
                                                    title: Text("${appointment.title}$apptTime"),
                                                    subtitle: appointment.description.isEmpty ? null : Text("${appointment.description}"),
                                                    // Edit existing appointment.
                                                    onTap: () async {
                                                      _editAppointment(context, appointment);
                                                    })),
                                            secondaryActions: [
                                              IconSlideAction(caption: "Delete", color: Colors.red, icon: Icons.delete, onTap: () => _deleteAppointment(inBuildContext, appointment))
                                            ]); /* End Slidable. */
                                      } /* End itemBuilder. */
                                      ) /* End ListView.builder. */
                                  ) /* End Expanded. */
                            ] /* End Column.children. */
                                    ) /* End Column. */
                                ) /* End GestureDetector. */
                            ) /* End Padding. */
                        ));
              },
            ),
          );
        });
  }

  /// Handle taps on an appointment to trigger editing.
  ///
  /// @param inContext     The BuildContext of the parent widget.
  /// @param inAppointment The Appointment being edited.
  void _editAppointment(BuildContext inContext, Appointment inAppointment) async {
    print("## AppointmentsList._editAppointment(): inAppointment = $inAppointment");

    // Get the data from the database and send to the edit view.
    appointmentModel.entityBeingEdited = await AppointmentsDBWorker.instance.get(inAppointment.id);
    // Parse out the apptDate and apptTime, if any, and set them in the model
    // for display.
    if (appointmentModel.entityBeingEdited.apptDate == null) {
      appointmentModel.setChosenDate("");
    } else {
      List dateParts = appointmentModel.entityBeingEdited.apptDate.split(",");
      DateTime apptDate = DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]));
      appointmentModel.setChosenDate(DateFormat.yMMMMd("en_US").format(apptDate.toLocal()));
    }
    if (appointmentModel.entityBeingEdited.apptTime == null) {
      appointmentModel.setTime("");
    } else {
      List timeParts = appointmentModel.entityBeingEdited.apptTime.split(",");
      TimeOfDay apptTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      appointmentModel.setTime(apptTime.format(inContext));
    }
    appointmentModel.setStackIndex(1);
    Navigator.pop(inContext);
  }

  /* End _editAppointment. */

  /// Show a dialog requesting delete confirmation.
  ///
  /// @param  inContext     The parent build context.
  /// @param  inAppointment The appointment (potentially) being deleted.
  /// @return               Future.
  Future _deleteAppointment(BuildContext inContext, Appointment inAppointment) async {
    print("## AppointmentsList._deleteAppointment(): inAppointment = $inAppointment");

    return showDialog(
        context: inContext,
        barrierDismissible: false,
        builder: (BuildContext inAlertContext) {
          return AlertDialog(title: Text("Delete Appointment"), content: Text("Are you sure you want to delete ${inAppointment.title}?"), actions: [
            TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  // Just hide dialog.
                  Navigator.of(inAlertContext).pop();
                }),
            TextButton(
                child: Text("Delete"),
                onPressed: () async {
                  // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                  await AppointmentsDBWorker.instance.delete(inAppointment.id);
                  Navigator.of(inAlertContext).pop();
                  ScaffoldMessenger.of(inContext).showSnackBar(SnackBar(backgroundColor: Colors.red, duration: Duration(seconds: 2), content: Text("Appointment deleted")));
                  // Reload data from database to update list.
                  appointmentModel.loadData("appointments", AppointmentsDBWorker.instance);
                })
          ]);
        });
  }
/* End _deleteAppointment(). */
}
