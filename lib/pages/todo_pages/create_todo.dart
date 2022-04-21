import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/block.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key}) : super(key: key);

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final TextEditingController newTodoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newTodoController,
      decoration: const InputDecoration(
        label: Text('What to do next'),
      ),
      onSubmitted: (String? desc) {
        if (desc != null && desc.trim().isNotEmpty) {
          // context.read<TodoListBloc>().add(
          //       AddTodoEvent(
          //         todoDescription: desc,
          //       ),
          //     );
          newTodoController.clear();
        }
      },
    );
  }

  @override
  void dispose() {
    newTodoController.dispose();
    super.dispose();
  }
}
