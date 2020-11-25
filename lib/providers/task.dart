import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TaskCategory {
  Meeting,
  Routine,
  Step,
  Extraordinary,
}

class Task with ChangeNotifier {
  final String name;
  final DateTime creationDate;
  final DateTime terminationDate;
  DateTime doneDate;
  final String creatorEmail;
  final List<String> asigneesEmail;
  final String upperTask;
  final String projectName;
  bool done;

  static final Map<TaskCategory, IconData> iconPerCategoryDict = {
    TaskCategory.Meeting: Icons.meeting_room,
    TaskCategory.Routine: Icons.timelapse,
    TaskCategory.Step: Icons.account_tree,
    TaskCategory.Extraordinary: Icons.extension,
  };

  Task({
    @required this.name,
    @required this.creationDate,
    @required this.terminationDate,
    @required this.creatorEmail,
    this.asigneesEmail,
    this.upperTask,
    this.projectName,
  });
}
