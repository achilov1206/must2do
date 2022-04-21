// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../blocs/block.dart';
// import '../../models/todo_model.dart';

// class TodoHeader extends StatelessWidget {
//   const TodoHeader({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           "TODO",
//           style: TextStyle(fontSize: 40),
//         ),
//         BlocListener<TodoListBloc, TodoListState>(
//           listener: (context, state) {
//             final activeTodoCount = state.todos
//                 .where((Todo todo) => !todo.completed)
//                 .toList()
//                 .length;
//             context.read<ActiveTodoCountBloc>().add(
//                   CalculateActiveTodoCountEvent(
//                     activeTodoCount: activeTodoCount,
//                   ),
//                 );
//           },
//           child: BlocBuilder<ActiveTodoCountBloc, ActiveTodoCountState>(
//             builder: (context, state) {
//               return Text(
//                 '${state.activeTodoCount} active todo',
//                 style: const TextStyle(
//                   fontSize: 20,
//                   color: Colors.redAccent,
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
