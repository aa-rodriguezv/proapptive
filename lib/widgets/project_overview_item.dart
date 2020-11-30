import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:proapptive/providers/auth.dart';
import 'package:proapptive/providers/project.dart';
import 'package:proapptive/screens/project_detail_screen.dart';
import 'package:provider/provider.dart';

class ProjectOverviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Project>(context);
    final Auth auth = Provider.of<Auth>(context, listen: false);
    double ratio = DateTime.now().difference(data.creationDate).inDays /
        data.terminationDate.difference(data.creationDate).inDays;

    return Card(
      margin: EdgeInsets.all(10),
      elevation: 10,
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 100,
        child: ListTile(
          title: Text(
            data.name,
            style: Theme.of(context).textTheme.headline5,
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: LiquidCircularProgressIndicator(
              backgroundColor: Colors.black,
              value: ratio,
              center: Text(
                '${(ratio * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          subtitle: Text(
            'Termina: ${DateFormat('EEE dd/MM/yyyy').format(data.terminationDate)}',
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
              ProjectDetailScreen.routeName,
              arguments: data.id,
            );
          },
        ),
      ),
    );
  }
}
