import 'package:flutter/material.dart';
import 'package:game_2048/game_logic.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameBoard(title: 'Flutter Demo Home Page'),
    );
  }
}

class GameBoard extends StatefulWidget {
  GameBoard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  CurvedAnimation _curveOut;
  CurvedAnimation _curveIn;

  Start2048 gameLogic;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    _controller.addListener((){
      if(_controller.value > 0.8)
    });
    _curveOut = CurvedAnimation(parent: _controller, curve: Curves.linear);

    gameLogic = Start2048(board);
    gameLogic.addRandomTwos();
    super.initState();
  }
  List<List<int>> board = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
  ];
  double initialX;
  double initialY;
  double distanceX;
  double distanceY;

  @override
  Widget build(BuildContext context) {
    List<Widget> listOfWidgets = [];
    for (int i = 0; i < 4; i++) {
      listOfWidgets.add(gameRow(
        curveAnimation: _curveOut,
        gameLogic: gameLogic,
        rowNumber: i,
      ));
    }
    Future<void> showGameEndDialog(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game ended'),
            content: const Text('Please reset the game'),
            actions: <Widget>[
              FlatButton(
                child: Text('Reset'),
                onPressed: () {
                  gameLogic.reset();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: (details) => initialX = details.globalPosition.dx,
        onHorizontalDragUpdate: (details) => distanceX = details.globalPosition.dx - initialX,
        onVerticalDragStart: (details) => initialY = details.globalPosition.dy,
        onVerticalDragUpdate: (details) => distanceY = details.globalPosition.dy - initialY,
        onHorizontalDragEnd: (velocity) async{
          print("Horizontal: $distanceX");
          if(gameLogic.checkItGameEnded() ){
              distanceX > 0
                ? gameLogic.rightSwipe()
                : gameLogic.leftSwipe();
              gameLogic.addRandomTwos();
          }
          else
          {showGameEndDialog(context);
          gameLogic.reset();
          }
          await _controller.forward();
          _controller.reset();

          setState(() {});
        },
        onVerticalDragEnd: (velocity) async{
          if(gameLogic.checkItGameEnded() ){
            print("Verticle: $distanceY");
            distanceY < 0
                ? gameLogic.upSwipe()
                : gameLogic.downSwipe();
            gameLogic.addRandomTwos();
            await _controller.forward();
            _controller.reset();
          }
          else
            {showGameEndDialog(context);
            gameLogic.reset();
            }
          setState(() {});
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: listOfWidgets,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class gameRow extends StatelessWidget {
  int rowNumber;
  CurvedAnimation curveAnimation;
  gameRow({
    Key key,

    @required this.curveAnimation,
    @required this.gameLogic,
    @required this.rowNumber,
  }) : super(key: key);

  final Start2048 gameLogic;

  @override
  Widget build(BuildContext context) {
    List<Widget> cells = [];
    for (int i = 0; i < 4; i++)
      cells.add(
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.teal,
          ),
          child: Center(
              child: SlideTransition(
               position: Tween<Offset>(
                 begin: Offset.zero,
                 end: Offset(1.0, 1.0),
               ).animate(curveAnimation),
                child: Text(
            gameLogic.board[this.rowNumber][i].toString(),
            style: TextStyle(fontSize: 36, color: Colors.white),
          ),
              )),
        ),
      );
//    https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTEHYlZnGhpKufHZIMjKgAgyeAdnNMzf6sPQr1Xs81z3G8eGgYB
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: cells,
    );
  }
}

