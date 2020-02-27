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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: GameBoard(title: 'Flutter Demo Home Page'),
    );
  }
}

class GameBoard extends StatefulWidget {
  GameBoard({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
        IconButton(icon: Icon(Icons.arrow_drop_up), onPressed:(){
          gameLogic.upSwipe();
          gameLogic.randomZeroPosition();
          setState(() {});},),
        IconButton(icon: Icon(Icons.arrow_drop_down), onPressed:(){
          gameLogic.downSwipe();
          gameLogic.randomZeroPosition();
          setState(() {});},),
        IconButton(icon: Icon(Icons.arrow_right), onPressed:(){
          gameLogic.rightSwipe();
          gameLogic.randomZeroPosition();
          setState(() {});},),
        IconButton(icon: Icon(Icons.access_alarm), onPressed:(){
          gameLogic.leftSwipe();
          gameLogic.randomZeroPosition();
          setState(() {});},),
      ],
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: listOfWidgets,
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