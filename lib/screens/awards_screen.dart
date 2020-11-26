import 'package:flutter/material.dart';
import 'package:proapptive/models/award.dart';
import 'package:proapptive/screens/achievements_screen.dart';
import 'package:proapptive/widgets/grid_overview_item.dart';
import 'package:proapptive/widgets/main_drawer.dart';

class AwardsScreen extends StatelessWidget {
  static const routeName = '/awards';

  final List<Award> data = Award.awardDummies;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recompensas'),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Column(
                children: [
                  Text(
                    'Redime tus Puntos',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            'Puntos disponibles: ',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Spacer(),
                          Text(
                            '1500 puntos',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.green),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.control_point,
                              color: Colors.green,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).popAndPushNamed(
                                  AchievementsScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                  titleColor: Colors.deepOrange,
                  footerColor: Colors.deepOrangeAccent,
                  imagePath: data[index].imagePath,
                  name: data[index].name,
                  points: data[index].requiredPoints,
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
