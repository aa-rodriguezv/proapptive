import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proapptive/providers/auth.dart';
import 'package:proapptive/providers/task.dart';
import 'package:provider/provider.dart';

class TaskOverviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Task>(context);
    final Auth auth = Provider.of<Auth>(context, listen: false);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Task.iconPerCategoryDict[data.type],
          color: Colors.white,
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
      trailing: IconButton(
        icon: Icon(
          data.done ? Icons.check_box : Icons.check_box_outlined,
        ),
        onPressed: () {
          Provider.of<Task>(context, listen: false)
              .toggleDone(auth.token, auth.userId);
        },
      ),
    );
  }
}
