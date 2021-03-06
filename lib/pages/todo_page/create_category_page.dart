import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import '../../blocs/block.dart';
import '../../models/category_model.dart';

class CreateCategoryPage extends StatefulWidget {
  static const routeName = '/create-category-page';
  final Category? category;
  const CreateCategoryPage({Key? key, this.category}) : super(key: key);

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final _form = GlobalKey<FormState>();
  bool _edit = false;
  String? _catTitle;
  IconData? _catIcon;

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.cupertino]);

    _catIcon = icon;
    setState(() {});

    debugPrint('Picked Icon:  $icon');
  }

  @override
  void initState() {
    if (widget.category != null) {
      _edit = true;
      _catTitle = widget.category!.title;
      _catIcon = widget.category!.icon;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _edit
            ? const Text('Edit Category')
            : const Text('Create new Category'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: IconButton(
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    _form.currentState!.save();
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_edit) {
                      context.read<CategoryListBloc>().add(
                            EditCategoryEvent(
                              id: widget.category!.id!,
                              title: _catTitle!,
                              icon: _catIcon!,
                            ),
                          );
                    } else {
                      context.read<CategoryListBloc>().add(
                            AddCategoryEvent(
                              title: _catTitle!,
                              icon: _catIcon ?? Icons.circle,
                            ),
                          );
                    }
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 700),
                        content: Row(
                          children: [
                            _edit
                                ? const Text('Task edited')
                                : const Text('New task added'),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Go back'),
                            ),
                          ],
                        ),
                      ),
                    );
                    _form.currentState!.reset();
                    Navigator.pop(context);
                    // if (widget.isCreatedFromMainPage) {
                    //   Navigator.pushReplacementNamed(
                    //     context,
                    //     TasksPage.routeName,
                    //   );
                    // } else {
                    //   Navigator.pop(context);
                    // }
                  }
                },
                icon: const Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 40,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp("[0-9a-zA-Z /-?!#&%()]")),
                ],
                cursorColor: Colors.green,
                initialValue: _catTitle ?? '',
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter category title',
                  floatingLabelStyle: TextStyle(color: Colors.green),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _catTitle = value;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickIcon,
                    child: const Text('Select Icon'),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      _catIcon,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
