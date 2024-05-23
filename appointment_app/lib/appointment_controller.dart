import 'package:hive/hive.dart';
import 'package:appointment_app/appointment.dart';

class AppointmentController {
  static Box<Appointment> _appointmentBox = Hive.box<Appointment>('appointments');

  Future<void> addAppointment(Appointment appointment) async {
    await _appointmentBox.add(appointment);
  }

  List<Appointment> getAllAppointments() {
    return _appointmentBox.values.toList();
  }

  Future<void> deleteAppointment(int index) async {
    await _appointmentBox.deleteAt(index);
  }
}
