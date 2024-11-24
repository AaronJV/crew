import 'package:crew/crew_quests.dart';
import 'package:flutter/material.dart';

class MissionMarker extends StatelessWidget {
  final int missionId;
  final double size;

  const MissionMarker({super.key, this.missionId = 0, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 5),
        height: size,
        width: size,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CrewQuests.of(context).usesFivePlayerRule(missionId)
                    ? const AssetImage('assets/images/mission-marker-gold.png')
                    : const AssetImage('assets/images/mission-marker.png'))),
        child: Text(
          missionId.toString(),
          style: TextStyle(color: Colors.white, fontSize: size / 3),
        ));
  }
}
