import 'package:flutter/cupertino.dart';

class Project with ChangeNotifier {
  final String name;
  final DateTime creationDate;
  final DateTime terminationDate;
  DateTime doneDate;
  final String creatorEmail;
  final List<String> participantEmails;
  bool done;

  Project({
    @required this.name,
    @required this.creationDate,
    @required this.terminationDate,
    @required this.creatorEmail,
    @required this.participantEmails,
  });
}
