import 'dart:convert';

import 'package:crew/crew_missions.dart';
import 'package:crew/screens/add_crew.dart';
import 'package:crew/screens/crew_list.dart';
import 'package:crew/screens/missions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CrewDb>(create: (_) => CrewDb()),
        FutureProvider<CrewMissions>(
            initialData: null,
            create: (_) async {
              final data =
                  await rootBundle.loadString('assets/json/missions.json');
              return CrewMissions.fromJson(jsonDecode(data));
            },
            lazy: false)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => CrewList(),
          AddCrew.routeName: (_) => AddCrew(),
          Missions.routeName: (_) => Missions()
        },
      ),
    );
  }
}
