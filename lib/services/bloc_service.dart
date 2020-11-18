import 'dart:async';
import 'package:flutter_bloc_crud/model/user.dart';
import 'package:flutter_bloc_crud/services/user_event.dart';

class BlocService {
  List<User> students = [];
  User student;
  int studentIndex;

  final _stateStreamController = StreamController<List<User>>();
  StreamSink<List<User>> get studentSink => _stateStreamController.sink;
  Stream<List<User>> get studentStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<UserEvent>();
  StreamSink<UserEvent> get eventSink => _eventStreamController.sink;
  Stream<UserEvent> get eventStream => _eventStreamController.stream;

  BlocService() {
    eventStream.listen((event) {
      if (event.eventType == EventType.INSERT) {
        students.add(event.student);
        studentSink.add(students);
      } else if (event.eventType == EventType.UPDATE) {
        students[event.studentIndex] = event.student;
        studentSink.add(students);
      } else if (event.eventType == EventType.DELETE) {
        students.removeAt(event.studentIndex);
        studentSink.add(students);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
