import 'package:flutter/material.dart';
import 'package:proapptive/providers/tasks_provider.dart';
import 'package:proapptive/widgets/main_drawer.dart';
import 'package:proapptive/widgets/task_overview_item.dart';
import 'package:provider/provider.dart';

class TasksCompleteOverviewScreen extends StatefulWidget {
  static const routeName = '/tasks';

  @override
  _TasksCompleteOverviewScreenState createState() =>
      _TasksCompleteOverviewScreenState();
}

class _TasksCompleteOverviewScreenState
    extends State<TasksCompleteOverviewScreen> {
  bool _isInit = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<TasksProvider>(context).fetchAndSetTasks().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<TasksProvider>(context).allMyTasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas'),
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () =>
                  Provider.of<TasksProvider>(context, listen: false)
                      .fetchAndSetTasks(),
              child: Padding(
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
            ),
    );
  }
}
