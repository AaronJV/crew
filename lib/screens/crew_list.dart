import 'package:crew/models.dart';
import 'package:crew/screens/add_crew.dart';
import 'package:crew/widgets/crew_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CrewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crew List"),
        ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/space.jpg'),
                        fit: BoxFit.cover))),
            Container(
                color: Colors.grey.withAlpha(100),
                child: StreamBuilder<List<Crew>>(
                    stream: Provider.of<CrewDb>(context).watchCrews(),
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
          child: const Icon(Icons.add),
        ));
  }
}
