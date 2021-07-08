import 'package:crew/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCrew extends StatefulWidget {
  static const routeName = '/add';

  @override
  State<StatefulWidget> createState() {
    return AddCrewState();
  }
}

class AddCrewState extends State<AddCrew> {
  final _formKey = GlobalKey<FormState>();
  final _names = {0: '', 1: '', 2: ''};
  int _count = 3;
  final _crewName = '';

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
      Provider.of<CrewDb>(context, listen: false)
          .addCrew(members: _names.values.toList(), name: _crewName)
          .then((_) => Navigator.pop(context))
          .onError((error, stackTrace) => null);
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
      body: Form(
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
              ListView(
                shrinkWrap: true,
                children: _names.keys
                    .map(
                      (id) => AddCrewMember(
                          key: Key(id.toString()),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => saveCrew(context),
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddCrewMember extends StatelessWidget {
  final bool enableDelete;
  final Null Function() onDelete;
  final Null Function(String) onUpdate;

  AddCrewMember({this.enableDelete = false, Key? key, required this.onDelete, required this.onUpdate})
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
          color: Colors.grey[enableDelete ? 800 : 300],
        )
      ],
    );
  }
}
