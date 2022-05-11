import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/block.dart';
import '../../models/todo_model.dart';
import './create_task_page.dart';
import './app_page.dart';
import '../../utils/error_dialog.dart';
import '../../widgets/todo_item.dart';

class TasksPage extends StatelessWidget {
  // args may contains map = {'byCategoryId':boolean, 'cat': Category()} which provided by CategoryPage
  // if args exist show tasks according category
  // else show new tasks
  final dynamic args;
  static const routeName = '/tasks-page';
  const TasksPage({Key? key, this.args}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //
    String title = 'All Fresh Tasks';

    if (args != null) {
      title = args['cat'].title;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppPage.routeName,
                (route) => false,
              );
            },
            icon: const Icon(Icons.grid_view_outlined),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            BlocBuilder<TodoListBloc, TodoListState>(
              builder: (context, state) {
                List<Widget> _widgetsList = [];
                //Get tasks by Categories if args not null
                //else get all not new tasks
                if (args != null) {
                  context
                      .read<TodoListBloc>()
                      .add(GetTodosEvent(catId: args['cat'].id.toString()));
                } else {
                  context.read<TodoListBloc>().add(const GetTodosEvent());
                }

                if (state.todoListStatus == TodoListStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.todoListStatus == TodoListStatus.error) {
                  errorDialog(context, state.error);
                } else if (state.todoListStatus == TodoListStatus.empty) {
                  return Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: const Text('Add your first Task'),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          CreateTaskPage.routeName,
                          // isCreatedFromMainPage false - pop to TasksPage
                          // isCreatedFromMainPage true - pop till main page
                          arguments: {
                            'isCreatedFromMainPage': false,
                            //'belongsToCategory': '',
                          },
                        );
                      },
                    ),
                  );
                }
                // change dateTimeLabel to today and tomorrow
                state.todos.forEach((key, todos) {
                  String dateLabel;
                  if (key == DateFormat("dd-MMM").format(DateTime.now())) {
                    dateLabel = 'Today';
                  } else if (key ==
                      DateFormat("dd-MMM").format(DateTime.now().add(
                        const Duration(days: 1),
                      ))) {
                    dateLabel = 'Tomorrow';
                  } else {
                    dateLabel = key;
                  }
                  _widgetsList.add(listSectionSeparator(context, dateLabel));
                  for (Todo todo in todos) {
                    _widgetsList.add(TodoItem(todo: todo));
                  }
                });
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _widgetsList,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  //Separator for Tasks list with date label
  Widget listSectionSeparator(BuildContext context, String dateLabel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dateLabel,
          style: const TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              CreateTaskPage.routeName,
              // isCreatedFromMainPage false - pop to TasksPage
              // isCreatedFromMainPage true - pop till main page
              arguments: {'isCreatedFromMainPage': false},
            );
          },
          icon: const Icon(
            Icons.add_circle_outline_outlined,
            color: Colors.green,
            size: 30,
          ),
        ),
      ],
    );
  }
}
