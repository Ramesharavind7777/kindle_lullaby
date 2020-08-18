import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Remainder {
  int id;
  String dateTime;
  int selectedApp;
  String notes;
  DateTime createdAt = DateTime.now();
  int duration;

  Remainder({this.id, this.dateTime, this.selectedApp, this.notes, this.duration});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'id': id,
      'dateTime': dateTime,
      'selectedApp': selectedApp,
      'notes': notes,
      'createdAt': createdAt.toString(),
      'duration': duration
    };
    return map;
  }

  Remainder.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    dateTime = map['dateTime'];
    selectedApp = map['selectedApp'];
    notes = map['notes'];
    createdAt = DateTime.parse(map['createdAt']);
    duration = map['duration'];
  }

}
