import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/card.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/dialog_box.dart';
import 'package:flutter_app/step_turn.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      theme: ThemeData(
        splashColor: Colors.black12,
        backgroundColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StepTurn _stepTurn = StepTurn.WHITE;
  bool _isPlaying = false;
  bool _isReset = false;
  int _totalTime = Constants.fiveMinInMs;

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  void _togglePlaying() {
    setState(() {
      _isReset = false;
      _isPlaying = !_isPlaying;
    });
  }

  void _reset(int time) {
    setState(() {
      _isPlaying = false;
      _stepTurn = StepTurn.WHITE;
      _isReset = true;
      _totalTime = time;
    });
  }

  void _handleWhiteTurnCommit() {
    setState(() {
      _stepTurn = StepTurn.BLACK;
    });
  }

  void _handleBlackTurnCommit() {
    setState(() {
      _stepTurn = StepTurn.WHITE;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: SideCard(
                  duration: _totalTime,
                  isReset: _isReset,
                  textColor: Colors.black,
                  rotations: 2,
                  color: const Color(0xFFF2F2F2),
                  isPlaying: _isPlaying,
                  onTapped: _handleWhiteTurnCommit,
                  onTimeIsOver: () => {_reset(_totalTime)},
                  isCurrentStep: _stepTurn == StepTurn.WHITE,
                ),
              ),
              Expanded(
                flex: 2,
                child: SideCard(
                  duration: _totalTime,
                  isReset: _isReset,
                  textColor: Colors.white,
                  rotations: 0,
                  color: const Color(0xFF1B1B1B),
                  isPlaying: _isPlaying,
                  onTapped: _handleBlackTurnCommit,
                  onTimeIsOver: () => {_reset(_totalTime)},
                  isCurrentStep: _stepTurn == StepTurn.BLACK,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildButton(
                    Icon(
                      Icons.timer_rounded,
                      color: const Color(0xFF28231F),
                    ),
                    _showTimePicker),
                _buildButton(
                    Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: const Color(0xFF28231F),
                    ),
                    _togglePlaying),
                _buildButton(
                  Icon(
                    Icons.refresh_rounded,
                    color: const Color(0xFF28231F),
                  ),
                  () => {_reset(_totalTime)},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(Icon icon, Function onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDAD8),
            blurRadius: 2.0,
            spreadRadius: 0.25,
          )
        ],
      ),
      padding: EdgeInsets.all(8.0),
      child: IconButton(
        enableFeedback: true,
        iconSize: 36.0,
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }

  void _showTimePicker() async {
    await showDialog(
      context: context,
      barrierColor: const Color(0x20000000),
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: "Pick game duration",
          text: "Confirm",
          currentTime: _totalTime,
          onPicked: (value) => {_reset(value)},
        );
      },
    );
  }
}
