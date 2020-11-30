import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:proapptive/providers/project.dart';
import 'package:http/http.dart' as http;

class ProjectsProvider with ChangeNotifier {
  String _token;
  String _userID;
  List<Project> _projects = [];

  ProjectsProvider(
    this._token,
    this._userID,
    this._projects,
  );

  List<Project> get tasks {
    return [..._projects];
  }

  List<Project> get myProjects {
    return tasks.where((element) => element.assignedTo).toList()
      ..sort(
        (a, b) => a.terminationDate.compareTo(b.terminationDate),
      );
  }

  Project getProjectByID(String id) {
    return tasks.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProjects() async {
    final url =
        'https://proapptive-a6824.firebaseio.com/projects.json?auth=$_token';
    try {
      final response = await http.get(url);
      final Map<String, dynamic> extractedData = json.decode(response.body);
      final List<Project> loadedProjects = [];
      if (extractedData == null) {
        return;
      }
      final favURL =
          'https://proapptive-a6824.firebaseio.com/userProjects/$_userID.json?auth=$_token';
      final favouriteResponse = await http.get(favURL);
      final extractedProjects = json.decode(favouriteResponse.body);
      extractedData.forEach(
        (key, value) {
          Project newProject = Project(
            id: key,
            creationDate: DateTime.parse(value['creationDate']),
            terminationDate: DateTime.parse(value['terminationDate']),
            creatorID: value['creatorID'],
            name: value['name'],
            assignedTo: extractedProjects == null
                ? false
                : extractedProjects[key] == null
                    ? false
                    : true,
            done: value['done'],
          );

          loadedProjects.add(newProject);
        },
      );
      _projects = loadedProjects;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
