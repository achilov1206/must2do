// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../blocs/block.dart';

// import '../../models/todo_model.dart';

// class ShowTodos extends StatelessWidget {
//   const ShowTodos({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final todos = context.watch<FilteredTodosBloc>().state.filteredTodos;
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<TodoListBloc, TodoListState>(
//           listener: (context, state) {
//             context.read<FilteredTodosBloc>().add(
//                   SetFilteredTodosEvent(
//                     todos: state.todos,
//                     filter: context.read<TodoFilterBloc>().state.filter,
//                     searchTerm: context.read<TodoSearchBloc>().state.searchTerm,
//                   ),
//                 );
//           },
//         ),
//         BlocListener<TodoFilterBloc, TodoFilterState>(
//           listener: (context, state) {
//             context.read<FilteredTodosBloc>().add(
//                   SetFilteredTodosEvent(
//                     todos: context.read<TodoListBloc>().state.todos,
//                     filter: state.filter,
//                     searchTerm: context.read<TodoSearchBloc>().state.searchTerm,
//                   ),
//                 );
//           },
//         ),
//         BlocListener<TodoSearchBloc, TodoSearchState>(
//           listener: (context, state) {
//             context.read<FilteredTodosBloc>().add(
//                   SetFilteredTodosEvent(
//                     todos: context.read<TodoListBloc>().state.todos,
//                     filter: context.read<TodoFilterBloc>().state.filter,
//                     searchTerm: state.searchTerm,
//                   ),
//                 );
//           },
//         ),
//       ],
//       child: ListView.separated(
//         primary: false,
//         shrinkWrap: true,
//         itemCount: todos.length,
//         separatorBuilder: (BuildContext context, int index) {
//           return const Divider(
//             color: Colors.grey,
//           );
//         },
//         itemBuilder: (BuildContext context, int index) {
//           return Dismissible(
//             key: ValueKey(todos[index].id),
//             background: showBackground(0),
//             secondaryBackground: showBackground(1),
//             child: TodoItem(
//               todo: todos[index],
//             ),
//             onDismissed: (_) {
//               context
//                   .read<TodoListBloc>()
//                   .add(RemoveTodoEvent(todo: todos[index]));
//             },
//             confirmDismiss: (_) {
//               return showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: const Text('Are you sure?'),
//                       content: const Text('Do yot really want to delete?'),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, false),
//                           child: const Text('No'),
//                         ),
//                         TextButton(
//                           onPressed: () => Navigator.pop(context, true),
//                           child: const Text('Yes'),
//                         ),
//                       ],
//                     );
//                   });
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget showBackground(int direction) {
//     return Container(
//       margin: const EdgeInsets.all(4),
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       color: Colors.red.withOpacity(0.2),
//       alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
//       child: const Icon(
//         Icons.delete,
//         size: 30,
//         color: Colors.white,
//       ),
//     );
//   }
// }

// class TodoItem extends StatefulWidget {
//   final Todo? todo;
//   const TodoItem({Key? key, this.todo}) : super(key: key);

//   @override
//   State<TodoItem> createState() => _TodoItemState();
// }

// class _TodoItemState extends State<TodoItem> {
//   late final TextEditingController textEditingController;
//   @override
//   void initState() {
//     textEditingController = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         showDialog(
//             context: context,
//             builder: (context) {
//               bool _error = false;
//               textEditingController.text = widget.todo!.description!;
//               return StatefulBuilder(
//                   builder: (BuildContext context, StateSetter setState) {
//                 return AlertDialog(
//                   title: const Text('Edit todo'),
//                   content: TextField(
//                     controller: textEditingController,
//                     autofocus: true,
//                     decoration: InputDecoration(
//                       errorText: _error ? "Value can not be null" : null,
//                     ),
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Cancel'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           _error =
//                               textEditingController.text.isEmpty ? true : false;
//                           if (!_error) {
//                             // context.read<TodoListBloc>().add(
//                             //       EditTodoEvent(
//                             //         id: widget.todo!.id,
//                             //         newDescription: textEditingController.text,
//                             //       ),
//                             //     );
//                             Navigator.pop(context);
//                           }
//                         });
//                       },
//                       child: const Text('Edit'),
//                     ),
//                   ],
//                 );
//               });
//             });
//       },
//       leading: Checkbox(
//         value: widget.todo!.completed,
//         onChanged: (bool? checked) {
//           // context.read<TodoListBloc>().add(
//           //       ToggleTodoEvent(
//           //         id: widget.todo!.id!,
//           //       ),
//           //     );
//         },
//       ),
//       title: Text(widget.todo!.description!),
//     );
//   }
// }
