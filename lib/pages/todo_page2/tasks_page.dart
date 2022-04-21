import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/block.dart';
import '../../models/todo_model.dart';
import './create_task_page.dart';
import './app_page.dart';
import './todo_detail.dart';

class TasksPage extends StatelessWidget {
  static const routeName = '/tasks-page';
  const TasksPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppPage.routeName);
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
                context.watch<TodoListBloc>().add(GetTodos());
                List<Widget> _widgetsList = [];
                state.todos.forEach((key, todos) {
                  _widgetsList.add(listSectionSeparator(context, key));
                  for (Todo todo in todos) {
                    _widgetsList.add(listItem(context, todo));
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

  Widget listItem(BuildContext context, Todo todo) {
    return Dismissible(
      key: ValueKey(todo.id),
      background: showBackground(0),
      secondaryBackground: showBackground(1),
      child: TodoItem(
        todo: todo,
      ),
      onDismissed: (_) {
        context.read<TodoListBloc>().add(
              RemoveTodoEvent(todo: todo),
            );
      },
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do yot really want to delete?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
            Navigator.pushNamed(context, CreateTaskPage.routeName);
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

  Widget showBackground(int direction) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red.withOpacity(0.2),
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo? todo;
  const TodoItem({Key? key, this.todo}) : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          TodoDetail.routeName,
          arguments: widget.todo,
        );
      },
      leading: Checkbox(
        value: widget.todo!.completed,
        onChanged: (bool? checked) {
          context.read<TodoListBloc>().add(ToggleTodoEvent(todo: widget.todo!));
        },
      ),
      title: Text(widget.todo!.title),
      subtitle: Text(widget.todo!.description!),
    );
  }
}
