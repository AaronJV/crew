import 'package:crew/models.dart';
import 'package:crew/widgets/mission_details.dart';
import 'package:crew/widgets/mission_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class _MissionColors {
  static const base = Color.fromRGBO(0xE6, 0xE3, 0xD8, 1);
  static const alternate = Color.fromRGBO(0xCF, 0xc9, 0xB3, 1);
}

class Missions extends StatelessWidget {
  static const routeName = '/missions';

  @override
  Widget build(BuildContext context) {
    final crew = ModalRoute.of(context)?.settings.arguments as Crew;

    return Scaffold(
        backgroundColor: _MissionColors.base,
        appBar: AppBar(
          title: Text("Missions"),
        ),
        body: Column(children: [
          StreamBuilder(
              stream: Provider.of<CrewDb>(context).getCurtentMission(crew.id),
              builder: (_, AsyncSnapshot<MissionAttempt> snapshot) => MissionDetails(snapshot)),
          Divider(thickness: 2, height: 0, color: _MissionColors.alternate),
          StreamBuilder(
            stream: Provider.of<CrewDb>(context).getCompletedMissions(crew.id),
            builder: (context, AsyncSnapshot<List<MissionAttempt>> snapshot) => Expanded(
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
                ? _MissionColors.base
                : _MissionColors.alternate),
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
