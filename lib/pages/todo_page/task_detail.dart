import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../blocs/block.dart';
import '../../models/todo_model.dart';
import '../../models/category_model.dart';
import '../../repositories/category_repository.dart';

import './create_task_page.dart';

class TaskDetail extends StatefulWidget {
  static const routeName = '/todo-detail';

  //Getting todo from onGenerateRoute arguments
  final Todo? todo;
  const TaskDetail({Key? key, this.todo}) : super(key: key);

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Todo? todo;
  @override
  void initState() {
    todo = widget.todo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        //height: 400,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showDetailInfo(
              label: 'Task',
              text: todo!.title,
            ),
            const SizedBox(height: 5),
            showDetailInfo(
              label: 'Description',
              text: todo!.description,
            ),
            const Divider(
              color: Colors.black54,
              height: 5,
            ),
            const SizedBox(height: 10),
            FutureBuilder(
              future: context
                  .read<CategoryRepository>()
                  .getCategory(int.parse(todo!.categoryId)),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Category cat = snapshot.data as Category;
                  return showDetailInfo(
                    label: 'Belongs to',
                    text: cat.title,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            const SizedBox(height: 5),
            showDetailInfo(
              label: 'Due date',
              text: DateFormat("dd-MMM-yyyy").format(todo!.dateTime),
            ),
            const SizedBox(height: 5),
            showDetailInfo(
              label: 'Task status',
              text: todo!.completed == false ? 'Not completed' : 'Completed',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CreateTaskPage.routeName,
                        arguments: {
                          'isCreatedFromMainPage': false,
                          'todo': todo,
                        }).then(
                      (newTodo) {
                        if (newTodo != null) {
                          setState(() {
                            todo = newTodo as Todo;
                          });
                        }
                      },
                    );
                  },
                  child: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Are you sure?'),
                          content: const Text('Do yot really want to delete?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<TodoListBloc>().add(
                                      RemoveTodoEvent(todo: todo!),
                                    );
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget showDetailInfo({String? label, String? text}) {
    return RichText(
      text: TextSpan(
        text: '$label:  ',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
