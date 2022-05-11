import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import '../models/todo_model.dart';
import '../blocs/block.dart';
import './todo_item.dart';

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(
      first.year,
      first.month,
      first.day + index,
    ),
  );
}

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({Key? key}) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late List<Todo> _selectedTasks;
  late LinkedHashMap _linkedHashTodos;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Future<void> fetchHashTodosMap() async {
    _linkedHashTodos = await context.read<CalendarTodoCubit>().getTodos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Get Tasks for given day
  List<Todo> _getTasksForDay(DateTime day) {
    return _linkedHashTodos[day] ?? [];
  }

  //Get Tasks for selected date range
  List<Todo> _getTasksForRange({
    required DateTime start,
    required DateTime end,
  }) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getTasksForDay(d),
    ];
  }

  void _onDaySelected({
    required DateTime selectedDay,
    required DateTime focusedDay,
  }) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedTasks = _getTasksForDay(selectedDay);
      });
    }
  }

  void _onRangeSelected({
    DateTime? start,
    DateTime? end,
    required DateTime focusedDay,
  }) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedTasks = _getTasksForRange(start: start, end: end);
    } else if (start != null) {
      _selectedTasks = _getTasksForDay(start);
    } else if (end != null) {
      _selectedTasks = _getTasksForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchHashTodosMap(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Something gone wrong\nPlease update page'),
          );
        } else {
          return BlocConsumer<TodoListBloc, TodoListState>(
            listener: (context, state) {
              //print(state.todos);
              _selectedTasks = _getTasksForDay(
                  context.watch<CalendarTodoCubit>().state.dateTime);
            },
            builder: (context, state) {
              return BlocBuilder<CalendarTodoCubit, CalendarTodoState>(
                builder: (context, state) {
                  _selectedTasks = _getTasksForDay(state.dateTime);
                  return Column(
                    children: [
                      TableCalendar<Todo>(
                        firstDay: DateTime(
                          DateTime.now().year,
                          DateTime.now().month - 12,
                          DateTime.now().day,
                        ),
                        lastDay: DateTime(
                          DateTime.now().year,
                          DateTime.now().month + 12,
                          DateTime.now().day,
                        ),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(state.dateTime, day),
                        rangeStartDay: _rangeStart,
                        rangeEndDay: _rangeEnd,
                        calendarFormat: _calendarFormat,
                        rangeSelectionMode: _rangeSelectionMode,
                        eventLoader: (DateTime day) => _getTasksForDay(day),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: const CalendarStyle(
                          outsideDaysVisible: true,
                        ),
                        onDaySelected:
                            (DateTime selectedDay, DateTime focusedDay) {
                          context
                              .read<CalendarTodoCubit>()
                              .setDateTime(selectedDay);
                          return _onDaySelected(
                            selectedDay: selectedDay,
                            focusedDay: focusedDay,
                          );
                        },
                        onRangeSelected: (DateTime? start, DateTime? end,
                                DateTime focusedDay) =>
                            _onRangeSelected(
                          start: start,
                          end: end,
                          focusedDay: focusedDay,
                        ),
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _selectedTasks.length,
                          itemBuilder: (context, index) {
                            return TodoItem(todo: _selectedTasks[index]);
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
