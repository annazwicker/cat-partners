// Code copied from https://drift.simonbinder.eu/docs/sql-api/drift_files/
// Setup

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'database.g.dart';

@DriftDatabase(
  include: {'sql_schema.drift'},
)
class MyDb extends _$MyDb {
  // This example creates a simple in-memory database (without actual
  // persistence).
  // To store data, see the database setups from other "Getting started" guides.
  MyDb() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;
}