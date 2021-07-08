import 'package:crew/crew_missions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MissionMarker extends StatelessWidget {
  final int missionId;
  final double size;

  MissionMarker({this.missionId = 0, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 5),
        height: size,
        width: size,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: Provider.of<CrewMissions>(context)
                        .usesFivePlayerRule(missionId)
                    ? AssetImage('assets/images/mission-marker-gold.png')
                    : AssetImage('assets/images/mission-marker.png'))),
        child: Text(
          missionId.toString(),
          style: TextStyle(color: Colors.white, fontSize: size / 3),
        ));
  }
}
