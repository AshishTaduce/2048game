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

class _GameBoardState extends State<GameBoard> {
  List<List<int>> board = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
  ];

  Start2048 gameLogic;
  @override
  void initState() {
    gameLogic = Start2048(board);
    gameLogic.addRandomTwos();
    super.initState();
  }

  double initialX;
  double initialY;
  double distanceX;
  double distanceY;

  @override
  Widget build(BuildContext context) {
    List<Widget> listOfWidgets = [];
    for (int i = 0; i < 4; i++) {
      listOfWidgets.add(gameRow(
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
    double horizontal;
    double verticle;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: (details) => initialX = details.globalPosition.dx,
        onHorizontalDragUpdate: (details) => distanceX = details.globalPosition.dx - initialX,
        onVerticalDragStart: (details) => initialY = details.globalPosition.dy,
        onVerticalDragUpdate: (details) => distanceY = details.globalPosition.dy - initialY,
        onHorizontalDragEnd: (velocity) {
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
          setState(() {});
        },
        onVerticalDragEnd: (velocity) {
          if(gameLogic.checkItGameEnded() ){
            print("Verticle: $distanceY");
            distanceY < 0
                ? gameLogic.upSwipe()
                : gameLogic.downSwipe();
            gameLogic.addRandomTwos();
          }
          else
            {showGameEndDialog(context);
            gameLogic.reset();
            }
          setState(() {});
        },
        child: Container(
          color: Colors.red,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: listOfWidgets,
            ),
          ),
        ),
      ),
    );
  }
}

class gameRow extends StatelessWidget {
  int rowNumber;
  gameRow({
    Key key,
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
          padding: const EdgeInsets.all(8),
          child: Center(
              child: Text(
            gameLogic.board[this.rowNumber][i].toString(),
            style: TextStyle(fontSize: 36),
          )),
          color: Colors.teal[100],
        ),
      );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: cells,
    );
  }
}

