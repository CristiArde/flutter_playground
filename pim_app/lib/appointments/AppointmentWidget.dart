import 'package:flutter/cupertino.dart';
import 'package:pim_app/appointments/AppointmentListWidget.dart';
import 'package:pim_app/appointments/AppointmentModel.dart';
import 'package:scoped_model/scoped_model.dart';

class AppointmentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppointmentModel>(
        model: appointmentModel,
        child: ScopedModelDescendant<AppointmentModel>(
          builder: (BuildContext context, Widget? child, AppointmentModel model) {
            return IndexedStack(
              index: model.stackIndex,
              children: [AppointmentListWidget()],
            );
          },
        ));
  }
}
