import 'package:flutter/material.dart';
import 'package:flutter_todo_urbainians/pages/calendar.dart';
import 'package:flutter_todo_urbainians/services/db.dart';

void main() async {

	WidgetsFlutterBinding.ensureInitialized();

	await DB.init();
	runApp(MyApp());
}

class MyApp extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

		return MaterialApp(
			title: 'Flutter Todo',
			theme: ThemeData( primarySwatch: Colors.cyan ),
			home: Calendar(),
			debugShowCheckedModeBanner: false,
		);
	}
}


