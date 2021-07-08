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
  late Map<int, CrewMission> _missionDetails;

  CrewMissions.empty() {
    _missionDetails = Map();
  }

  CrewMissions.fromJson(Map<String, dynamic> json) {
    var details = Map<int, CrewMission>();
    json.forEach((k, v) {
      var intKey = int.tryParse(k);
      if (intKey != null) {
        details[intKey] = CrewMission.fromJson(v);
      }
    });
    _missionDetails = details;
  }

  bool usesFivePlayerRule(int missionId) {
    return _missionDetails[missionId]?.fivePlayerRule ?? false;
  }

  String getMissionText(int missionId) {
    return _missionDetails[missionId]?.text ?? 'Mission Not found';
  }

  CrewMission? getMission(int missionId) {
    return _missionDetails[missionId];
  }

  int getMaxMission() {
    return _missionDetails.keys.reduce((a, b) => a > b ? a : b);
  }
}
