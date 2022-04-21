import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final ValueChanged<DateTime>? valueChanged;
  final DateTime? initialDate;
  const DatePicker({
    Key? key,
    this.valueChanged,
    this.initialDate,
  }) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? pickedDate;
  @override
  Widget build(BuildContext context) {
    void onStartTimeChange() async {
      DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: pickedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 120)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      setState(() {
        pickedDate = _pickedDate!;
      });
      widget.valueChanged!(pickedDate!);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        ),
        onPressed: () {
          onStartTimeChange();
        },
        child: Text(
          DateFormat("dd-MMM").format(pickedDate ?? widget.initialDate!),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
