import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './blocs/block.dart';
import './theme/themes.dart';
import './pages/todo_page/create_category_page.dart';
import './pages/todo_page/create_task_page.dart';
import './pages/todo_page/tasks_page.dart';
import './pages/todo_page/app_page.dart';
import './pages/todo_page/task_detail.dart';
import './models/category_dao.dart';
import './models/todo_dao.dart';
import './models/todo_model.dart';
import 'repositories/category_repository.dart';
import 'repositories/todo_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CategoryRepository(
            catDao: CategoryDao(),
          ),
        ),
        RepositoryProvider(
          create: (context) => TodoRepository(
            todoDao: TodoDao(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CategoryListBloc>(
            create: (context) => CategoryListBloc(
              categoryRepository: context.read<CategoryRepository>(),
            ),
          ),
          BlocProvider<TodoListBloc>(
            create: (context) => TodoListBloc(
              todoRepository: context.read<TodoRepository>(),
            ),
          ),
          BlocProvider<CalendarTodoCubit>(
            create: (context) => CalendarTodoCubit(
              todoRepository: context.read<TodoRepository>(),
            ),
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
                final arguments = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) => CreateTaskPage(
                    isCreatedFromMainPage: arguments['isCreatedFromMainPage'],
                    todoToEdit: arguments['todo'],
                  ),
                  fullscreenDialog: true,
                );
              case TasksPage.routeName:
                final args = settings.arguments;
                return MaterialPageRoute(
                  builder: (context) => TasksPage(args: args),
                );
              case CreateCategoryPage.routeName:
                return MaterialPageRoute(
                  builder: (context) => const CreateCategoryPage(),
                  fullscreenDialog: true,
                );
              case TaskDetail.routeName:
                final todo = settings.arguments as Todo;
                return MaterialPageRoute(
                  builder: (context) => TaskDetail(todo: todo),
                  fullscreenDialog: true,
                );
            }
            return null;
          },
        ),
      ),
    );
  }
}
