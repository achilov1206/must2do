import 'package:flutter/material.dart';

class DialogWithCheckBox extends StatefulWidget {
  const DialogWithCheckBox({Key? key}) : super(key: key);

  @override
  State<DialogWithCheckBox> createState() => _DialogWithCheckBoxState();
}

class _DialogWithCheckBoxState extends State<DialogWithCheckBox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Do yot really want to delete?'),
      content: Row(
        children: [
          const Text(
            'Delete all related tasks',
          ),
          Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.all(Colors.green),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
            },
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, {'checked': false, 'delete': false});
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {'checked': _isChecked, 'delete': true});
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
