import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, text;
  final int currentTime;

  final ValueSetter<int> onPicked;

  const CustomDialogBox({
    Key key,
    @required this.title,
    @required this.text,
    @required this.currentTime,
    @required this.onPicked,
  }) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  int _pickedTime;

  @override
  Widget build(BuildContext context) {
    _updateTime(widget.currentTime);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      borderOnForeground: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              widget.title.toUpperCase(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          GestureDetector(
            onTap: () {
              _updateTime(Constants.twoMinInMs);
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text(
                "2 min",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _pickedTime == Constants.twoMinInMs
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _updateTime(Constants.fiveMinInMs);
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text(
                "5 min",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _pickedTime == Constants.fiveMinInMs
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _updateTime(Constants.tenMinInMs);
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text(
                "10 min",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: _pickedTime == Constants.tenMinInMs
                      ? Colors.blue
                      : Colors.grey,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                widget.onPicked(_pickedTime);
              },
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B1B),
                ),
                child: Text(
                  widget.text.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateTime(int time) {
    setState(() {
      _pickedTime = time;
    });
  }
}
