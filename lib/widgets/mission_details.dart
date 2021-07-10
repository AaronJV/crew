import 'dart:math';

import 'package:collapsible/collapsible.dart';
import 'package:confetti/confetti.dart';
import 'package:crew/crew_missions.dart';
import 'package:crew/crew_type.dart';
import 'package:crew/models.dart';
import 'package:crew/widgets/mission_marker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MissionDetails extends StatefulWidget {
  final AsyncSnapshot<MissionAttempt> snapshot;

  MissionDetails(this.snapshot);

  @override
  State<MissionDetails> createState() => MissionDetailsState();
}

class MissionDetailsState extends State<MissionDetails> {
  bool _collapsedMission = true;
  late ConfettiController _confettiController;
  OverlayEntry? _entry;

  MissionDetailsState() {
    _confettiController = ConfettiController(duration: Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.stop();
    _entry?.remove();

    super.dispose();
  }

  void playConfetti() {
    if (_entry == null) {
      var makeWidget = (double dir) => ConfettiWidget(
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
      Overlay.of(context)?.insert(_entry!);
    }
    setState(() => _confettiController.play());
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.snapshot.hasData) {
      return SizedBox();
    }

    var missionAttempt = widget.snapshot.data!;
    final missionDetails = Provider.of<CrewMissions>(context);
    final maxMission =
        missionDetails.getMaxMission(CrewType.of(context)?.crewType);

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
            child: _CurrentMissionDetails(missionDetails.getMission(
                missionAttempt.id, CrewType.of(context)?.crewType))),
        missionAttempt.id <= maxMission
            ? Text('Attempt number: ${missionAttempt.attempts}')
            : SizedBox(),
        missionAttempt.id <= maxMission
            ? _MissionActions(missionAttempt)
            : SizedBox()
      ],
    );
  }
}

class _MissionActions extends StatelessWidget {
  static const double _buttonSize = 75;
  final MissionAttempt missionAttempt;

  _MissionActions(this.missionAttempt);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        GestureDetector(
            onTap: () => Provider.of<CrewDb>(context, listen: false)
                .recordMissionSuccess(missionAttempt),
            child: Container(
                height: _buttonSize,
                width: _buttonSize,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/pass-marker.png'))))),
        GestureDetector(
          onTap: () => Provider.of<CrewDb>(context, listen: false)
              .recordMissionFailure(missionAttempt),
          child: Container(
              height: _buttonSize,
              width: _buttonSize,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/fail-marker.png')))),
        )
      ]),
    );
  }
}

class _CurrentMissionDetails extends StatelessWidget {
  final CrewMission? _details;

  _CurrentMissionDetails(this._details);

  Widget createTiles() {
    if (_details?.tiles == null) {
      return SizedBox();
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _details!.tiles!
            .map((tile) => Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.black, boxShadow: [
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
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF572E91),
                          fontWeight: FontWeight.bold))
                ])))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    if (_details == null) {
      return Text(
        'Mission Not Found',
        textAlign: TextAlign.center,
      );
    }
    return Column(
      children: [
        CrewTheme.of(context).getTasksWidget(context, _details?.tasks),
        createTiles(),
        _details!.other != null ? Text(_details!.other!) : SizedBox(),
        Text(
          _details!.text,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
