import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0, adapterName: "TodoAdapter")
class Todo {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isFinished;

  Todo({required this.title, this.isFinished = false});
}
