import 'dart:collection';
import 'dart:io';
import 'dart:math';

enum Move { rock, paper, scissors }

void main() {
  final rng = Random();
  // to get the input from the console
  while (true) {
    stdout.write("Rck paper scissr (r/p/s)");
    // to get the input from the console
    // stdout.write("Rck paper scissr (r/p/s)");
    final input = stdin.readLineSync();
    if (input == 'r' || input == "s" || input == "p") {
      // print('Selected: $input');
      var playerMove;
      if (input == 'r') {
        playerMove = Move.rock;
      } else if (input == 's') {
        playerMove = Move.scissors;
      } else if (input == 'p') {
        playerMove = Move.paper;
      }
      final random = rng.nextInt(3);
      final aiMove = Move.values[random];
      print("You Played : $playerMove");
      print("AI Played : $aiMove");
      if (playerMove == aiMove) {
        print("It's a draw");
      } else if (playerMove == Move.rock && aiMove == Move.scissors ||
          playerMove == Move.paper && aiMove == Move.rock ||
          playerMove == Move.scissors && aiMove == Move.paper) {
        print("You Win");
      } else {
        print("You lose");
      }
      // print('Selected :$input');
    } else if (input == 'q') {
      break;
    } else {
      print("Invalid input");
    }
  }
}
