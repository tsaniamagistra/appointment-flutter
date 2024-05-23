import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'appointment.g.dart';

@HiveType(typeId: 0)
class Appointment {
  @HiveField(0)
  final String contact;

  @HiveField(1)
  final String activity;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final TimeOfDay startTime;

  @HiveField(5)
  final TimeOfDay endTime;

  Appointment(this.contact, this.activity, this.location, this.date, this.startTime, this.endTime);
}
