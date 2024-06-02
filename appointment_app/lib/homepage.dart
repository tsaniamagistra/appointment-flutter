import 'package:appointment_app/formpage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:appointment_app/appointment.dart';
import 'package:appointment_app/appointment_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppointmentController _controller = AppointmentController();

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Appointment'),
          content: Text('Are you sure you want to delete this appointment?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _controller.deleteAppointment(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Appointments'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Appointment>('appointments').listenable(),
        builder: (context, Box<Appointment> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text('No appointments yet!'),
            );
          }

          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final appointment = box.getAt(index);
              if (appointment == null) {
                return Container();
              }
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  appointment.contact,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appointment.activity,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.event),
                              SizedBox(width: 8),
                              Text(appointment.date.toLocal().toString().split(' ')[0]),
                              SizedBox(width: 10),
                              Icon(Icons.access_time),
                              SizedBox(width: 8),
                              Text(appointment.startTime.format(context)),
                              SizedBox(width: 8),
                              Text('-'),
                              SizedBox(width: 8),
                              Text(appointment.endTime.format(context)),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  appointment.location,
                                  overflow: TextOverflow.visible,
                                  maxLines: null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(context, index);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
