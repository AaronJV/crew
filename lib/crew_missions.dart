class CrewMission {
  int tasks;
  String text;
  String other;
  List<String> tiles;
  bool fivePlayerRule;

  CrewMission.fromJson(Map<String, dynamic> json) {
    tasks = json['tasks'];
    text = json['text'];
    other = json['other'];
    fivePlayerRule = json['fivePlayerRule'] ?? false;
    if (json['tiles'] != null) {
      tiles = [for (var tile in json['tiles']) tile.toString()];
    }
  }
}

class CrewMissions {
  Map<int, CrewMission> _missionDetails;

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
    return _missionDetails.containsKey(missionId)
        ? _missionDetails[missionId].fivePlayerRule
        : false;
  }

  String getMissionText(int missionId) {
    return _missionDetails.containsKey(missionId)
        ? _missionDetails[missionId].text
        : 'Mission Not found';
  }

  CrewMission getMission(int missionId) {
    return _missionDetails.containsKey(missionId)
        ? _missionDetails[missionId]
        : null;
  }

  int getMaxMission() {
    return _missionDetails.keys.reduce((a, b) => a > b ? a : b);
  }
}
