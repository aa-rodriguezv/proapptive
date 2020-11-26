import 'package:flutter/material.dart';
import 'package:proapptive/widgets/main_drawer.dart';

class TasksOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principal'),
      ),
      drawer: MainDrawer(),
    );
  }
}
