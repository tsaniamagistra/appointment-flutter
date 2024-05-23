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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Appointments'),
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
                                  overflow: TextOverflow.ellipsis,
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
                                  overflow: TextOverflow.ellipsis,
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
                              SizedBox(width: 8),
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
                                  overflow: TextOverflow.ellipsis,
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
                          _controller.deleteAppointment(index);
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
