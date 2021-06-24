import 'package:flutter/material.dart';
import 'package:flutter_todo_urbainians/models/todo.dart';
import 'package:flutter_todo_urbainians/services/db.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';

class TodoList extends StatefulWidget {
  TodoList({Key key, this.dateTime}) : super(key: key);
  DateTime dateTime;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  String _task;
  DateTime _dateTime;
  DateTime _dateOfDay;
  TextEditingController _textTaskController;
  List<TodoItem> _tasks = [];

  void _delete(TodoItem item) async {
    DB.delete(TodoItem.table, item);
    refresh();
  }

  void _save() async {
    TodoItem item = TodoItem(
      task: _task,
      dateTime: _dateTime,
    );

    await DB.insert(TodoItem.table, item);
    _task = '';
    _dateTime = _dateOfDay;
    refresh();
  }

  void _update(TodoItem item) async {
    item.complete = !item.complete;
    await DB.update(TodoItem.table, item);
    refresh();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(TodoItem.table);
    var list = _results.map((item) => TodoItem.fromMap(item)).toList();
    _tasks = [];
    for (var k in list) {
      print(DateFormat("yyyy-MM-dd").format(_dateTime));
      if (DateFormat("yyyy-MM-dd").format(k.dateTime) ==
          DateFormat("yyyy-MM-dd").format(_dateOfDay)) {
        _tasks.add(k);
      }
    }
    setState(() {});
  }

  Widget _listOfItems() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final TodoItem item = _tasks[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                _delete(item);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.task} dismissed')));
            },
            // Show a red background as the item is swiped away.
            background: Container(color: Colors.grey),
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              margin: EdgeInsets.only(top: 4, bottom: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300], width: 1.5),
              ),
              child: Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.grey,
                    value: item.complete,
                    onChanged: (bool value) {
                      setState(() {
                        _update(item);
                      });
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "${DateFormat("HH:mm").format(item.dateTime)}",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      "${item.task}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          decoration: item.complete == true
                              ? TextDecoration.lineThrough
                              : null,
                          color: item.complete == true ? Colors.grey : null),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _create() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TimePickerSpinner(
            normalTextStyle: TextStyle(
              fontSize: 18,
            ),
            minutesInterval: 15,
            isForce2Digits: true,
            itemHeight: 40,
            onTimeChange: (time) {
              setState(() {
                _dateTime = new DateTime(_dateOfDay.year, _dateOfDay.month,
                    _dateOfDay.day, time.hour, time.minute);
              });
            },
          ),
          Container(
            width: 100,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: TextField(
              controller: _textTaskController,
              decoration: InputDecoration(hintText: 'task'),
              onChanged: (value) {
                _task = value;
              },
            ),
          ),
          ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                _save();
                setState(() {
                  _textTaskController = new TextEditingController();
                });
              }),
        ],
      ),
    );
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dateOfDay = widget.dateTime;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("ToDo")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMM().format(_dateOfDay),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _create(),
              SizedBox(
                height: 20,
              ),
              _listOfItems(),
            ],
          ),
        ),
      ),
    );
  }
}
