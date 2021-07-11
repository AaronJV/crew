import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'models.g.dart';

class ListConverter extends TypeConverter<List<String>, String> {
  const ListConverter();

  @override
  List<String>? mapToDart(String? fromDb) {
    List? list = fromDb != null ? json.decode(fromDb) as List : null;
    return list?.map((val) => val.toString()).toList() ?? null;
  }

  @override
  String? mapToSql(List<String>? value) {
    return value != null ? json.encode(value) : null;
  }
}

class Crews extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quest => text()();
  TextColumn get name => text().nullable()();
  TextColumn get members => text().map(const ListConverter())();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
}

class MissionAttempts extends Table {
  IntColumn get id => integer()();
  IntColumn get crewId => integer().customConstraint('REFERENCES crews(id)')();
  IntColumn get attempts => integer().withDefault(const Constant(1))();
  DateTimeColumn get completionDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id, crewId};
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Crews, MissionAttempts])
class CrewDb extends _$CrewDb {
  CrewDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Crew>> watchCrews({required String quest}) {
    return (select(crews)..where((t) => t.quest.equals(quest)))
        .watch()
        .map((event) => event)
        .handleError((err) {
      log("error");
    });
  }

  Future<int> addCrew(
      {required List<String> members,
      required String name,
      required String quest}) {
    return into(crews)
        .insert(CrewsCompanion(
            members: Value(members), name: Value(name), quest: Value(quest)))
        .then((value) => into(missionAttempts).insert(
            MissionAttemptsCompanion(crewId: Value(value), id: Value(1))));
  }

  Stream<MissionAttempt> getCurtentMission(int crewId) {
    return (select(missionAttempts)
          ..where((t) => (t.crewId.equals(crewId) & t.completionDate.isNull())))
        .watchSingle();
  }

  Stream<List<MissionAttempt>> getCompletedMissions(int crewId) {
    return (select(missionAttempts)
          ..where((t) => t.crewId.equals(crewId) & t.completionDate.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .watch();
  }

  Future<void> recordMissionSuccess(MissionAttempt mission) {
    return (update(missionAttempts)
          ..where(
              (t) => t.id.equals(mission.id) & t.crewId.equals(mission.crewId)))
        .write(mission.copyWith(completionDate: DateTime.now()))
        .then((value) => into(missionAttempts).insert(MissionAttemptsCompanion(
            crewId: Value(mission.crewId), id: Value(mission.id + 1))));
  }

  Future<void> recordMissionFailure(MissionAttempt mission) {
    return (update(missionAttempts)
          ..where(
              (t) => t.id.equals(mission.id) & t.crewId.equals(mission.crewId)))
        .write(MissionAttemptsCompanion(attempts: Value(mission.attempts + 1)));
  }

  Future<void> resetMission(MissionAttempt missionAttempt) {
    return transaction(() async {
      await (delete(missionAttempts)
            ..where((t) =>
                t.id.equals(missionAttempt.id) &
                t.crewId.equals(missionAttempt.crewId)))
          .go();
      await (update(missionAttempts)
            ..where((t) =>
                t.id.equals(missionAttempt.id - 1) &
                t.crewId.equals(missionAttempt.crewId)))
          .write(MissionAttemptsCompanion(completionDate: Value(null)));
    });
  }

  Stream<DateTime?> getStartDate(int crewId) {
    return (select(missionAttempts)
          ..where((t) => t.crewId.equals(crewId) & t.completionDate.isNotNull())
          ..orderBy([(t) => OrderingTerm.asc(t.completionDate)])
          ..limit(1))
        .watchSingleOrNull()
        .map((value) => value?.completionDate);
  }

  Stream<int> getCurrentMission(int crewId) {
    return (select(missionAttempts)
          ..where((t) => (t.crewId.equals(crewId) & t.completionDate.isNull()))
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .watchSingle()
        .map((value) => value.id);
  }

  Future<void> deleteCrew(int id) async {
    return (delete(crews)..where((t) => t.id.equals(id)))
        .go()
        .then((value) => null);
  }

  Future<void> updateCrew(int? crewId,
      {required List<String> members, String? name}) {
    return (update(crews)..where((t) => t.id.equals(crewId)))
        .write(CrewsCompanion(
            members: Value(members),
            name: name != null ? Value(name) : Value.absent()))
        .then((value) => null);
  }
}
