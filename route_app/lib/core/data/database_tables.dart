import 'package:route_app/core/enums/Database_Types.dart';
import 'package:tuple/tuple.dart';

/// List of all tables in the database,
/// If adding/changing tables, up the database version in environments files
/// Tuple explanation: <TableName> <Id key>, <Columns>
final List<Tuple3<String, String, Map<String, DatabaseTypes>>>
  // ignore: always_specify_types
  tables = [
    // ignore: always_specify_types
    const Tuple3('auth', '_id', {
      'JWT': DatabaseTypes.TEXT,
      'expire': DatabaseTypes.TEXT
    }),
    // ignore: always_specify_types
    const Tuple3('logs', '_id', {
      'json': DatabaseTypes.BLOB
    }),
    // ignore: always_specify_types
    const Tuple3('user', '_id', {
      'json': DatabaseTypes.BLOB
    })
  ];