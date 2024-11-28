import 'package:crew/crew_quests.dart';
import 'package:flutter/material.dart';

class MissionMarker extends StatelessWidget {
  final int missionId;
  final double size;

  const MissionMarker({super.key, this.missionId = 0, this.size = 30});

  @override
  Widget build(BuildContext context) {
    var quest = CrewQuests.of(context);
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 5),
        height: size,
        width: size,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: quest.usesFivePlayerRule(missionId)
                    ? const AssetImage('assets/images/mission-marker-gold.png')
                    : const AssetImage('assets/images/mission-marker.png'))),
        child: Text(
          quest.getMissionLabel(missionId),
          style: TextStyle(color: Colors.white, fontSize: size / 3),
        ));
  }
}
