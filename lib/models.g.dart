// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Crew extends DataClass implements Insertable<Crew> {
  final int id;
  final String name;
  final List<dynamic> members;
  final DateTime startDate;
  final DateTime endDate;
  Crew(
      {@required this.id,
      @required this.name,
      @required this.members,
      this.startDate,
      this.endDate});
  factory Crew.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return Crew(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name']),
      members: $CrewsTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}members'])),
      startDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}start_date']),
      endDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}end_date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || members != null) {
      final converter = $CrewsTable.$converter0;
      map['members'] = Variable<String>(converter.mapToSql(members));
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  CrewsCompanion toCompanion(bool nullToAbsent) {
    return CrewsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      members: members == null && nullToAbsent
          ? const Value.absent()
          : Value(members),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory Crew.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Crew(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      members: serializer.fromJson<List<dynamic>>(json['members']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'members': serializer.toJson<List<dynamic>>(members),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
    };
  }

  Crew copyWith(
          {int id,
          String name,
          List<dynamic> members,
          DateTime startDate,
          DateTime endDate}) =>
      Crew(
        id: id ?? this.id,
        name: name ?? this.name,
        members: members ?? this.members,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );
  @override
  String toString() {
    return (StringBuffer('Crew(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('members: $members, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          name.hashCode,
          $mrjc(
              members.hashCode, $mrjc(startDate.hashCode, endDate.hashCode)))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Crew &&
          other.id == this.id &&
          other.name == this.name &&
          other.members == this.members &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class CrewsCompanion extends UpdateCompanion<Crew> {
  final Value<int> id;
  final Value<String> name;
  final Value<List<dynamic>> members;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  const CrewsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.members = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  CrewsCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    @required List<dynamic> members,
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  })  : name = Value(name),
        members = Value(members);
  static Insertable<Crew> custom({
    Expression<int> id,
    Expression<String> name,
    Expression<List<dynamic>> members,
    Expression<DateTime> startDate,
    Expression<DateTime> endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (members != null) 'members': members,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  CrewsCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<List<dynamic>> members,
      Value<DateTime> startDate,
      Value<DateTime> endDate}) {
    return CrewsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (members.present) {
      final converter = $CrewsTable.$converter0;
      map['members'] = Variable<String>(converter.mapToSql(members.value));
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CrewsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('members: $members, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

class $CrewsTable extends Crews with TableInfo<$CrewsTable, Crew> {
  final GeneratedDatabase _db;
  final String _alias;
  $CrewsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _membersMeta = const VerificationMeta('members');
  GeneratedTextColumn _members;
  @override
  GeneratedTextColumn get members => _members ??= _constructMembers();
  GeneratedTextColumn _constructMembers() {
    return GeneratedTextColumn(
      'members',
      $tableName,
      false,
    );
  }

  final VerificationMeta _startDateMeta = const VerificationMeta('startDate');
  GeneratedDateTimeColumn _startDate;
  @override
  GeneratedDateTimeColumn get startDate => _startDate ??= _constructStartDate();
  GeneratedDateTimeColumn _constructStartDate() {
    return GeneratedDateTimeColumn(
      'start_date',
      $tableName,
      true,
    );
  }

  final VerificationMeta _endDateMeta = const VerificationMeta('endDate');
  GeneratedDateTimeColumn _endDate;
  @override
  GeneratedDateTimeColumn get endDate => _endDate ??= _constructEndDate();
  GeneratedDateTimeColumn _constructEndDate() {
    return GeneratedDateTimeColumn(
      'end_date',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, members, startDate, endDate];
  @override
  $CrewsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'crews';
  @override
  final String actualTableName = 'crews';
  @override
  VerificationContext validateIntegrity(Insertable<Crew> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name'], _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_membersMeta, const VerificationResult.success());
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date'], _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date'], _endDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Crew map(Map<String, dynamic> data, {String tablePrefix}) {
    return Crew.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CrewsTable createAlias(String alias) {
    return $CrewsTable(_db, alias);
  }

  static TypeConverter<List<dynamic>, String> $converter0 =
      const ListConverter();
}

class MissionAttempt extends DataClass implements Insertable<MissionAttempt> {
  final int id;
  final int crewId;
  final int attempts;
  final DateTime completionDate;
  MissionAttempt(
      {@required this.id,
      @required this.crewId,
      @required this.attempts,
      this.completionDate});
  factory MissionAttempt.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    return MissionAttempt(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      crewId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}crew_id']),
      attempts: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}attempts']),
      completionDate: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}completion_date']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || crewId != null) {
      map['crew_id'] = Variable<int>(crewId);
    }
    if (!nullToAbsent || attempts != null) {
      map['attempts'] = Variable<int>(attempts);
    }
    if (!nullToAbsent || completionDate != null) {
      map['completion_date'] = Variable<DateTime>(completionDate);
    }
    return map;
  }

  MissionAttemptsCompanion toCompanion(bool nullToAbsent) {
    return MissionAttemptsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      crewId:
          crewId == null && nullToAbsent ? const Value.absent() : Value(crewId),
      attempts: attempts == null && nullToAbsent
          ? const Value.absent()
          : Value(attempts),
      completionDate: completionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(completionDate),
    );
  }

  factory MissionAttempt.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return MissionAttempt(
      id: serializer.fromJson<int>(json['id']),
      crewId: serializer.fromJson<int>(json['crewId']),
      attempts: serializer.fromJson<int>(json['attempts']),
      completionDate: serializer.fromJson<DateTime>(json['completionDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'crewId': serializer.toJson<int>(crewId),
      'attempts': serializer.toJson<int>(attempts),
      'completionDate': serializer.toJson<DateTime>(completionDate),
    };
  }

  MissionAttempt copyWith(
          {int id, int crewId, int attempts, DateTime completionDate}) =>
      MissionAttempt(
        id: id ?? this.id,
        crewId: crewId ?? this.crewId,
        attempts: attempts ?? this.attempts,
        completionDate: completionDate ?? this.completionDate,
      );
  @override
  String toString() {
    return (StringBuffer('MissionAttempt(')
          ..write('id: $id, ')
          ..write('crewId: $crewId, ')
          ..write('attempts: $attempts, ')
          ..write('completionDate: $completionDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          crewId.hashCode, $mrjc(attempts.hashCode, completionDate.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionAttempt &&
          other.id == this.id &&
          other.crewId == this.crewId &&
          other.attempts == this.attempts &&
          other.completionDate == this.completionDate);
}

class MissionAttemptsCompanion extends UpdateCompanion<MissionAttempt> {
  final Value<int> id;
  final Value<int> crewId;
  final Value<int> attempts;
  final Value<DateTime> completionDate;
  const MissionAttemptsCompanion({
    this.id = const Value.absent(),
    this.crewId = const Value.absent(),
    this.attempts = const Value.absent(),
    this.completionDate = const Value.absent(),
  });
  MissionAttemptsCompanion.insert({
    @required int id,
    @required int crewId,
    this.attempts = const Value.absent(),
    this.completionDate = const Value.absent(),
  })  : id = Value(id),
        crewId = Value(crewId);
  static Insertable<MissionAttempt> custom({
    Expression<int> id,
    Expression<int> crewId,
    Expression<int> attempts,
    Expression<DateTime> completionDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (crewId != null) 'crew_id': crewId,
      if (attempts != null) 'attempts': attempts,
      if (completionDate != null) 'completion_date': completionDate,
    });
  }

  MissionAttemptsCompanion copyWith(
      {Value<int> id,
      Value<int> crewId,
      Value<int> attempts,
      Value<DateTime> completionDate}) {
    return MissionAttemptsCompanion(
      id: id ?? this.id,
      crewId: crewId ?? this.crewId,
      attempts: attempts ?? this.attempts,
      completionDate: completionDate ?? this.completionDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (crewId.present) {
      map['crew_id'] = Variable<int>(crewId.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (completionDate.present) {
      map['completion_date'] = Variable<DateTime>(completionDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('crewId: $crewId, ')
          ..write('attempts: $attempts, ')
          ..write('completionDate: $completionDate')
          ..write(')'))
        .toString();
  }
}

class $MissionAttemptsTable extends MissionAttempts
    with TableInfo<$MissionAttemptsTable, MissionAttempt> {
  final GeneratedDatabase _db;
  final String _alias;
  $MissionAttemptsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _crewIdMeta = const VerificationMeta('crewId');
  GeneratedIntColumn _crewId;
  @override
  GeneratedIntColumn get crewId => _crewId ??= _constructCrewId();
  GeneratedIntColumn _constructCrewId() {
    return GeneratedIntColumn('crew_id', $tableName, false,
        $customConstraints: 'REFERENCES crews(id)');
  }

  final VerificationMeta _attemptsMeta = const VerificationMeta('attempts');
  GeneratedIntColumn _attempts;
  @override
  GeneratedIntColumn get attempts => _attempts ??= _constructAttempts();
  GeneratedIntColumn _constructAttempts() {
    return GeneratedIntColumn('attempts', $tableName, false,
        defaultValue: const Constant(1));
  }

  final VerificationMeta _completionDateMeta =
      const VerificationMeta('completionDate');
  GeneratedDateTimeColumn _completionDate;
  @override
  GeneratedDateTimeColumn get completionDate =>
      _completionDate ??= _constructCompletionDate();
  GeneratedDateTimeColumn _constructCompletionDate() {
    return GeneratedDateTimeColumn(
      'completion_date',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, crewId, attempts, completionDate];
  @override
  $MissionAttemptsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'mission_attempts';
  @override
  final String actualTableName = 'mission_attempts';
  @override
  VerificationContext validateIntegrity(Insertable<MissionAttempt> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('crew_id')) {
      context.handle(_crewIdMeta,
          crewId.isAcceptableOrUnknown(data['crew_id'], _crewIdMeta));
    } else if (isInserting) {
      context.missing(_crewIdMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts'], _attemptsMeta));
    }
    if (data.containsKey('completion_date')) {
      context.handle(
          _completionDateMeta,
          completionDate.isAcceptableOrUnknown(
              data['completion_date'], _completionDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, crewId};
  @override
  MissionAttempt map(Map<String, dynamic> data, {String tablePrefix}) {
    return MissionAttempt.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $MissionAttemptsTable createAlias(String alias) {
    return $MissionAttemptsTable(_db, alias);
  }
}

abstract class _$CrewDb extends GeneratedDatabase {
  _$CrewDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $CrewsTable _crews;
  $CrewsTable get crews => _crews ??= $CrewsTable(this);
  $MissionAttemptsTable _missionAttempts;
  $MissionAttemptsTable get missionAttempts =>
      _missionAttempts ??= $MissionAttemptsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [crews, missionAttempts];
}
