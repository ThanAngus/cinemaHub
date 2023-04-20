import 'package:flutter/cupertino.dart';

class ItemModel {
  final int? index;
  final String? text;
  final IconData? icon;
  final IconData? unselectedIcon;

  ItemModel({
    this.index,
    this.text,
    this.icon,
    this.unselectedIcon,
  });
}
