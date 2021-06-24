import 'package:flutter/material.dart';
import 'package:flutter_sqlite_demo/pages/todoList.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  Color colorDateNow = Colors.black12;

  @override
  void initState() {
    super.initState();
  }

  List listDates(DateTime dateTime) {
    List listDates = [];
    if (dateTime.day != 1) {
      dateTime = dateTime.subtract(Duration(days: dateTime.day));
    };
    DateTime date = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    for (int i = 1; i <= 6 * 7; i++) {
      listDates.add(date);
      date = date.add(Duration(days: 1));
    }
    return listDates;
  }

  Widget calendarTable(List listDates) {
    return Table(
      children: [
        for (int i = 1; i <= 6; i++)
          TableRow(
            children: [
              for (int k = 1; k <= 7; k++)
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        primary: DateFormat.yMd()
                                    .format(listDates[(i - 1) * 7 + k - 1]) ==
                                DateFormat.yMd().format(DateTime.now())
                            ? Colors.cyan
                            : Colors.white,
                        textStyle: TextStyle(color: Colors.black),
                      ),
                      child: Text(
                        listDates[(i - 1) * 7 + k - 1].day.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TodoList(
                                      dateTime: listDates[(i - 1) * 7 + k - 1],
                                    )));
                      },
                    ),
                  ),
                ),
              //),
            ],
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List dates = listDates(_targetDateTime);

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Calendar'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //custom icon

              Container(
                margin: EdgeInsets.only(
                  top: 30.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month - 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                          dates = listDates(_targetDateTime);
                        });
                      },
                    ),
                    Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    ElevatedButton(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month + 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: calendarTable(dates),
              ), //
            ],
          ),
        ));
  }
}
