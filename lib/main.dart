import 'dart:convert';
import 'package:crew/crew_quests.dart';
import 'package:crew/screens/add_crew.dart';
import 'package:crew/screens/crew_list.dart';
import 'package:crew/screens/missions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models.dart';

Future<List<CrewQuest>> loadMissions() async {
  WidgetsFlutterBinding.ensureInitialized();

  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  final missionFiles = manifestMap.keys
      .where((String key) => key.contains('missions/'))
      .where((String key) => key.contains('.json'))
      .toList();

  List<CrewQuest> list = [];

  for (var file in missionFiles) {
    var data = await rootBundle.loadString(file);
    list.add(CrewQuest.fromJson(json.decode(data)));
  }

  return list;
}

Future<void> main() async {
  var quests = await loadMissions();
  runApp(CrewApp(quests));
}

class CrewApp extends StatefulWidget {
  final List<CrewQuest> quests;

  CrewApp(this.quests);

  @override
  State<StatefulWidget> createState() => CrewAppState(quests);
}

class CrewAppState extends State<StatefulWidget> {
  List<CrewQuest> quests;
  String selectedQuest = 'planetNine';

  CrewAppState(this.quests);

  @override
  Widget build(BuildContext context) {
    return Provider<CrewDb>(
      create: (_) => CrewDb(),
      child: CrewQuests(
        quests: this.quests,
        changeQuest: (questId) => setState(() => selectedQuest = questId),
        selectedQuest: selectedQuest,
        child: Builder(
          builder: (context) => MaterialApp(
            title: 'Flutter Demo',
            theme: CrewQuests.of(context).getTheme().getThemeData(),
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
