import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../widgets/custom_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks on Calendar'),
      ),
      body: CustomCalendar(),
    );
  }
}
