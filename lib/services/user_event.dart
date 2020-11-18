import 'package:flutter_bloc_crud/model/user.dart';

enum EventType {
  INSERT,
  UPDATE,
  DELETE,
  FETCH,
}

class UserEvent {
  User student;
  int studentIndex;
  EventType eventType;

  UserEvent.add(User student) {
    this.eventType = EventType.INSERT;
    this.student = student;
  }

  UserEvent.update(User student, int index) {
    this.eventType = EventType.UPDATE;
    this.student = student;
    this.studentIndex = index;
  }

  UserEvent.delete(int index) {
    this.eventType = EventType.DELETE;
    this.studentIndex = index;
  }

  UserEvent.fetch() {
    this.eventType = EventType.FETCH;
  }
}
