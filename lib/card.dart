import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SideCard extends StatefulWidget {
  final Color color;
  final Color textColor;
  final int rotations;
  final int duration;
  final bool isReset;
  final bool isPlaying;
  final bool isCurrentStep;
  final VoidCallback onTapped;

  SideCard({
    Key key,
    @required this.color,
    @required this.textColor,
    @required this.rotations,
    @required this.duration,
    @required this.isReset,
    @required this.isCurrentStep,
    @required this.isPlaying,
    @required this.onTapped,
  }) : super(key: key);

  @override
  _SideCardState createState() => _SideCardState();
}

class _SideCardState extends State<SideCard> {
  int _timePassed = 0;
  bool _timerIsRunning = false;
  int _turnCount = 0;
  final DateFormat _dateFormat = DateFormat("mm:ss");

  void _setTimer() {
    if (_timerIsRunning) return;
    setState(() {
      _timerIsRunning = true;
    });
    _nextTick();
  }

  void _stopTimer() {
    setState(() {
      _timerIsRunning = false;
    });
  }

  void _nextTick() {
    Timer(
      Duration(milliseconds: 100),
      () {
        _updateTime();
        if (widget.duration >= _timePassed + 100 && _timerIsRunning) {
          _nextTick();
        }
      },
    );
  }

  void _updateTime() {
    setState(() {
      _timePassed += 100;
    });
  }

  void _handleTap() {
    if (!widget.isCurrentStep) return;
    setState(() {
      _timerIsRunning = false;
      _turnCount++;
    });
    widget.onTapped();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPlaying && widget.isCurrentStep) {
      _setTimer();
    } else {
      _stopTimer();
    }

    if (widget.isReset) {
      setState(() {
        _timePassed = 0;
      });
    }

    return GestureDetector(
      onTap: _handleTap,
      child: RotatedBox(
        quarterTurns: widget.rotations,
        child: Container(
          color: widget.color,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  _dateFormat.format(
                    DateTime.fromMillisecondsSinceEpoch(
                      widget.duration - _timePassed,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 64.0,
                    color: widget.textColor ?? Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
