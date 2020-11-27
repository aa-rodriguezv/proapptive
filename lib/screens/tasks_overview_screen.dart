import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proapptive/providers/task.dart';
import 'package:proapptive/providers/tasks_provider.dart';
import 'package:proapptive/widgets/main_drawer.dart';
import 'package:proapptive/widgets/task_overview_item.dart';
import 'package:provider/provider.dart';

class TasksOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<TasksProvider>(context).myTasksForTheDay;

    return Scaffold(
      appBar: AppBar(
        title: Text('Be Proactive'),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Tareas para Hoy',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(top: 20, left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'Siguiente tarea:',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (ctx, i) {
                  return ChangeNotifierProvider.value(
                    value: data[i],
                    child: i == 0 ? NextTask() : TaskOverviewItem(),
                  );
                },
                itemCount: data.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 80,
      margin: EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
        top: 10,
      ),
      alignment: Alignment.center,
      child: Card(
        elevation: 10,
        child: TaskOverviewItem(),
      ),
    );
  }
}
