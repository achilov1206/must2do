import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './blocs/block.dart';
import './theme/themes.dart';
import './pages/todo_page2/create_category_page.dart';
import './pages/todo_page2/create_task_page.dart';
import './pages/todo_page2/tasks_page.dart';
import './pages/todo_page2/app_page.dart';
import './pages/todo_page2/todo_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<TodoFilterBloc>(
        //   create: (context) => TodoFilterBloc(),
        // ),
        // BlocProvider<TodoSearchBloc>(
        //   create: (context) => TodoSearchBloc(),
        // ),
        BlocProvider<TodoListBloc>(
          create: (context) => TodoListBloc(),
        ),
        // BlocProvider<ActiveTodoCountBloc>(create: (context) {
        //   final initialActiveTodoCount =
        //       context.read<TodoListBloc>().state.todos.length;
        //   return ActiveTodoCountBloc(
        //     initialActiveTodoCount: initialActiveTodoCount,
        //   );
        // }),
        // BlocProvider<FilteredTodosBloc>(
        //   create: (context) => FilteredTodosBloc(
        //     initialTodos: context.read<TodoListBloc>().state.todos,
        //   ),
        // ),
        BlocProvider<CategoryListBloc>(
          create: ((context) => CategoryListBloc()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Must2Do',
        theme: initialTheme,
        initialRoute: AppPage.routeName,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case AppPage.routeName:
              return MaterialPageRoute(
                builder: (context) => const AppPage(),
              );
            case CreateTaskPage.routeName:
              return MaterialPageRoute(
                builder: (context) => const CreateTaskPage(),
                fullscreenDialog: true,
              );
            case TasksPage.routeName:
              return MaterialPageRoute(
                builder: (context) => const TasksPage(),
              );
            case CreateCategoryPage.routeName:
              return MaterialPageRoute(
                builder: (context) => const CreateCategoryPage(),
                fullscreenDialog: true,
              );
            case TodoDetail.routeName:
              return MaterialPageRoute(
                builder: (context) => const TodoDetail(),
                fullscreenDialog: true,
              );
          }
          return null;
        },
      ),
    );
  }
}
