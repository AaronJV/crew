import 'package:crew/crew_quests.dart';
import 'package:crew/datastore.dart';
import 'package:crew/screens/add_crew.dart';
import 'package:crew/widgets/crew_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crew List"),
          actions: [
            PopupMenuButton<String>(
                onSelected: (String quest) =>
                    CrewQuests.of(context).changeQuest(quest),
                itemBuilder: (context) => CrewQuests.of(context)
                    .quests
                    .map((quest) => PopupMenuItem<String>(
                          child: Text(quest.name),
                          value: quest.id,
                          enabled:
                              CrewQuests.of(context).selectedQuest != quest.id,
                        ))
                    .toList())
          ],
        ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            CrewQuests.of(context).getTheme().backgroundAsset),
                        fit: BoxFit.cover))),
            Container(
                child: StreamBuilder<List<Crew>>(
                    stream: Provider.of<CrewDb>(context).watchCrews(
                        quest: CrewQuests.of(context).selectedQuest),
                    builder: (context, snapshot) => ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) =>
                            CrewContainer(crew: snapshot.data![index]))))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddCrew.routeName);
          },
          child: const Icon(Icons.group_add),
        ));
  }
}
