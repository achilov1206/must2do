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
  DateTime _focusedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  LinkedHashMap fetchHashTodosMap(Map<DateTime, List<Todo>> todos) {
    return LinkedHashMap<DateTime, List<Todo>>(
      equals: isSameDay,
    )..addAll(todos);
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

  // void _onRangeSelected({
  //   DateTime? start,
  //   DateTime? end,
  //   required DateTime focusedDay,
  // }) {
  //   setState(() {
  //     _selectedDay = null;
  //     _focusedDay = focusedDay;
  //     _rangeStart = start;
  //     _rangeEnd = end;
  //     _rangeSelectionMode = RangeSelectionMode.toggledOn;
  //   });

  //   // `start` or `end` could be null
  //   if (start != null && end != null) {
  //     _selectedTasks = _getTasksForRange(start: start, end: end);
  //   } else if (start != null) {
  //     _selectedTasks = _getTasksForDay(start);
  //   } else if (end != null) {
  //     _selectedTasks = _getTasksForDay(end);
  //   }
  // }

  Widget _buildEventsMarkerNum(List events) {
    return buildCalendarDayMarker(
      text: '${events.length}',
      // backColor: privateLength == 0
      //     ? DaisyColors.main0Color
      //     : DaisyColors.serveColor);
      backColor: Colors.green,
    );
  }

  AnimatedContainer buildCalendarDayMarker({
    @required String? text,
    @required Color? backColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: backColor,
      ),
      width: 52,
      height: 13,
      child: Center(
        child: Text(
          text!,
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListState>(
      builder: (context, state) {
        if (state.todoListStatus == TodoListStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.todoListStatus == TodoListStatus.error) {
          return const Center(
            child: Text('Something gone wrong\nPlease update page'),
          );
        } else {
          context.read<TodoListBloc>().add(const GetTodosEvent());
          _linkedHashTodos = fetchHashTodosMap(state.todos);
          if (_selectedDay != null) {
            _selectedTasks = _getTasksForDay(_selectedDay!);
          }
          return Column(
            children: [
              TableCalendar<Todo>(
                calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                    todayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                    markerBuilder: (context, date, events) {
                      int quantity = _getTasksForDay(DateTime(
                        date.year,
                        date.month,
                        date.day,
                      )).length;
                      return quantity > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              child: Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            )
                          : Container();
                    }),
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
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                //rangeSelectionMode: _rangeSelectionMode,
                eventLoader: (DateTime day) => _getTasksForDay(day),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: true,
                ),
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  return _onDaySelected(
                    selectedDay: DateTime(
                      selectedDay.year,
                      selectedDay.month,
                      selectedDay.day,
                    ),
                    focusedDay: focusedDay,
                  );
                },
                // onRangeSelected:
                //     (DateTime? start, DateTime? end, DateTime focusedDay) =>
                //         _onRangeSelected(
                //   start: start,
                //   end: end,
                //   focusedDay: focusedDay,
                // ),
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
        }
      },
    );
  }
}
