import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final String creatorID;
  final String upperTask;
  final String projectName;
  final TaskCategory type;
  bool assignedTo;
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
    @required this.creatorID,
    @required this.type,
    this.upperTask,
    this.projectName,
    this.assignedTo,
    this.done = false,
    this.doneDate,
  });

  void toggleDone(String token, String userId) async {
    final url =
        'https://proapptive-a6824.firebaseio.com/userTasks/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          {
            'done': !done,
            'doneDate': DateTime.now().toIso8601String(),
          },
        ),
      );
      done = !done;
      if (done) {
        doneDate = DateTime.now();
      } else {
        doneDate = null;
      }

      if (response.statusCode >= 400) {
        done = !done;
        if (done) {
          doneDate = DateTime.now();
        } else {
          doneDate = null;
        }
      }
      notifyListeners();
    } catch (error) {
      notifyListeners();
      throw error;
    }
  }
}
