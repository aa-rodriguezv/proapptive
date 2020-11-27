import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TaskCategory {
  Meeting,
  Routine,
  Extraordinary,
  Step,
}

class Task with ChangeNotifier {
  final String id;
  final String name;
  final DateTime creationDate;
  final DateTime terminationDate;
  DateTime doneDate;
  final String creatorEmail;
  final List<String> asigneesEmail;
  final String upperTask;
  final String projectName;
  final TaskCategory type;
  bool done;

  static final Map<TaskCategory, IconData> iconPerCategoryDict = {
    TaskCategory.Meeting: Icons.meeting_room,
    TaskCategory.Routine: Icons.timelapse,
    TaskCategory.Step: Icons.account_tree,
    TaskCategory.Extraordinary: Icons.flag,
  };

  Task({
    @required this.id,
    @required this.name,
    @required this.creationDate,
    @required this.terminationDate,
    @required this.creatorEmail,
    @required this.type,
    this.asigneesEmail,
    this.upperTask,
    this.projectName,
    this.done = false,
  });

  void toggleDone() {
    this.done = !this.done;
    doneDate = done ? DateTime.now() : null;
    notifyListeners();
  }
}
