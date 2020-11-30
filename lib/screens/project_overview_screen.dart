import 'package:flutter/material.dart';
import 'package:proapptive/providers/projects_provider.dart';
import 'package:proapptive/widgets/main_drawer.dart';
import 'package:proapptive/widgets/project_overview_item.dart';
import 'package:provider/provider.dart';

class ProjectsOverviewScreen extends StatefulWidget {
  static const routeName = 'projects';

  @override
  _ProjectsOverviewScreenState createState() => _ProjectsOverviewScreenState();
}

class _ProjectsOverviewScreenState extends State<ProjectsOverviewScreen> {
  bool _isInit = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );
      Provider.of<ProjectsProvider>(context).fetchAndSetProjects().then(
        (_) {
          setState(
            () {
              _isLoading = false;
            },
          );
        },
      );
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProjectsProvider>(context).myProjects;

    return Scaffold(
      appBar: AppBar(
        title: Text('Proyectos'),
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () =>
                  Provider.of<ProjectsProvider>(context, listen: false)
                      .fetchAndSetProjects(),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Mis Proyectos',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (ctx, i) {
                          return ChangeNotifierProvider.value(
                            value: data[i],
                            child: ProjectOverviewItem(),
                          );
                        },
                        itemCount: data.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
