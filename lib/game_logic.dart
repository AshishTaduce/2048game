import 'dart:math';

void main(){
  List<List<int>> board = [
    [0,0,0,0],
    [0,0,2,0],
    [0,0,0,0],
    [0,0,0,0],
  ];
  Start2048 game = Start2048(board);
  game.printBoard();
  game.upSwipe();
  game.randomZeroPosition();
  game.printBoard();
  game.upSwipe();
  game.randomZeroPosition();
  game.printBoard();game.upSwipe();
  game.randomZeroPosition();
  game.printBoard();
}

class Start2048{
  List<List<int>> board;
  Start2048(this.board);

  void randomZeroPosition(){
    final _random = new Random();
    List<List<int>> possiblePositions = [];
    for(int i = 0; i < board.length; i++){
      for(int j = 0; j < board.length; j++){
        if (board[i][j] == 0) possiblePositions.insert(0, [i,j],);
      }
    }
    int randomPosition = _random.nextInt(possiblePositions.length);
    print(possiblePositions[randomPosition]);
    board[possiblePositions[randomPosition][0]][possiblePositions[randomPosition][1]] = 2;
  }

  void rightSwipe(){
    for(int i = 0; i < board.length; i++){
      rightSlide(board[i]);
    }
  }

  void  leftSwipe(){
    for(int i = 0; i < board.length; i++){
      leftSlide(board[i]);
    }
  }

  List<List<int>>  transposeArray(array, arrayLength){
    List<List<int>> newArray = [];
    for(var i = 0; i < array.length; i++){
      newArray.add([]);
    }
    for(var i = 0; i < array.length; i++){
      for(var j = 0; j < arrayLength; j++){
        newArray[j].add(array[i][j]);
      }
    }
    return newArray;
  }

  void  upSwipe(){
    board = transposeArray(board,board.length);
    leftSwipe();
    board = transposeArray(board,board.length);
  }

  void  downSwipe(){
    board = transposeArray(board,board.length);
    rightSwipe();
    board = transposeArray(board,board.length);
  }

  List<int>  leftSlide(List<int>  row){
    int listLength = row.length;
    while(row.contains(0)){
      for(int j = 0; j < row.length; j++){
        if(row[j] == 0) row.removeAt(j);
      }}
    for(int i = 0; i < row.length - 1; i++){
      if(row[i] == row[i+1]){
        row[i] = row[i] + row[i];
        row.removeAt(i+1);
        row.add(0);
      }
    }
    while(row.length != listLength){
      row.insert(row.length, 0);
    }
    return row.toList();
  }

  List<int> rightSlide(List<int>row){
    int listLength = row.length;
    while(row.contains(0)){
      for(int j = 0; j < row.length; j++){
        if(row[j] == 0) row.removeAt(j);
      }}
    for(int i = 0; i < row.length - 1; i++){
      if(row[i] == row[i+1]){
        row[i+1] = row[i+1] *2;
        row.removeAt(i);
        row.insert(0, 0);
      }
    }
    while(row.length != listLength){
      row.insert(0, 0);
    }
    return row.toList();
  }

  bool checkItGameEnded(){
    return (board.contains(2048) || !board.contains(0));
  }

  bool checkIfValidMovesLeft(List<List<int>> board, List<int> cellPosition){

  }

  void printBoard(){
    print(board);
  }

}

