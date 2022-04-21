import 'package:flutter/material.dart';

class TodoDetail extends StatelessWidget {
  static const routeName = '/todo-detail';
  const TodoDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
      ),
    );
  }
}
