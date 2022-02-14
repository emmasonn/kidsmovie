// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class RecentSearchDropDown<T> extends PopupMenuEntry<T> {
  const RecentSearchDropDown({
    Key? key,
    required this.value,
    required this.text,
    required this.callback,
  }) : super(key: key);
  final String value;
  final String text;
  final Function? callback;

  @override
  _RecentSearchDropDownState<T> createState() =>
      _RecentSearchDropDownState<T>();

  @override
  double get height => 32;

  @override
  bool represents(T? value) => this.value == value;
}

class _RecentSearchDropDownState<T> extends State<RecentSearchDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: size.width),
      child: Container(
        constraints: BoxConstraints(minWidth: 30),
        child: ListTile(
          title: Text(
            widget.text,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold),
          ),
          trailing: GestureDetector(
            onTap: () {
              if (widget.callback != null) {
                widget.callback!();
              }
            },
            child: Icon(
              Icons.close,
              color: Colors.grey,
              semanticLabel: 'remove',
            ),
          ),
        ),
      ),
    );
  }
}
