import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proapptive/providers/auth.dart';
import 'package:proapptive/providers/task.dart';
import 'package:provider/provider.dart';

class TaskOverviewItem extends StatefulWidget {
  final bool myTaskInProject;

  TaskOverviewItem({this.myTaskInProject = false});

  @override
  _TaskOverviewItemState createState() => _TaskOverviewItemState();
}

class _TaskOverviewItemState extends State<TaskOverviewItem> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Task>(context);
    final Auth auth = Provider.of<Auth>(context, listen: false);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: widget.myTaskInProject && data.assignedTo
            ? Colors.white54
            : Theme.of(context).primaryColor,
        child: Icon(
          Task.iconPerCategoryDict[data.type],
          color: widget.myTaskInProject && data.assignedTo
              ? Colors.black54
              : Colors.white,
        ),
      ),
      title: Text(
        data.name,
        style: Theme.of(context).textTheme.headline3,
      ),
      subtitle: Text(
        'Para: ${DateFormat('HH:mm, dd/MM.').format(data.terminationDate)}',
        style: Theme.of(context).textTheme.headline4,
      ),
      trailing: _isLoading
          ? CircularProgressIndicator()
          : widget.myTaskInProject && data.assignedTo
              ? Icon(
                  data.done ? Icons.done : Icons.close,
                )
              : IconButton(
                  icon: Icon(
                    data.done ? Icons.check_box : Icons.check_box_outline_blank,
                  ),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    Provider.of<Task>(context, listen: false)
                        .toggleDone(auth.token, auth.userId)
                        .then(
                      (value) {
                        setState(
                          () {
                            _isLoading = false;
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }
}
