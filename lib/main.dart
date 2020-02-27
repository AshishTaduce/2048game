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
    [0,0,0,0],
    [0,0,2,0],
    [0,0,0,0],
    [0,0,0,0],
  ];

Start2048 gameLogic;
  @override
  void initState() {
  gameLogic = Start2048(board);
  super.initState();
  }

  Function performMove(String input){
    Map<String, Function> listOfMoves = {
      "up": gameLogic.upSwipe,
      "down": gameLogic.downSwipe,
      "left": gameLogic.leftSwipe,
      "right": gameLogic.rightSwipe,
    };
    return listOfMoves[input];
  }
  double initialX = 0.0;
  double initialY = 0.0;
  double distanceX;
  double distanceY;

  @override
  Widget build(BuildContext context) {
    List<Widget> listOfWidgets = [];
    for(int i = 0; i < 4; i++){
      listOfWidgets.add(gameRow(gameLogic: gameLogic, rowNumber: i,));
    }
    listOfWidgets.add(Row(
      children: <Widget>[
        IconButton(icon: Icon(Icons.arrow_left), onPressed:(){
          gameLogic.leftSwipe();
          gameLogic.randomZeroPosition();
          setState(() {});},),
        IconButton(icon: Icon(Icons.arrow_drop_up), onPressed:() {
          if(gameLogic.checkItGameEnded()){
            performMove("up")();
            gameLogic.randomZeroPosition();
            setState(() {});
          }
          }),
        IconButton(icon: Icon(Icons.arrow_drop_down), onPressed:(){
          performMove("down")();
          gameLogic.randomZeroPosition();
          setState(() {});},),
        IconButton(icon: Icon(Icons.arrow_right), onPressed:(){
          performMove("right")();
          gameLogic.randomZeroPosition();
          setState(() {});},),
        IconButton(icon: Icon(Icons.access_alarm), onPressed:(){
          performMove("left")();
          gameLogic.randomZeroPosition();
          setState(() {});},),
      ],
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
//          onPanStart: (details){
//            initialX = details..dx;
//            initialY = details.globalPosition.dy;
//            setState(() {
//            });
//          },
          onPanUpdate: (DragUpdateDetails details) {
            distanceX= details.delta.dx;
            distanceY= details.delta.dx;
            setState(() {
            });
          },
          onPanEnd: (details){
            if (initialX - distanceX < 0) {
              gameLogic.rightSwipe();
            }
            else if (initialX - distanceX > 0) {
              gameLogic.leftSwipe();
            }
            else if (initialY - distanceY < 0) {
              gameLogic.upSwipe();
            }
            else if (initialY - distanceY > 0) {
              gameLogic.downSwipe();
            }
            if(distanceX != 0 || distanceY != 0) gameLogic.randomZeroPosition();
            setState(() {
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: listOfWidgets,
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
    List<Widget> cells= [];
    for(int i = 0; i < 4; i++) cells.add(Container(
      width: 75,
      height: 75,
      padding: const EdgeInsets.all(8),
      child: Center(child: Text(gameLogic.board[this.rowNumber][i].toString(), style: TextStyle(fontSize: 36),)),
      color: Colors.teal[100],
    ),);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: cells,
    );
  }
}