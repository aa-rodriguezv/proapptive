import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:proapptive/providers/project.dart';
import 'package:proapptive/providers/projects_provider.dart';
import 'package:proapptive/providers/task.dart';
import 'package:proapptive/providers/tasks_provider.dart';
import 'package:proapptive/widgets/task_overview_item.dart';
import 'package:provider/provider.dart';

class ProjectDetailScreen extends StatefulWidget {
  static const routeName = '/project-detail';
  @override
  _ProjectDetailScreenState createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  bool _isInit = false;
  bool _isLoading = false;
  Project selectedProject;
  List<Task> projectTasks;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      String id = ModalRoute.of(context).settings.arguments;
      selectedProject =
          Provider.of<ProjectsProvider>(context).getProjectByID(id);
      projectTasks =
          Provider.of<TasksProvider>(context).getAllTasksForAProject(id);
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    int totalTasks = projectTasks.length;
    int completedTasks =
        projectTasks.where((element) => element.done == true).toList().length;
    double ratio = (completedTasks + 0.0) / (totalTasks + 0.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProject.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, left: 10, bottom: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                'Progreso del Proyecto:',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              height: 60,
              width: double.infinity,
              child: Card(
                elevation: 10,
                child: LiquidLinearProgressIndicator(
                  value: totalTasks == 0 ? 1 : ratio,
                  backgroundColor: Colors.white,
                  center: Text(
                    '$completedTasks de $totalTasks completadas.',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: ratio > 0.75 ? Colors.white : Colors.black,
                        ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: projectTasks[index],
                  child: TaskOverviewItem(
                    myTaskInProject: true,
                  ),
                ),
                itemCount: projectTasks.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
