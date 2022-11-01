import 'package:sqlite3/sqlite3.dart';

class Sqlite3Util {
  Sqlite3Util._();

  static late Database _db;

  static void init(Database db) => _db = db;

  static Version get version => sqlite3.version;

  // 创建表
  static void createTable(String tableName, List<String> column) {
    String sql = "CREATE TABLE IF NOT EXISTS $tableName (${column.join(", ")})";
    _db.execute(sql);
  }

  // 删除表
  static void dropTable(String tableName) {
    String sql = "DROP TABLE IF EXISTS $tableName";
    _db.execute(sql);
  }

  // 判断某个表是否存在
  static bool existsTable(String tableName) {
    try {
      _db.execute("SELECT 1 FROM $tableName");
      return true;
    } catch (e) {
      return false;
    }
  }

  // 修改表-添加字段
  static void addColumn(String tableName, List<String> column) {
    if (column.isEmpty) return;
    column.forEach((element) {
      _db.execute("ALTER TABLE $tableName ADD COLUMN $element");
    });
  }

  // 修改表名
  static void renameTable(String tableName, String newTableName) {
    String sql = "ALTER TABLE $tableName RENAME TO $newTableName";
    _db.execute(sql);
  }

  // 查询指定表
  static ResultSet query(SQLSelect select, [List<Object?> parameters = const []]) {
    return _db.select(select.get(), parameters);
  }

  // 执行sql语句
  static void execute(String sql, [List<Object?> parameters = const []]) {
    return _db.execute(sql, parameters);
  }

  // 关闭数据库
  static void close() {
    _db.dispose();
  }
}

/// sql 格式化
abstract class BaseSQL {
  String get();

  @override
  String toString() => get();
}

/// SELECT 子句
class SQLSelect extends BaseSQL {
  SQLSelect._();

  String _column = "*";
  String _tableName = "";
  String _where = "";
  String _desc = "";
  String _groupBy = "";
  String _having = "";

  // 构建select
  static SQLSelect select(String tableName) {
    var obj = SQLSelect._();
    obj._tableName = tableName;
    return obj;
  }

  // 构建 字段表
  SQLSelect column([List<String> column = const []]) {
    _column = column.isEmpty ? "*" : column.join(", ");
    return this;
  }

  // 构建查询条件 AND
  SQLSelect whereAnd(String where) {
    if (where.trim().isEmpty) return this;

    // 如果是附加条件
    if (_where.trim().isNotEmpty) {
      _where = _where.replaceAll("WHERE ", "");
      _where = "WHERE ($_where AND $where)";
      return this;
    }
    _where = "WHERE $where";
    return this;
  }

  // 构建查询条件 OR
  SQLSelect whereOr(String where) {
    if (where.trim().isEmpty) return this;

    // 如果是附加条件
    if (_where.trim().isNotEmpty) {
      _where = _where.replaceAll("WHERE ", "");
      _where = "WHERE ($_where OR $where)";
      return this;
    }
    _where = "WHERE $where";
    return this;
  }

  // 构建排序依据 降序, 默认升序
  SQLSelect desc(String column) {
    if (column.trim().isEmpty) return this;
    _desc = "ORDER BY $column";
    return this;
  }

  // 构建分组依据
  SQLSelect groupBy(String field) {
    if (field.trim().isEmpty) return this;

    // 如果是多字段分组
    if (_groupBy.trim().isNotEmpty) {
      _groupBy = "$_groupBy, $field";
      return this;
    }
    _groupBy = "GROUP BY $field";
    return this;
  }

  // 构建分组条件 HAVING AND
  SQLSelect havingAnd(String where) {
    if (where.trim().isEmpty || _groupBy.trim().isEmpty) return this;

    // 如果是多条件
    if (_having.trim().isNotEmpty) {
      _having = _having.replaceAll("HAVING ", "");
      _having = "HAVING ($_groupBy AND $where)";
      return this;
    }
    _having = "HAVING $where";
    return this;
  }

