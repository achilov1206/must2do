import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_model.dart';
import '../../models/todo_model.dart';
import '../../widgets/date_selector.dart';
import '../../blocs/block.dart';
import '../../widgets/custom_dropdown.dart';
import './tasks_page.dart';

class CreateTaskPage extends StatefulWidget {
  static const routeName = '/create-task-page';
  // isCreatedFromMainPage false - pop to TasksPage
  // isCreatedFromMainPage true - pop till main page
  final bool isCreatedFromMainPage;
  //if Todo not null edit task
  //else create new task

  //category id for selecting necessary category in dropdown
  final String? belongsToCategory;
  //not null if task edit mode
  final Todo? todoToEdit;
  const CreateTaskPage({
    Key? key,
    //pop to main page if true;
    this.isCreatedFromMainPage = true,
    //Edit existing task if [todoToEdit] not null
    this.todoToEdit,
    //Select Category accordingly
    this.belongsToCategory,
  }) : super(key: key);

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _form = GlobalKey<FormState>();
  bool edit = false;
  int? todoId;
  String? todoTitle;
  String? todoCatId;
  String? todoDesc;
  DateTime? dateTime;
  bool? isCompleted;

  @override
  void initState() {
    if (widget.todoToEdit != null) {
      edit = true;
      todoId = widget.todoToEdit!.id;
      todoTitle = widget.todoToEdit!.title;
      todoCatId = widget.todoToEdit!.categoryId;
      todoDesc = widget.todoToEdit!.description;
      dateTime = widget.todoToEdit!.dateTime;
      isCompleted = widget.todoToEdit!.completed;
    } else if (widget.belongsToCategory != null) {
      todoCatId = widget.belongsToCategory;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: edit ? const Text('Edit task') : const Text('Create new Task'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: IconButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    _form.currentState!.save();
                    dateTime ??= DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    );
                    todoDesc ??= '';
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (edit) {
                      context.read<TodoListBloc>().add(
                            EditTodoEvent(
                              id: todoId!,
                              newTitle: todoTitle!,
                              newCatId: todoCatId!,
                              newDescription: todoDesc,
                              newDateTime: dateTime!,
                              isCompleted: isCompleted!,
                            ),
                          );
                    } else {
                      context.read<TodoListBloc>().add(
                            AddTodoEvent(
                              todoTitle: todoTitle!,
                              todoCatId: todoCatId!,
                              todoDescription: todoDesc,
                              dateTime: dateTime!,
                            ),
                          );
                    }

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 700),
                        content: Row(
                          children: [
                            edit
                                ? const Text('Task edited')
                                : const Text('New task added'),
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
                    if (widget.isCreatedFromMainPage) {
                      Navigator.pushReplacementNamed(
                        context,
                        TasksPage.routeName,
                      );
                    } else {
                      Navigator.pop(
                        context,
                        //Return todo if edit mode
                        //for updating TaskDetail page
                        Todo(
                          id: todoId,
                          categoryId: todoCatId!,
                          title: todoTitle!,
                          dateTime: dateTime!,
                          description: todoDesc,
                          completed: isCompleted ?? false,
                        ),
                      );
                    }
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
                  FilteringTextInputFormatter.allow(
                    RegExp("[a-zA-Zа-яА-Я /-?!#&%()@]"),
                  ),
                ],
                cursorColor: Colors.green,
                initialValue: todoTitle ?? '',
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
                  FilteringTextInputFormatter.allow(
                    RegExp("[a-zA-Zа-яА-Я /-?!#&%()@]"),
                  ),
                ],
                cursorColor: Colors.green,
                initialValue: todoDesc ?? '',
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
                      bool isCategoryExist = false;
                      if (todoCatId != null) {
                        for (Category cat in state.categories) {
                          if (cat.id.toString() == todoCatId) {
                            isCategoryExist = true;
                          } else {
                            isCategoryExist = false;
                          }
                        }
                      }
                      return CustomDropdown(
                        itemsList: state.categories,
                        defaultValue: isCategoryExist == false
                            ? state.categories[0].id.toString()
                            : todoCatId,
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
                      dateTime = DateTime(
                        value.year,
                        value.month,
                        value.day,
                      );
                    },
                    initialDate: dateTime ?? DateTime.now(),
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
