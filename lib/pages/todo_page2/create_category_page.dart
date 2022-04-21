import 'package:flutter/material.dart';

class CreateCategoryPage extends StatelessWidget {
  static const routeName = '/create-category-page';
  const CreateCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create new Category')),
    );
  }
}
