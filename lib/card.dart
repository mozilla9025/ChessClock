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
  final VoidCallback onTimeIsOver;

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
    @required this.onTimeIsOver,
  }) : super(key: key);

  @override
  _SideCardState createState() => _SideCardState();
}

class _SideCardState extends State<SideCard> {
  int _timePassed = -100;
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
      if (_timePassed >= widget.duration) {
        widget.onTimeIsOver();
      }
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

  void _updateState() {
    if (widget.isPlaying && widget.isCurrentStep) {
      _setTimer();
    } else {
      _stopTimer();
    }

    if (widget.isReset) {
      setState(() {
        _timePassed = -100;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateState();
  }

  @override
  Widget build(BuildContext context) {
    _updateState();
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
                child: Transform.scale(
                  scale: widget.isCurrentStep ? 1.25 : 1,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
