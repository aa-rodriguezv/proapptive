import 'package:flutter/material.dart';
import 'package:proapptive/screens/achievements_screen.dart';
import 'package:proapptive/screens/awards_screen.dart';
import 'package:proapptive/screens/tasks_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.redAccent,
        fontFamily: 'Quicksand',
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
          bodyText1: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          bodyText2: TextStyle(
            fontSize: 8,
          ),
          overline: TextStyle(
            fontSize: 6,
            fontWeight: FontWeight.w700,
          ),
          caption: TextStyle(
            fontSize: 14,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: TasksOverviewScreen(),
      routes: {
        AchievementsScreen.routeName: (ctx) => AchievementsScreen(),
        AwardsScreen.routeName: (ctx) => AwardsScreen(),
      },
    );
  }
}
