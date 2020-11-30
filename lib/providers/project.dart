import 'package:flutter/cupertino.dart';

class Project with ChangeNotifier {
  final String id;
  final String name;
  final DateTime creationDate;
  final DateTime terminationDate;
  final String creatorID;
  bool done;
  bool assignedTo;

  Project({
    @required this.id,
    @required this.name,
    @required this.creationDate,
    @required this.terminationDate,
    @required this.creatorID,
    this.done = false,
    this.assignedTo = false,
  });
}
