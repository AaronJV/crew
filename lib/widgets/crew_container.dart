import 'package:crew/crew_quests.dart';
import 'package:crew/models.dart';
import 'package:crew/screens/add_crew.dart';
import 'package:crew/screens/missions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CrewContainer extends StatelessWidget {
  final Crew crew;

  CrewContainer({required this.crew});

  Widget _crewLabel(BuildContext context) {
    if (crew.name == null) {
      return Container(
          child: Text('CREW:', style: Theme.of(context).textTheme.headline5));
    }

    return Container(
        child: Row(children: [
      Text('CREW:', style: Theme.of(context).textTheme.headline5),
      Padding(padding: EdgeInsets.only(left: 10)),
      Text(crew.name!)
    ]));
  }

  Widget _crewStats(BuildContext context) {
    var db = Provider.of<CrewDb>(context);
    var maxMission = CrewQuests.of(context).getMaxMission();
    var createRow = <T>(
            {required String label,
            required Stream<T?> stream,
            String placeholder = '',
            required String Function(T data) formatter}) =>
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(width: 10),
            StreamBuilder(
              builder: (context, AsyncSnapshot<T?> snapshot) => Text(
                  snapshot.data != null
                      ? formatter(snapshot.data!)
                      : placeholder),
              stream: stream,
            ),
          ],
        );

    return Column(children: [
      createRow<DateTime>(
        label: 'Start Date:',
        stream: db.getStartDate(crew.id),
        placeholder: 'First Mission is not completed',
        formatter: (date) => DateFormat.yMMMMd('en_US').format(date),
      ),
      createRow<int>(
          label: 'Current Mission:',
          stream: db.getCurrentMission(crew.id),
          formatter: (data) =>
              data <= maxMission ? data.toString() : 'All missions completed!')
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, Missions.routeName, arguments: crew),
        onLongPress: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Edit or Delete Crew?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, AddCrew.routeName,
                          arguments: crew);
                    },
                    child: const Text('Edit Crew'),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<CrewDb>(context, listen: false)
                          .deleteCrew(crew.id)
                          .then((_) => Navigator.of(context).pop());
                    },
                    child: const Text('Delete Crew'),
                  )
                ],
              ),
            ),
        child: Stack(
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.white, width: 2),
                    color: Color.fromARGB(0xFF, 235, 235, 235),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 0.5,
                          offset: Offset(2, 2))
                    ]),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    alignment: Alignment.topLeft,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _crewLabel(context),
                          StaggeredGridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            children: crew.members
                                .map((member) => _CrewMemberLabel(member))
                                .toList(),
                            staggeredTiles: crew.members
                                .map((member) => StaggeredTile.fit(1))
                                .toList(),
                          ),
                          _crewStats(context)
                        ])))
          ],
        ));
  }
}

class _CrewMemberLabel extends StatelessWidget {
  final String crewMember;

  _CrewMemberLabel(this.crewMember);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border:
                Border.all(color: Color.fromARGB(255, 199, 200, 202), width: 2),
            color: Colors.white),
        child: Text(crewMember));
  }
}
