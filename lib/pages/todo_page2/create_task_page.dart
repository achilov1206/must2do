import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/date_selector.dart';
import '../../blocs/block.dart';
import '../../widgets/custom_dropdown.dart';

class CreateTaskPage extends StatefulWidget {
  static const routeName = '/create-task-page';
  const CreateTaskPage({Key? key}) : super(key: key);

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _form = GlobalKey<FormState>();

  String? todoTitle;
  String? todoCatId;
  String? todoDesc;
  DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new Task'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: IconButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    _form.currentState!.save();
                    dateTime ??= DateTime.now();
                    todoDesc ??= '';
                    FocusScope.of(context).requestFocus(FocusNode());
                    context.read<TodoListBloc>().add(
                          AddTodoEvent(
                            todoTitle: todoTitle!,
                            todoCatId: todoCatId!,
                            todoDescription: todoDesc,
                            dateTime: dateTime!,
                          ),
                        );
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 700),
                        content: Row(
                          children: [
                            const Text('New task added'),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Go back'),
                            ),
                          ],
                        ),
                      ),
                    );
                    _form.currentState!.reset();
                  }
                },
                icon: const Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 40,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                ],
                cursorColor: Colors.green,
                initialValue: '',
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Task',
                  floatingLabelStyle: TextStyle(color: Colors.green),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter task';
                  }
                  return null;
                },
                onSaved: (value) {
                  todoTitle = value;
                },
              ),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                ],
                cursorColor: Colors.green,
                initialValue: '',
                maxLines: 2,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Task Description',
                  floatingLabelStyle: TextStyle(color: Colors.green),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                onSaved: (value) {
                  todoDesc = value;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BlocBuilder<CategoryListBloc, CategoryListState>(
                    builder: (context, state) {
                      return CustomDropdown(
                        itemsList: state.categories,
                        defaultValue: state.categories[0].id.toString(),
                        dropdownHint: 'None',
                        onValueChanged: (String value) {
                          todoCatId = value;
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DatePicker(
                    valueChanged: (value) {
                      dateTime = value;
                    },
                    initialDate: DateTime.now(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
