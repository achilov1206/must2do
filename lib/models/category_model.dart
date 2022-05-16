import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

//Name for DataBase Table
const String categoryTableName = 'category';

//DataBase fileds name
class CategoryFields {
  static const List<String> columns = [
    id,
    title,
    icon,
  ];
  static const String id = 'id';
  static const String title = 'title';
  static const String icon = 'icon';
}

class Category extends Equatable {
  final int? id;
  final String title;
  final IconData icon;
  const Category({
    this.id,
    required this.title,
    this.icon = Icons.category,
  });

  @override
  List<Object?> get props => [id, title, icon];

  @override
  String toString() => 'Category(id: $id, title: $title, icon: $icon)';

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({CategoryFields.id: id});
    result.addAll({CategoryFields.title: title});
    result.addAll({CategoryFields.icon: jsonEncode(iconToCodeData(icon))});

    return result;
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    IconData icon =
        retrieveIconFromCodeData(jsonDecode(map[CategoryFields.icon]));
    return Category(
      id: map[CategoryFields.id],
      title: map[CategoryFields.title],
      icon: icon,
    );
  }
  factory Category.initialCategory() {
    return const Category(title: '');
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  static Map<String, dynamic> iconToCodeData(IconData icon) {
    return {
      'icon_code_point': icon.codePoint,
      'icon_font_family': icon.fontFamily,
      'icon_font_package': icon.fontPackage,
      'icon_direction': icon.matchTextDirection,
    };
  }

  static IconData retrieveIconFromCodeData(Map<String, dynamic> iconCodeData) {
    return IconData(
      iconCodeData['icon_code_point'],
      fontFamily: iconCodeData['icon_font_family'],
      fontPackage: iconCodeData['icon_font_package'],
      matchTextDirection: iconCodeData['icon_direction'],
    );
  }
}
