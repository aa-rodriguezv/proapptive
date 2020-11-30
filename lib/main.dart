import 'package:flutter/material.dart';
import 'package:proapptive/providers/auth.dart';
import 'package:proapptive/providers/projects_provider.dart';
import 'package:proapptive/providers/tasks_provider.dart';
import 'package:proapptive/screens/achievements_screen.dart';
import 'package:proapptive/screens/auth_screen.dart';
import 'package:proapptive/screens/awards_screen.dart';
import 'package:proapptive/screens/project_detail_screen.dart';
import 'package:proapptive/screens/project_overview_screen.dart';
import 'package:proapptive/screens/splash_screen.dart';
import 'package:proapptive/screens/tasks_complete_overview_screen.dart';
import 'package:proapptive/screens/tasks_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, TasksProvider>(
          create: (context) => TasksProvider(
            '',
            '',
            [],
          ),
          update: (context, auth, previous) => TasksProvider(
            auth.token,
            auth.userId,
            previous.tasks,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, ProjectsProvider>(
          create: (context) => ProjectsProvider(
            '',
            '',
            [],
          ),
          update: (context, auth, previous) => ProjectsProvider(
            auth.token,
            auth.userId,
            previous.tasks,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, snapshot) => MaterialApp(
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
              headline2: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 15,
                fontWeight: FontWeight.normal,
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
              headline3: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              headline4: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 10,
              ),
              headline5: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrangeAccent[700],
              ),
              headline6: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          home: auth.isAuth
              ? TasksOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      (snapshot.connectionState == ConnectionState.waiting)
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            AchievementsScreen.routeName: (ctx) => AchievementsScreen(),
            AwardsScreen.routeName: (ctx) => AwardsScreen(),
            TasksCompleteOverviewScreen.routeName: (ctx) =>
                TasksCompleteOverviewScreen(),
            ProjectsOverviewScreen.routeName: (ctx) => ProjectsOverviewScreen(),
            ProjectDetailScreen.routeName: (ctx) => ProjectDetailScreen(),
          },
        ),
      ),
    );
  }
}
