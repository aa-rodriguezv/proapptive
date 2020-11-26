import 'package:flutter/material.dart';
import 'package:proapptive/models/achievement.dart';
import 'package:proapptive/widgets/grid_overview_item.dart';
import 'package:proapptive/widgets/main_drawer.dart';

class AchievementsScreen extends StatelessWidget {
  static const routeName = '/achievements';

  final List<Achievement> data = Achievement.achievementDummies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logros'),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              child: Text(
                'Logros del Cargo',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (ctx, index) => GridOverviewItem(
                  description: data[index].description,
                  titleColor: Colors.green,
                  footerColor: Colors.greenAccent,
                  imagePath: data[index].imagePath,
                  name: data[index].name,
                  points: data[index].gainPoints,
                ),
                itemCount: data.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
