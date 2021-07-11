import 'package:crew/crew_quests.dart';
import 'package:crew/models.dart';
import 'package:crew/widgets/mission_details.dart';
import 'package:crew/widgets/mission_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Missions extends StatelessWidget {
  static const routeName = '/missions';
  final Crew crew;

  Missions(this.crew);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CrewQuests.of(context).getTheme().missionBackgound,
        appBar: AppBar(
          title: Text("Missions"),
        ),
        body: Column(children: [
          StreamBuilder(
              stream: Provider.of<CrewDb>(context).getCurtentMission(crew.id),
              builder: (_, AsyncSnapshot<MissionAttempt> snapshot) =>
                  MissionDetails(snapshot)),
          Divider(
              thickness: 2,
              height: 0,
              color:
                  CrewQuests.of(context).getTheme().missionBackgroundAlternate),
          StreamBuilder(
            stream: Provider.of<CrewDb>(context).getCompletedMissions(crew.id),
            builder: (context, AsyncSnapshot<List<MissionAttempt>> snapshot) =>
                Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) =>
                      _CompletedMission(snapshot.data![index])),
            ),
          )
        ]));
  }
}

class _CompletedMission extends StatelessWidget {
  final MissionAttempt missionAttempt;

  _CompletedMission(this.missionAttempt);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: missionAttempt.id % 2 == 0
                ? CrewQuests.of(context).getTheme().missionBackgound
                : CrewQuests.of(context).getTheme().missionBackgroundAlternate),
        child: Row(children: [
          MissionMarker(missionId: missionAttempt.id, size: 30),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
                'Completed on ${DateFormat.yMMMMd('en_US').format(missionAttempt.completionDate!)}\n' +
                    'After ${missionAttempt.attempts} attempt${missionAttempt.attempts > 1 ? "s" : ""}'),
          ),
        ]));
  }
}
