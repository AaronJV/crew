import 'package:crew/crew_theme.dart';
import 'package:flutter/widgets.dart';

enum CommunicationType { deadZone, none, unfamiliarTerrain, raptureOfTheDeep }

CommunicationType parseCommunicationType(String? value) {
  if (value == null) {
    return CommunicationType.none;
  }

  value = value.toString().toUpperCase();
  for (var type in CommunicationType.values) {
    if (type.toString() == 'CommunicationType.$value') {
      return type;
    }
  }

  return CommunicationType.none;
}

class RealTimeMissionData {
  int seconds;
  CommunicationType alternative;

  RealTimeMissionData({required this.seconds, required this.alternative});
}

class CrewMission {
  int? tasks;
  String text;
  String? other;
  List<String>? tiles;
  bool fivePlayerRule;
  CommunicationType? commType;
  RealTimeMissionData? realTimeData;

  CrewMission.fromJson(Map<String, dynamic> json)
      : text = json['text'] ?? '',
        fivePlayerRule = json['fivePlayerRule'] ?? false,
        tasks = json['tasks'],
        other = json['other'] {
    if (json['tiles'] != null) {
      tiles = [for (var tile in json['tiles']) tile.toString()];
    }
    commType = parseCommunicationType(json['communication']);

    if (json['realtime'] != null) {
      realTimeData = RealTimeMissionData(
          seconds: json['realtime']['time'],
          alternative:
              parseCommunicationType(json['realtime']['communication']));
    }
  }
}

enum QuestTheme { space, ocean }

QuestTheme parseQuestTheme(String value) {
  if (value.toUpperCase() == "OCEAN") {
    return QuestTheme.ocean;
  }

  return QuestTheme.space;
}

class CrewQuest {
  final List<CrewMission> missions = [];
  final String name;
  final QuestTheme theme;
  final String id;

  CrewQuest.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        theme = parseQuestTheme(json['theme']) {
    for (var missionJson in json['missions']) {
      missions.add(CrewMission.fromJson(missionJson));
    }
  }

  int getMaxMission() {
    return missions.length;
  }
}

class CrewQuests extends InheritedWidget {
  final String selectedQuest;
  final List<CrewQuest> quests;
  final void Function(String) _changeQuest;

  const CrewQuests(
      {super.key,
      required this.quests,
      required this.selectedQuest,
      required super.child,
      required void Function(String) changeQuest})
      : _changeQuest = changeQuest;

  static CrewQuests of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CrewQuests>()!;
  }

  @override
  bool updateShouldNotify(covariant CrewQuests oldWidget) {
    return selectedQuest != oldWidget.selectedQuest ||
        quests.length != oldWidget.quests.length;
  }

  CrewQuest? _getSelectedQuest() {
    for (var quest in quests) {
      if (quest.id == selectedQuest) {
        return quest;
      }
    }
    return null;
  }

  int getMaxMission() {
    return _getSelectedQuest()?.missions.length ?? -1;
  }

  changeQuest(String quest) {
    _changeQuest(quest);
  }

  CrewTheme getTheme() {
    if (_getSelectedQuest()?.theme == QuestTheme.ocean) {
      return CrewTheme.getOceanTheme();
    }
    return CrewTheme.getSpaceTheme();
  }

  CrewMission? getMission(int missionId) {
    var quest = _getSelectedQuest();

    if (quest != null) {
      return quest.missions.length >= missionId
          ? quest.missions[missionId - 1]
          : null;
    }
    return null;
  }

  bool usesFivePlayerRule(int missionId) {
    return getMission(missionId)?.fivePlayerRule ?? false;
  }
}
