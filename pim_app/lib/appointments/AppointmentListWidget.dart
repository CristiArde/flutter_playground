import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
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
                onPressed: () async {},
              ),
            );
          },
        ));
  }
}
