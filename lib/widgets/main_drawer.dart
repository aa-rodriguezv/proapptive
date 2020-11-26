import 'package:flutter/material.dart';
import 'package:proapptive/screens/achievements_screen.dart';
import 'package:proapptive/screens/awards_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget _buildPageAccess(
      BuildContext context, IconData icon, String title, String routeName) {
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
            'Principal',
            '/',
          ),
          _buildPageAccess(
            context,
            Icons.list_alt_rounded,
            'Logros',
            AchievementsScreen.routeName,
          ),
          _buildPageAccess(
            context,
            Icons.local_activity,
            'Recompensas',
            AwardsScreen.routeName,
          ),
        ],
      ),
    );
  }
}
