import 'package:flutter/cupertino.dart';
import 'package:proapptive/providers/task.dart';

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
  String _userEmail;
  List<Task> _tasks;

  TasksProvider(
    this._token,
    this._userEmail,
    this._tasks,
  );

  List<Task> get tasks {
    return [..._tasks];
  }

  List<Task> get allMyTasks {
    return _tasks
        .where((element) => element.asigneesEmail.contains('angel@kof.com.mx'))
        .toList()
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
}
