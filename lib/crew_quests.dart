import 'package:crew/crew_theme.dart';
import 'package:flutter/widgets.dart';

enum CommunicationType { DEAD_ZONE, NONE, UNFAMILIAR_TERRAIN, RAPTURE_OF_DEEP }

class CrewMission {
  int? tasks;
  String text;
  String? other;
  List<String>? tiles;
  bool fivePlayerRule;
  CommunicationType? commType;

  CrewMission.fromJson(Map<String, dynamic> json)
      : text = json['text'] ?? '',
        fivePlayerRule = json['fivePlayerRule'] ?? false,
        tasks = json['tasks'],
        other = json['other'] {
    if (json['tiles'] != null) {
      tiles = [for (var tile in json['tiles']) tile.toString()];
    }
    if (json['communication'] != null) {
      var value = json['communication'].toString().toUpperCase();
      for (var type in CommunicationType.values) {
        if (type.toString() == 'CommunicationType.' + value) {
          commType = type;
          break;
        }
      }
    }
  }
}

enum QuestTheme { SPACE, OCEAN }

QuestTheme parseQuestTheme(String value) {
  if (value.toUpperCase() == "OCEAN") {
    return QuestTheme.OCEAN;
  }

  return QuestTheme.SPACE;
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

  CrewQuests(
      {required this.quests,
      required this.selectedQuest,
      required Widget child,
      required void Function(String) changeQuest})
      : _changeQuest = changeQuest,
        super(child: child);

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
  }

  int getMaxMission() {
    return _getSelectedQuest()?.missions.length ?? -1;
  }

  changeQuest(String quest) {
    _changeQuest(quest);
  }

  CrewTheme getTheme() {
    switch (_getSelectedQuest()?.theme) {
      case QuestTheme.OCEAN:
        return CrewTheme.getOceanTheme();
      case QuestTheme.SPACE:
      default:
        return CrewTheme.getSpaceTheme();
    }
  }

  CrewMission? getMission(int missionId) {
    var quest = _getSelectedQuest();

    if (quest != null) {
      return quest.missions.length >= missionId
          ? quest.missions[missionId - 1]
          : null;
    }
  }

  bool usesFivePlayerRule(int missionId) {
    return getMission(missionId)?.fivePlayerRule ?? false;
  }
}
