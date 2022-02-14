import 'package:flutter/material.dart';

class CustomDropDownMenuItem<T> extends PopupMenuEntry<T> {
  const CustomDropDownMenuItem({
    Key? key,
    required this.value,
    required this.text,
    required this.callback,
  }) : super(key: key);

  final T value;
  final String text;
  final Function? callback;

  @override
  _CustomDropDownMenuItem<T> createState() => _CustomDropDownMenuItem<T>();

  @override
  double get height => 32.0;

  @override
  bool represents(T? value) => this.value == value;
}

class _CustomDropDownMenuItem<T> extends State<CustomDropDownMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 120.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(widget.value);
        },
        child: Container(
          constraints: BoxConstraints(minWidth: 30.0),
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
                semanticLabel: 'back',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
