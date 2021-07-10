import 'dart:convert';

import 'package:crew/crew_missions.dart';
import 'package:crew/crew_type.dart';
import 'package:crew/screens/add_crew.dart';
import 'package:crew/screens/crew_list.dart';
import 'package:crew/screens/missions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models.dart';

void main() {
  runApp(CrewApp());
}

class CrewApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CrewAppState();
}

class CrewAppState extends State<StatefulWidget> {
  var crewType = CrewTypes.Space;

  void setTheme(CrewTypes type) {
    setState(() {
      crewType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CrewDb>(create: (_) => CrewDb()),
        FutureProvider<CrewMissions>(
            initialData: CrewMissions.empty(),
            create: (_) async {
              final spaceData = await rootBundle
                  .loadString('assets/json/space-missions.json');
              final seaData =
                  await rootBundle.loadString('assets/json/sea-missions.json');
              return CrewMissions.fromJsons({
                CrewTypes.Space: jsonDecode(spaceData),
                CrewTypes.Deep_Sea: jsonDecode(seaData)
              });
            },
            lazy: false),
      ],
      child: CrewType(
        crewType: crewType,
        changeType: (type) => setState(() => crewType = type),
        child: Builder(
          builder: (context) => MaterialApp(
            title: 'Flutter Demo',
            theme: CrewTheme.of(context).getThemeData(),
            initialRoute: '/',
            onGenerateRoute: (RouteSettings settings) {
              var routes = <String, WidgetBuilder>{
                '/': (_) => CrewList(),
                AddCrew.routeName: (_) => AddCrew(settings.arguments as Crew?),
                Missions.routeName: (_) => Missions(settings.arguments as Crew),
              };
              var builder = routes[settings.name]!;
              return MaterialPageRoute(builder: (ctx) => builder(ctx));
            },
          ),
        ),
      ),
    );
  }
}
