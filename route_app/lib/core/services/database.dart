import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:route_app/core/enums/Database_Types.dart';
import 'package:route_app/core/utils/enum_converter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tuple/tuple.dart';
import '../data/database_tables.dart' as data;

/// Database interaction interface
class DatabaseService {
  /// Default constructor
  DatabaseService(
      {@required String databaseName, @required int version})
      : _databaseName = databaseName, _databaseVersion = version {
    database.then((_) {});
  }

  // This is the actual database filename that is saved in the docs directory.
  final String _databaseName;
  // Increment this version when you need to change the schema.
  final int _databaseVersion;

  //Make sure there is only one database connection open
  static Database _database;

  /// Get the active database connection
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  /// Open the database connection
  Future<Database> _initDatabase() async {
    final Directory documentDirectory = await
    getApplicationDocumentsDirectory();
    final String path = join(documentDirectory.path, _databaseName);
    return openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onVersionChange);
  }

  Future<void> _onVersionChange(Database db, int oldV, int newV) async {
    final List<String> oldTables = <String>[];

    _getTables(db).then((List<Map<String, dynamic>> tables) {
      tables.forEach((Map<String, dynamic> table) {
        oldTables.add(table.values.first);
      });

      data.tables.forEach(
          (Tuple3<String, String, Map<String, DatabaseTypes>> table) {
            if (!oldTables.contains(table.item1)) {
              _createTable(db, table);
            }
          });
    });
  }

  Future<List<Map<String, dynamic>>> _getTables(Database db) async {
    return db.query(
        'sqlite_master',
        columns: <String>['name'],
        where: "type='table'",
        orderBy: 'name'
        );
  }

  Future<void> _onCreate(Database db, int version) async {
    data.tables.forEach(
            (Tuple3<String, String, Map<String, DatabaseTypes>>table) async {
              await _createTable(db, table);
            });
  }

  /// Helper to create a new table in the database
  Future<void> _createTable(Database db,
      Tuple3<String, String, Map<String, DatabaseTypes>> data)
  async {

    final String tableName = data.item1;
    final String key = data.item2;
    final Map<String, DatabaseTypes> columns = data.item3;

    String sql = '''CREATE TABLE $tableName ( $key INTEGER PRIMARY KEY''';

    columns.forEach((String name, DatabaseTypes type) {
      final String colType = enumToString(type);
      sql += ''',$name $colType NOT NULL''';
    });

    sql += ')';

    return db.execute(sql);
  }

  /// Helper to insert rows into table
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final Database db = await database;

    return db.insert(table, values);
  }

  /// Helper to query a table
  ///
  /// @param distinct true if you want each row to be unique, false otherwise.
  /// @param table The table names to compile the query against.
  /// @param columns A list of which columns to return. Passing null will
  ///            return all columns, which is discouraged to prevent reading
  ///            data from storage that isn't going to be used.
  /// @param where A filter declaring which rows to return, formatted as an SQL
  ///            WHERE clause (excluding the WHERE itself). Passing null will
  ///            return all rows for the given URL.
  /// @param groupBy A filter declaring how to group rows, formatted as an SQL
  ///            GROUP BY clause (excluding the GROUP BY itself). Passing null
  ///            will cause the rows to not be grouped.
  /// @param having A filter declare which row groups to include in the cursor,
  ///            if row grouping is being used, formatted as an SQL HAVING
  ///            clause (excluding the HAVING itself). Passing null will cause
  ///            all row groups to be included, and is required when row
  ///            grouping is not being used.
  /// @param orderBy How to order the rows, formatted as an SQL ORDER BY clause
  ///            (excluding the ORDER BY itself). Passing null will use the
  ///            default sort order, which may be unordered.
  /// @param limit Limits the number of rows returned by the query,
  /// @param offset starting index,

  /// @return the items found
  Future<List<Map<String, dynamic>>> query(String table,
  {bool distinct, List<String> columns, String where, List<dynamic> whereArgs,
  String groupBy, String having, String orderBy,int limit, int offset}) async {
    final Database db = await database;

    return db.query(table, distinct: distinct, columns: columns, where: where,
                    whereArgs: whereArgs, groupBy: groupBy, having: having,
                    orderBy: orderBy, limit: limit, offset: offset);
  }

  /// Helper for updating rows in the database.
  ///
  /// Update [table] with [values], a map from column names to new column
  /// values. null is a valid value that will be translated to NULL.
  ///
  /// [where] is the optional WHERE clause to apply when updating.
  /// Passing null will update all rows.
  ///
  /// You may include ?s in the where clause, which will be replaced by the
  /// values from [whereArgs]
  Future<int> update(String table, Map<String, dynamic> values,
  {String where, List<dynamic> whereArgs}) async {
    final Database db = await database;

    return db.update(table, values, whereArgs: whereArgs, where: where);
  }

  /// Convenience method for deleting rows in the database.
  ///
  /// Delete from [table]
  ///
  /// [where] is the optional WHERE clause to apply when updating. Passing null
  /// will update all rows.
  ///
  /// You may include ?s in the where clause, which will be replaced by the
  /// values from [whereArgs]
  ///
  /// Returns the number of rows affected if a whereClause is passed in, 0
  /// otherwise. To remove all rows and get a count pass '1' as the
  /// whereClause.
  Future<int> delete(String table, {String where, List<dynamic> whereArgs})
  async {
    final Database db = await database;

    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// Creates a batch, used for performing multiple operation
  /// in a single atomic operation.
  ///
  /// a batch can be committed using [Batch.commit]
  ///
  /// If the batch was created in a transaction, it will be committed
  /// when the transaction is done
  Future<Batch> batch() async {
    final Database db = await database;

    return db.batch();
  }

}

