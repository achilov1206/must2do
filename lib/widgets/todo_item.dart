import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/block.dart';
import '../models/todo_model.dart';
import '../pages/todo_page/task_detail.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
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

  Widget todoItem(Todo todo) {
    return Container(
      decoration: BoxDecoration(
        color: todo.completed
            ? Colors.grey.withOpacity(0.2)
            : Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(
            context,
            TaskDetail.routeName,
            arguments: todo,
          );
        },
        leading: Checkbox(
          value: todo.completed,
          onChanged: (bool? checked) {
            context.read<TodoListBloc>().add(ToggleTodoEvent(todo: todo));
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          todo.description!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.todo.id),
      background: showBackground(0),
      secondaryBackground: showBackground(1),
      child: todoItem(
        widget.todo,
      ),
      onDismissed: (_) async {
        context.read<TodoListBloc>().add(
              RemoveTodoEvent(todo: widget.todo),
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
}
