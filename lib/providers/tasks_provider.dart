import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:proapptive/providers/task.dart';
import 'package:http/http.dart' as http;

class TasksProvider with ChangeNotifier {
  /*
  List<Task> _tasks = [
    Task(
      id: '1',
      type: TaskCategory.Meeting,
      creatorEmail: 'angel@kof.com.mx',
      name: 'Reunion',
      terminationDate: DateTime.now(),
      creationDate: DateTime.now(),
      asigneesEmail: ['angel@kof.com.mx'],
    ),
    Task(
      id: '2',
      type: TaskCategory.Routine,
      creatorEmail: 'angel@kof.com.mx',
      name: 'Rutina',
      terminationDate: DateTime.now(),
      creationDate: DateTime.now(),
      asigneesEmail: ['angel@kof.com.mx'],
    ),
    Task(
      id: '3',
      type: TaskCategory.Extraordinary,
      creatorEmail: 'angel@kof.com.mx',
      name: 'Presupuesto',
      terminationDate: DateTime.now(),
      creationDate: DateTime.now(),
      asigneesEmail: ['angel@kof.com.mx'],
    ),
    Task(
      id: '4',
      type: TaskCategory.Step,
      creatorEmail: 'angel@kof.com.mx',
      name: 'Presupuesto',
      terminationDate: DateTime.now(),
      creationDate: DateTime.now(),
      asigneesEmail: ['angel@kof.com.mx'],
    ),
  ];
  */

  String _token;
  String _userID;
  List<Task> _tasks;

  TasksProvider(
    this._token,
    this._userID,
    this._tasks,
  );

  List<Task> get tasks {
    return [..._tasks];
  }

  List<Task> get allMyTasks {
    return tasks.where((element) => element.assignedTo).toList()
      ..sort(
        (a, b) => a.terminationDate.compareTo(b.terminationDate),
      );
  }

  List<Task> get myTasksForTheDay {
    return allMyTasks
        .where(
          (element) =>
              element.terminationDate.isBefore(
                DateTime.now().add(
                  Duration(days: 1),
                ),
              ) &&
              element.terminationDate.isAfter(
                DateTime.now().subtract(
                  Duration(days: 1),
                ),
              ) &&
              !element.done,
        )
        .toList();
  }

  Future<void> fetchAndSetTasks() async {
    final url =
        'https://proapptive-a6824.firebaseio.com/tasks.json?auth=$_token';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedData = json.decode(response.body);
      final List<Task> loadedTasks = [];
      if (extractedData == null) {
        return;
      }
      final favURL =
          'https://proapptive-a6824.firebaseio.com/userTasks/$_userID.json?auth=$_token';
      final favouriteResponse = await http.get(favURL);
      final extractedTasks = json.decode(favouriteResponse.body);

      extractedData.forEach(
        (key, value) {
          Task newTask = Task(
            id: key,
            creationDate: DateTime.parse(value['creationDate']),
            terminationDate: DateTime.parse(value['terminationDate']),
            creatorID: value['creatorID'],
            name: value['name'],
            type: stringToEnum(value['type']),
            upperTask: value['upperTask'],
            projectName: value['projectName'],
            assignedTo: extractedTasks == null
                ? false
                : extractedTasks[key] == null
                    ? false
                    : true,
          );

          if (newTask.assignedTo) {
            newTask.done = extractedTasks[key]['done'];
            newTask.doneDate = DateTime.parse(extractedTasks[key]['doneDate']);
          }

          loadedTasks.add(newTask);
        },
      );
      _tasks = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  static String enumValToString(TaskCategory man) {
    return man.toString().split('.')[1];
  }

  static List<String> enumListToString() {
    List<TaskCategory> values = TaskCategory.values;
    List<String> managementBranches = [];

    values.forEach(
      (element) {
        managementBranches.add(element.toString().split('.')[1]);
      },
    );

    managementBranches.removeLast();

    return managementBranches;
  }

  static TaskCategory stringToEnum(String man) {
    return TaskCategory.values[enumListToString().indexOf(man)];
  }
}
