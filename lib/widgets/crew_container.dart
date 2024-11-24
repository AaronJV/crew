import 'package:crew/crew_quests.dart';
import 'package:crew/datastore.dart';
import 'package:crew/screens/add_crew.dart';
import 'package:crew/screens/missions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CrewContainer extends StatelessWidget {
  final Crew crew;

  const CrewContainer({super.key, required this.crew});

  Widget _crewLabel(BuildContext context) {
    if (crew.name == null) {
      return Text('CREW:', style: Theme.of(context).textTheme.displayLarge);
    }

    return Row(children: [
      Text('CREW:', style: Theme.of(context).textTheme.displayLarge),
      const Padding(padding: EdgeInsets.only(left: 10)),
      Text(crew.name!)
    ]);
  }

  Widget _crewStats(BuildContext context) {
    var db = Provider.of<CrewDb>(context);
    var maxMission = CrewQuests.of(context).getMaxMission();
    createRow<T>(
            {required String label,
            required Stream<T?> stream,
            String placeholder = '',
            required String Function(T data) formatter}) =>
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(width: 10),
            StreamBuilder(
              builder: (context, AsyncSnapshot<T?> snapshot) => Text(
                  snapshot.data != null
                      ? formatter(snapshot.data as T)
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
    return GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, Missions.routeName, arguments: crew),
        onLongPress: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Edit or Delete Crew?"),
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.white, width: 2),
                    color: const Color.fromARGB(0xFF, 235, 235, 235),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 0.5,
                          offset: Offset(2, 2))
                    ]),
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    alignment: Alignment.topLeft,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _crewLabel(context),
                          StaggeredGrid.count(
                            // physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            // padding: EdgeInsets.symmetric(
                            //     vertical: 10, horizontal: 5),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            children: crew.members
                                .map((member) => _CrewMemberLabel(member))
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

  const _CrewMemberLabel(this.crewMember);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(
                color: const Color.fromARGB(255, 199, 200, 202), width: 2),
            color: Colors.white),
        child: Text(crewMember));
  }
}
