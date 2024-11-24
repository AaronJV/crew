import 'dart:math';

import 'package:collapsible/collapsible.dart';
import 'package:confetti/confetti.dart';
import 'package:crew/crew_quests.dart';
import 'package:crew/datastore.dart';
import 'package:crew/widgets/mission_marker.dart';
import 'package:crew/widgets/mission_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MissionDetails extends StatefulWidget {
  final AsyncSnapshot<MissionAttempt> snapshot;

  const MissionDetails(this.snapshot, {super.key});

  @override
  State<MissionDetails> createState() => MissionDetailsState();
}

class MissionDetailsState extends State<MissionDetails> {
  bool _collapsedMission = true;
  late ConfettiController _confettiController;
  OverlayEntry? _entry;

  MissionDetailsState() {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.stop();
    _entry?.remove();

    super.dispose();
  }

  void playConfetti() {
    if (_entry == null) {
      makeWidget(double dir) => ConfettiWidget(
            confettiController: _confettiController,
            numberOfParticles: 30,
            blastDirection: dir,
          );
      _entry = OverlayEntry(
          builder: (context) => Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: makeWidget(pi / 4),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: makeWidget(3 * pi / 4),
                  ),
                ],
              ));
      Overlay.of(context).insert(_entry!);
    }
    setState(() => _confettiController.play());
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.snapshot.hasData) {
      return const SizedBox();
    }

    var missionAttempt = widget.snapshot.data!;
    final missionDetails = CrewQuests.of(context);
    final maxMission = missionDetails.getMaxMission();

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (missionAttempt.id <= maxMission) {
              setState(() => _collapsedMission = !_collapsedMission);
            } else {
              playConfetti();
            }
          },
          onDoubleTap: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Reset to last mission?',
                textAlign: TextAlign.center,
              ),
              content: Text(
                  'Reset the current mission back to mission ${missionAttempt.id - 1}',
                  textAlign: TextAlign.center),
              actions: [
                TextButton(
                    onPressed: () => Provider.of<CrewDb>(context, listen: false)
                        .resetMission(missionAttempt)
                        .then((value) => Navigator.of(context).pop()),
                    child: const Text('Reset'))
              ],
            ),
          ),
          child: MissionMarker(
              size: 125,
              missionId: missionAttempt.id <= maxMission
                  ? missionAttempt.id
                  : maxMission),
        ),
        Collapsible(
            collapsed: _collapsedMission,
            axis: CollapsibleAxis.vertical,
            child: _CurrentMissionDetails(
                missionDetails.getMission(missionAttempt.id))),
        missionAttempt.id <= maxMission
            ? Text('Attempt number: ${missionAttempt.attempts}')
            : const SizedBox(),
        missionAttempt.id <= maxMission
            ? _MissionActions(missionAttempt)
            : const SizedBox()
      ],
    );
  }
}

class _MissionActions extends StatelessWidget {
  static const double _buttonSize = 75;
  final MissionAttempt missionAttempt;

  const _MissionActions(this.missionAttempt);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        GestureDetector(
            onTap: () => Provider.of<CrewDb>(context, listen: false)
                .recordMissionSuccess(missionAttempt),
            child: Container(
                height: _buttonSize,
                width: _buttonSize,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(CrewQuests.of(context)
                            .getTheme()
                            .passMarkerAsset))))),
        GestureDetector(
          onTap: () => Provider.of<CrewDb>(context, listen: false)
              .recordMissionFailure(missionAttempt),
          child: Container(
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          CrewQuests.of(context).getTheme().failMarkerAsset)))),
        )
      ]),
    );
  }
}

class _CurrentMissionDetails extends StatelessWidget {
  final CrewMission? _details;

  const _CurrentMissionDetails(this._details);

  Widget createTiles() {
    if (_details?.tiles == null) {
      return const SizedBox();
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _details!.tiles!
            .map((tile) => Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 0.5,
                          offset: Offset(2, 2))
                    ]),
                width: 30,
                height: 30,
                child: Stack(children: [
                  Text(tile,
                      style: TextStyle(
                          fontSize: 20,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(tile,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF572E91),
                          fontWeight: FontWeight.bold))
                ])))
            .toList());
  }

  Widget commModifiedWidget(BuildContext context) {
    var text = _details!.commType == CommunicationType.deadZone ? '?' : '-2';

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Row(
          children: [
            const SizedBox(width: 45),
            Container(
              width: 30,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(Radius.elliptical(30, 50)),
                  gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0),
                    Colors.white,
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    CrewQuests.of(context).getTheme().passMarkerAsset),
                fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget createRealtimeWidget() {
    if (_details?.realTimeData == null) {
      return const SizedBox();
    }

    return MissionTimer(_details!.realTimeData!.seconds);
  }

  Widget createTasksMarker(BuildContext context) {
    var tasksMarker = CrewQuests.of(context)
        .getTheme()
        .getTasksWidget(context, _details?.tasks);

    if (_details?.commType == CommunicationType.deadZone ||
        _details?.commType == CommunicationType.raptureOfTheDeep) {
      tasksMarker = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          tasksMarker,
          const SizedBox(width: 20),
          commModifiedWidget(context),
        ],
      );
    } else if (_details?.commType == CommunicationType.none ||
        _details?.commType == CommunicationType.unfamiliarTerrain) {
      var icon = _details?.commType == CommunicationType.none
          ? Icons.hide_source
          : Icons.help_outline;
      tasksMarker = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          tasksMarker,
          const SizedBox(width: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          CrewQuests.of(context).getTheme().passMarkerAsset),
                      fit: BoxFit.cover),
                ),
              ),
              Icon(
                icon,
                color: Colors.red,
                size: 50,
              ),
            ],
          )
        ],
      );
    }

    if (_details?.realTimeData != null) {
      if (tasksMarker is Row) {
        tasksMarker.children.addAll([
          const SizedBox(
            width: 10,
          ),
          createRealtimeWidget(),
        ]);
      } else {
        tasksMarker = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tasksMarker,
            const SizedBox(
              width: 10,
            ),
            createRealtimeWidget()
          ],
        );
      }
    }

    return tasksMarker;
  }

  @override
  Widget build(BuildContext context) {
    if (_details == null) {
      return const Text(
        'Mission Not Found',
        textAlign: TextAlign.center,
      );
    }
    return Column(
      children: [
        createTasksMarker(context),
        createTiles(),
        _details.other != null
            ? Text(
                '${_details.other!}\n',
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            : const SizedBox(),
        Text(
          _details.text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
