import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:must2do/pages/todo_page/create_category_page.dart';
import '../blocs/block.dart';
import '../models/category_model.dart';
import '../repositories/todo_repository.dart';
import './dialog_with_checkbox.dart';

class CatgoryCard extends StatefulWidget {
  final Category? cat;
  final Color? iconColor;
  final Color? titleColor;
  final String? routeName;
  final bool byCategoryId;
  const CatgoryCard(
    this.cat, {
    Key? key,
    this.iconColor,
    this.titleColor,
    this.routeName,
    this.byCategoryId = false,
  }) : super(key: key);

  @override
  State<CatgoryCard> createState() => _CatgoryCardState();
}

class _CatgoryCardState extends State<CatgoryCard> {
  bool _onLongPress = false;
  int _onLongPressSeconds = 10;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double width = (screenWidth / 2) - 30;
    return SizedBox(
      height: 200,
      width: width,
      child: InkWell(
        splashColor: Colors.green,
        onLongPress: () {
          setState(() {
            _onLongPress = true;
          });
        },
        onTap: () {
          if (widget.routeName != null) {
            if (widget.byCategoryId == true) {
              if (_onLongPress == true) {
                setState(() {
                  _onLongPress = false;
                });
              } else {
                Navigator.pushNamed(
                  context,
                  widget.routeName!,
                  arguments: {
                    'byCategoryId': widget.byCategoryId,
                    'cat': widget.cat,
                  },
                );
              }
            } else {
              Navigator.pushNamed(
                context,
                widget.routeName!,
                arguments: {},
              );
            }
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_onLongPress == true && widget.byCategoryId == true)
                  //Close edit and delete bottom container when tapped
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(
                          0.3,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  child: Icon(
                    widget.cat!.icon,
                    size: 80,
                    color: widget.iconColor ?? Colors.black54,
                  ),
                ),
                Positioned(
                  top: 110,
                  left: 0,
                  right: 0,
                  child: Text(
                    widget.cat!.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(
                      color: widget.titleColor ?? Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                //Show Tasks count if categoryId given
                if (widget.byCategoryId == true)
                  BlocConsumer<TodoListBloc, TodoListState>(
                    builder: (context, state) {
                      return BlocProvider(
                        create: (context) => ActiveTodoCountCubit(
                          catId: widget.cat!.id.toString(),
                          todoRepository: context.read<TodoRepository>(),
                        ),
                        child: BlocBuilder<ActiveTodoCountCubit,
                            ActiveTodoCountState>(
                          builder: (context, state) {
                            context.read<ActiveTodoCountCubit>().countTodo();
                            String output =
                                state.activeTodoCount > 1 ? 'tasks' : 'task';
                            return Positioned(
                              top: 130,
                              left: 0,
                              right: 0,
                              child: Text(
                                '${state.activeTodoCount.toString()} $output left',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    listener: (context, state) {},
                  ),
                if (widget.byCategoryId == true)
                  //edit and delete bottom container
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      onEnd: () async {
                        //Close container after n seconds
                        Future.delayed(Duration(seconds: _onLongPressSeconds))
                            .then((value) {
                          setState(() {
                            _onLongPress = false;
                          });
                        });
                      },
                      opacity: _onLongPress ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (_onLongPress)
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    CreateCategoryPage.routeName,
                                    arguments: {'category': widget.cat},
                                  );
                                },
                                label: const Text('Edit'),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                            if (_onLongPress)
                              TextButton.icon(
                                onPressed: () async {
                                  setState(() {
                                    _onLongPressSeconds = 999;
                                  });
                                  //show dialog once delete
                                  Map popValues = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return const DialogWithCheckBox();
                                    },
                                  );
                                  if (popValues['delete']) {
                                    context.read<CategoryListBloc>().add(
                                          RemoveCategoryEvent(
                                            category: widget.cat!,
                                          ),
                                        );
                                    if (popValues['checked'] == true) {
                                      context.read<TodoListBloc>().add(
                                            RemoveTodosWhereByCatIdEvent(
                                              id: widget.cat!.id.toString(),
                                            ),
                                          );
                                    }
                                    setState(() {
                                      _onLongPressSeconds = 10;
                                    });
                                  } else {
                                    setState(() {
                                      _onLongPress = false;
                                      _onLongPressSeconds = 10;
                                    });
                                  }
                                },
                                label: const Text('Delete'),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
