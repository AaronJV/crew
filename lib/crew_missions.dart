import 'package:crew/crew_type.dart';

class CrewMission {
  int? tasks;
  String text;
  String? other;
  List<String>? tiles;
  bool fivePlayerRule;

  CrewMission.fromJson(Map<String, dynamic> json)
      : text = json['text'] ?? '',
        fivePlayerRule = json['fivePlayerRule'] ?? false,
        tasks = json['tasks'],
        other = json['other'] {
    if (json['tiles'] != null) {
      tiles = [for (var tile in json['tiles']) tile.toString()];
    }
  }
}

class CrewMissions {
  Map<CrewTypes, Map<int, CrewMission>> _missionDetails = Map();

  CrewMissions.empty();

  CrewMissions.fromJsons(Map<CrewTypes, Map<String, dynamic>> jsons) {
    jsons.forEach((crewType, json) {
      var details = Map<int, CrewMission>();
      json.forEach((k, v) {
        var intKey = int.tryParse(k);
        if (intKey != null) {
          details[intKey] = CrewMission.fromJson(v);
        }
      });
      _missionDetails[crewType] = details;
    });
  }

  bool usesFivePlayerRule(int missionId, CrewTypes? crewType) {
    return _missionDetails[crewType ?? CrewTypes.Space]?[missionId]
            ?.fivePlayerRule ??
        false;
  }

  String getMissionText(int missionId, CrewTypes? crewType) {
    return _missionDetails[crewType ?? CrewTypes.Space]?[missionId]?.text ??
        'Mission Not found';
  }

  CrewMission? getMission(int missionId, CrewTypes? crewType) {
    return _missionDetails[crewType ?? CrewTypes.Space]?[missionId];
  }

  int getMaxMission(CrewTypes? crewType) {
    return _missionDetails[crewType ?? CrewTypes.Space]
            ?.keys
            .reduce((a, b) => a > b ? a : b) ??
        -1;
  }
}
