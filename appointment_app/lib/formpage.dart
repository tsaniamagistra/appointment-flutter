import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'appointment.dart';

class AppointmentForm extends StatefulWidget {
  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _contactController = TextEditingController();
  final _activityController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  @override
  void dispose() {
    _contactController.dispose();
    _activityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5, DateTime.now().month, DateTime.now().day),
    );

    if (date != null) {
      setState(() {
        _date = date;
      });
    }
  }

  Future<void> _pickTime(BuildContext context, {bool isStart = true}) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  void _showAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final now = DateTime.now();
      final startDateTime = DateTime(_date.year, _date.month, _date.day, _startTime.hour, _startTime.minute);
      final endDateTime = DateTime(_date.year, _date.month, _date.day, _endTime.hour, _endTime.minute);

      if (startDateTime.isBefore(now)) {
        _showAlert('Invalid Time', 'Start time cannot be before current time.');
        return;
      }

      if (endDateTime.isBefore(startDateTime)) {
        _showAlert('Invalid Time', 'End time cannot be before start time.');
        return;
      }

      final newAppointment = Appointment(
        _contactController.text,
        _activityController.text,
        _locationController.text,
        _date,
        _startTime,
        _endTime,
      );

      final box = Hive.box<Appointment>('appointments');
      box.add(newAppointment);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: "Contact's name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the contact's name";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _activityController,
                decoration: InputDecoration(labelText: 'Activity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an activity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(
                  'Date: ${DateFormat.yMd().format(_date)}',
                ),
                trailing: Icon(Icons.event),
                onTap: () => _pickDate(context),
              ),
              ListTile(
                title: Text(
                  'Start Time: ${_startTime.format(context)}',
                ),
                trailing: Icon(Icons.access_time),
                onTap: () => _pickTime(context, isStart: true),
              ),
              ListTile(
                title: Text(
                  'End Time: ${_endTime.format(context)}',
                ),
                trailing: Icon(Icons.access_time),
                onTap: () => _pickTime(context, isStart: false),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
