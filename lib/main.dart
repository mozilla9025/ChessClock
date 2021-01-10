import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/card.dart';
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
      _isPlaying = !_isPlaying;
    });
  }

  void _reset() {
    setState(() {
      _isPlaying = false;
      _stepTurn = StepTurn.WHITE;
      _isReset = true;
    });
    setState(() {
      _isReset = false;
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
      child: Container(
        decoration: BoxDecoration(color: Color(0xFF4D4F53)),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SideCard(
                duration: 300000,
                isReset: _isReset,
                textColor: Colors.black,
                rotations: 2,
                color: Colors.white,
                isPlaying: _isPlaying,
                onTapped: _handleWhiteTurnCommit,
                isCurrentStep: _stepTurn == StepTurn.WHITE,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    color: Colors.white,
                    enableFeedback: true,
                    iconSize: 48.0,
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _togglePlaying,
                  ),
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: _stepTurn == StepTurn.WHITE
                          ? Colors.white
                          : Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    enableFeedback: true,
                    iconSize: 48.0,
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _reset,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: SideCard(
                duration: 300000,
                isReset: _isReset,
                textColor: Colors.white,
                rotations: 0,
                color: Colors.black,
                isPlaying: _isPlaying,
                onTapped: _handleBlackTurnCommit,
                isCurrentStep: _stepTurn == StepTurn.BLACK,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
