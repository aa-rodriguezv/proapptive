import 'package:flutter/material.dart';
import 'package:proapptive/providers/tasks_provider.dart';
import 'package:proapptive/widgets/main_drawer.dart';
import 'package:proapptive/widgets/task_overview_item.dart';
import 'package:provider/provider.dart';

class TasksCompleteOverviewScreen extends StatelessWidget {
  static const routeName = '/tasks';
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<TasksProvider>(context).allMyTasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas'),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (ctx, i) {
            return ChangeNotifierProvider.value(
              value: data[i],
              child: TaskOverviewItem(),
            );
          },
          itemCount: data.length,
        ),
      ),
    );
  }
}
