import 'package:flutter/material.dart';

import '../models/category_model.dart';

class CustomDropdown extends StatefulWidget {
  final ValueChanged<String>? onValueChanged;
  final String? defaultValue, dropdownHint;
  final List<Category>? itemsList;

  const CustomDropdown({
    Key? key,
    required this.itemsList,
    required this.defaultValue,
    required this.dropdownHint,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 150,
      //padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: DropdownButtonFormField<String>(
        elevation: 0,
        alignment: AlignmentDirectional.topCenter,
        decoration: const InputDecoration(border: InputBorder.none),
        icon: const Icon(
          Icons.arrow_downward,
          size: 20,
          color: Colors.green,
        ),
        items: widget.itemsList!.map(
          (Category cat) {
            return DropdownMenuItem<String>(
              value: cat.id.toString(),
              child: Text(
                cat.title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          },
        ).toList(),
        value: _value ?? widget.defaultValue,
        validator: (value) => value == null ? widget.defaultValue : null,
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            widget.onValueChanged!(value!);
            _value = value;
          });
        },
        onSaved: (value) {
          setState(() {
            widget.onValueChanged!(value!);
            _value = value;
          });
        },
        hint: Text(widget.dropdownHint!),
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        iconEnabledColor: Colors.black,
        iconSize: 14,
      ),
    );
  }
}
