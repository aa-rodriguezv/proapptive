import 'package:flutter/material.dart';
import 'package:proapptive/providers/auth.dart';
import 'package:proapptive/screens/achievements_screen.dart';
import 'package:proapptive/screens/awards_screen.dart';
import 'package:proapptive/screens/project_overview_screen.dart';
import 'package:proapptive/screens/tasks_complete_overview_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildPageAccess(
      BuildContext context, IconData icon, String title, String routeName,
      {bool logout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        tileColor: Colors.grey[100],
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.caption,
        ),
        onTap: () {
          Navigator.of(context).popAndPushNamed(routeName);
          if (logout) {
            Provider.of<Auth>(context, listen: false).logout();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Gestiona'),
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: 20),
          _buildPageAccess(
            context,
            Icons.home_work,
            'Proapptive',
            '/',
          ),
          _buildPageAccess(
            context,
            Icons.featured_play_list,
            'Tareas',
            TasksCompleteOverviewScreen.routeName,
          ),
          _buildPageAccess(
            context,
            Icons.card_membership,
            'Proyectos',
            ProjectsOverviewScreen.routeName,
          ),
          _buildPageAccess(
            context,
            Icons.list_alt,
            'Logros',
            AchievementsScreen.routeName,
          ),
          _buildPageAccess(
            context,
            Icons.local_activity,
            'Recompensas',
            AwardsScreen.routeName,
          ),
          Divider(),
          _buildPageAccess(
            context,
            Icons.exit_to_app_outlined,
            'Cerrar Sesión',
            '/',
            logout: true,
          ),
        ],
      ),
    );
  }
}
