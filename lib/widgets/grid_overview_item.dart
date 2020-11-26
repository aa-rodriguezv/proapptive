import 'package:flutter/material.dart';

class GridOverviewItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String description;
  final double points;
  final Color titleColor;
  final Color footerColor;

  const GridOverviewItem({
    this.imagePath,
    this.name,
    this.description,
    this.points,
    this.titleColor,
    this.footerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 6.0, right: 6.0, bottom: 6.0),
            child: Image.asset(
              imagePath,
              height: 100,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: titleColor),
                    ),
                    Divider(),
                    Text(
                      description,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Gana: ${points.toInt()} puntos',
                      style: Theme.of(context)
                          .textTheme
                          .overline
                          .copyWith(color: footerColor),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
