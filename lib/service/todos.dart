import "dart:io";

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part '../repository/todos.g.dart';

class Todos extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get comment => text()();
  BoolColumn get isAllday => boolean()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();

}

@DriftDatabase(tables: [Todos])
class CalenderDatabase extends _$CalenderDatabase{
  CalenderDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Todo>> watchEntries(){
    return (select(todos)).watch();
  }

  Future<List<Todo>> get allTodoEntries => select(todos).get();

  Future<int> addTodo(String title,String comment,bool isallday,DateTime starttime,DateTime endtime,){
    return into(todos).insert(TodosCompanion(
      title: Value(title),
      comment: Value(comment), 
      isAllday: Value(isallday),
      startTime: Value(starttime),
      endTime:  Value(endtime)
      ));
  }

  Future<int> updateTodo(int id, String title, String comment, bool isallday, DateTime starttime,DateTime endtime){
    return (update(todos)..where((tbl) => tbl.id.equals(id))).write(
      TodosCompanion(
        title: Value(title),
        comment: Value(comment), 
        isAllday: Value(isallday),
        startTime: Value(starttime),
        endTime:  Value(endtime)

      )
    );
  }

  Future<int> deleteTodo(int id){
    return (delete(todos)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection(){
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "db.sqlite"));
    return NativeDatabase(file);
  });
}