  // 构建分组条件 HAVING OR
  SQLSelect havingOr(String where) {
    if (where.trim().isEmpty || _groupBy.trim().isEmpty) return this;

    // 如果是多条件
    if (_having.trim().isNotEmpty) {
      _having = _having.replaceAll("HAVING ", "");
      _having = "HAVING ($_groupBy OR $where)";
      return this;
    }
    _having = "HAVING $where";
    return this;
  }

  // 获取
  @override
  String get() => "SELECT $_column FROM $_tableName $_where $_groupBy $_having";
}

/// UPDATE 子句
class SQLUpdate extends BaseSQL {
  SQLUpdate._();

  String _tableName = "";
  String _sets = "";
  String _where = "";

  static SQLUpdate update(String tableName) {
    var obj = SQLUpdate._();
    obj._tableName = tableName;
    return obj;
  }

  // 构建字段列
  SQLUpdate column(List<String> column) {
    var sets = column.map((e) => '$e = ?').join(', ');
    if (_sets.trim().isNotEmpty) {
      _sets = "$_sets, $sets";
      return this;
    }
    _sets = sets;
    return this;
  }

  // 构建查询条件 AND
  SQLUpdate whereAnd(String where) {
    if (where.trim().isEmpty) return this;

    // 如果是附加条件
    if (_where.trim().isNotEmpty) {
      _where = _where.replaceAll("WHERE ", "");
      _where = "WHERE ($_where AND $where)";
      return this;
    }
    _where = "WHERE $where";
    return this;
  }

  // 构建查询条件 OR
  SQLUpdate whereOr(String where) {
    if (where.trim().isEmpty) return this;

    // 如果是附加条件
    if (_where.trim().isNotEmpty) {
      _where = _where.replaceAll("WHERE ", "");
      _where = "WHERE ($_where OR $where)";
      return this;
    }
    _where = "WHERE $where";
    return this;
  }

  @override
  String get() => "UPDATE $_tableName SET $_sets $_where";
}

/// DELETE 子句
class SQLDelete extends BaseSQL {
  SQLDelete._();

  String _tableName = "";
  String _where = "";

  static SQLDelete delete(String tableName) {
    var obj = SQLDelete._();
    obj._tableName = tableName;
    return obj;
  }

  // 构建条件 AND
  SQLDelete whereAnd(String where) {
    if (where.trim().isEmpty) return this;

    // 如果是附加条件
    if (_where.trim().isNotEmpty) {
      _where = _where.replaceAll("WHERE ", "");
      _where = "WHERE ($_where AND $where)";
      return this;
    }
    _where = "WHERE $where";
    return this;
  }

  // 构建条件 OR
  SQLDelete whereOr(String where) {
    if (where.trim().isEmpty) return this;

    // 如果是附加条件
    if (_where.trim().isNotEmpty) {
      _where = _where.replaceAll("WHERE ", "");
      _where = "WHERE ($_where OR $where)";
      return this;
    }
    _where = "WHERE $where";
    return this;
  }

  @override
  String get() => "DELETE FROM $_tableName $_where";
}

/// INSERT INTO 子句
class SQLInsert extends BaseSQL {
  SQLInsert._();

  String _tableName = "";
  String _column = "";
  String _values = "";

  static SQLInsert insert(String tableName) {
    var obj = SQLInsert._();
    obj._tableName = tableName;
    return obj;
  }

  SQLInsert column(List<String> column) {
    var cols = column.join(", ");
    var values = column.map((e) => "?").join(", ");
    if (_column.trim().isNotEmpty) {
      _column = "$_column, $cols";
      _values = "$_values, $values";
      return this;
    }
    _column = cols;
    _values = values;
    return this;
  }

  // 获取
  @override
  String get() => "INSERT INTO $_tableName ($_column) VALUES ($_values)";
}

/// 整合
class SQL {
  SQL._();

  static SQLSelect select(String tableName) => SQLSelect.select(tableName);

  static SQLUpdate update(String tableName) => SQLUpdate.update(tableName);

  static SQLDelete delete(String tableName) => SQLDelete.delete(tableName);

  static SQLInsert insert(String tableName) => SQLInsert.insert(tableName);
}
