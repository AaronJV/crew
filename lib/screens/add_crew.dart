import 'package:crew/crew_type.dart';
import 'package:crew/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCrew extends StatefulWidget {
  static const routeName = '/add';
  final Crew? crew;

  AddCrew(this.crew);

  @override
  State<StatefulWidget> createState() {
    return AddCrewState(crew);
  }
}

class AddCrewState extends State<AddCrew> {
  final _formKey = GlobalKey<FormState>();
  var _names = {0: '', 1: '', 2: ''};
  var _count = 3;
  var _crewNameController = TextEditingController();
  int? _crewId;

  AddCrewState(Crew? crew) {
    if (crew != null) {
      _crewId = crew.id;
      _names = Map.from(crew.members.asMap());
      if (crew.name != null) {
        _crewNameController.value = TextEditingValue(text: crew.name!);
      }
    }
  }

  addCrewMember() {
    if (_names.length < 5) {
      setState(() {
        _names[_count++] = '';
      });
    }
  }

  removeCrewMember(id) {
    setState(() {
      _names.remove(id);
    });
  }

  updateCrewMember(id, value) {
    setState(() {
      if (_names.containsKey(id)) {
        _names[id] = value;
      }
    });
  }

  void saveCrew(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      var db = Provider.of<CrewDb>(context, listen: false);
      if (_crewId != null) {
        db
            .updateCrew(_crewId,
                members: _names.values.toList(), name: _crewNameController.text)
            .then((_) => Navigator.pop(context))
            .onError((error, stackTrace) => null);
      } else {
        db
            .addCrew(
                members: _names.values.toList(),
                name: _crewNameController.text,
                crewType: CrewType.of(context)?.crewType)
            .then((_) => Navigator.pop(context))
            .onError((error, stackTrace) => null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Crew'),
        actions: _names.length < 5
            ? [
                IconButton(
                    icon: Icon(Icons.person_add), onPressed: addCrewMember)
              ]
            : null,
      ),
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(CrewTheme.of(context).backgroundAsset),
                      fit: BoxFit.cover))),
          Column(
            children: [
              Form(
                key: _formKey,
                child: Container(
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: TextFormField(
                                controller: _crewNameController,
                                decoration: InputDecoration(
                                    hintText: 'Crew Name (Optional)',
                                    prefixIcon: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.group,
                                            size: 10,
                                            color: Colors.black,
                                          ),
                                          Icon(Icons.label, size: 30)
                                        ])),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: _names.keys
                            .map(
                              (id) => AddCrewMember(
                                  key: Key(id.toString()),
                                  name: _names[id],
                                  enableDelete: _names.length > 3,
                                  onDelete: () {
                                    removeCrewMember(id);
                                  },
                                  onUpdate: (value) {
                                    updateCrewMember(id, value);
                                  }),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => saveCrew(context),
                        child: Text('Save'),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddCrewMember extends StatelessWidget {
  final bool enableDelete;
  final Null Function() onDelete;
  final Null Function(String) onUpdate;
  final String? name;

  AddCrewMember(
      {this.enableDelete = false,
      Key? key,
      required this.onDelete,
      required this.onUpdate,
      this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              initialValue: name,
              onChanged: onUpdate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: 'Crew Member',
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: enableDelete ? onDelete : null,
          icon: Icon(Icons.delete),
          color: enableDelete ? Colors.grey[800] : Colors.white70,
        )
      ],
    );
  }
}
