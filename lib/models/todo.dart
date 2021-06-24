import 'package:flutter_sqlite_demo/models/model.dart';

class TodoItem extends Model {

	static String table = 'todo_db';

	int id;
	DateTime dateTime;
	String task;
	bool complete;

	TodoItem({ this.id, this.dateTime, this.task, this.complete = false });

	Map<String, dynamic> toMap() {

		Map<String, dynamic> map = {
			'task': task,
			'dateTime': dateTime.millisecondsSinceEpoch,
			'complete': complete
		};
		print(map);

		if (id != null) { map['id'] = id; }
		return map;
	}

	static TodoItem fromMap(Map<String, dynamic> map) {
		
		return TodoItem(
			id: map['id'],
			task: map['task'].toString(),
			dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
			complete: map['complete'] == 1 ? true : false,
		);
	}

	@override
  String toString() {
    return 'TodoItem{id: $id, dateTime: $dateTime, task: $task, complete $complete}';
  }
}