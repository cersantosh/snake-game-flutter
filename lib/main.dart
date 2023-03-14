// main concepts
// defining container
// changing color of snake and food

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int max_score = 0;
  int score = 0;
  // to show food position
  var food = 390;
  var colors = [Colors.green.shade200, Colors.red, Colors.blue];
  // initial snake position
  var snake = [250, 251, 252, 253];
  var is_button_pressed = false;
  // initial direction of snake when game starts
  Direction d = Direction.right;
  int speed = 250;
  bool is_game_over = false;
  late Timer id;

  start_game() {
// use timer.periodic which will stop only when it is cancelled
    id = Timer.periodic(Duration(milliseconds: speed), (timer) {
      move_snake();
      game_over();
    });
  }

  count_score() {
    score++;
  }

// checking duplicate
// when game is over there is duplicate number
  game_over() {
    var new_snake = [];
    new_snake.addAll(snake);
    new_snake.remove(new_snake.last);
    if (new_snake.contains(snake.last)) {
      is_game_over = true;
      // stopping the timer
      id.cancel();
    }
  }

  eat_food() {
    if (snake.last == food) {
      speed = speed - 1;
      count_score();
      if (max_score < score) {
        max_score = score;
      }
      snake.insert(0, snake.first - 1);
      food = Random().nextInt(620);
      // when generating random number food number must not be same as snake position
      while (snake.contains(food)) {
        food = Random().nextInt(620);
      }
    }
  }

  move_snake() {
    eat_food();
    if (d == Direction.right) {
      // when we reach at last repeating from beginning
      if ((snake.last + 1) % 20 == 0) {
        snake.add((snake.last + 1) - 20);
        snake.remove(snake.first);
      } else {
        snake.add(snake.last + 1);
        snake.remove(snake.first);
      }
    }
    if (d == Direction.left) {
      if ((snake.last) % 20 == 0) {
        snake.add(snake.last + 19);
        snake.remove(snake.first);
      } else {
        snake.add(snake.last - 1);
        snake.remove(snake.first);
      }
    }

    if (d == Direction.up) {
      if (snake.last < 20) {
        snake.add(snake.last - 20 + 620);
        snake.remove(snake.first);
      } else {
        snake.add(snake.last - 20);
        snake.remove(snake.first);
      }
    }
    if (d == Direction.down) {
      if (snake.last >= 619) {
        snake.add(snake.last + 20 - 620);
        snake.remove(snake.first);
      } else {
        snake.add(snake.last + 20);
        snake.remove(snake.first);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Snake Game Flutter"),
          centerTitle: true,
        ),
        body: GestureDetector(
          // activate we drag vertically
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 0) {
              // when snake is in up direction we can't move snake in down direction
              if (d != Direction.up) {
                d = Direction.down;
                setState(() {});
              }
            } else {
              if (d != Direction.down) {
                d = Direction.up;
                setState(() {});
              }
            }
          },
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 0) {
              if (d != Direction.left) {
                d = Direction.right;
                setState(() {});
              }
            } else {
              if (d != Direction.right) {
                d = Direction.left;
                setState(() {});
              }
            }
          },
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Score : $score",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Higest Score : $max_score",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              // PlayGround(),
              // play ground
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 15, left: 10, right: 10),
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 620,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 20,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5),
                      itemBuilder: (context, index) {
                        return Container(
                            color: (snake.contains(index)
                                ? colors[1]
                                : (index == food)
                                    ? colors[2]
                                    : colors[0]));
                      }),
                ),
              ),

              // play ground ends
              (!is_button_pressed)
                  ? ElevatedButton(
                      onPressed: () {
                        start_game();
                        is_button_pressed = true;
                      },
                      child: Text(
                        "Start",
                        style: TextStyle(fontSize: 20),
                      ))
                  : Text(""),
              (is_game_over)
                  ? ElevatedButton(
                      onPressed: () {
                        score = 0;
                        food = 390;
                        snake = [250, 251, 252, 253];
                        is_button_pressed = false;
                        d = Direction.right;
                        speed = 300;
                        is_game_over = false;
                        setState(() {});
                      },
                      child: Text("Play Again", style: TextStyle(fontSize: 20)))
                  : Text("")
            ],
          ),
        ));
  }
}

enum Direction { left, right, up, down }

// class PlayGround extends StatefulWidget {
//   @override
//   State<PlayGround> createState() => _PlayGroundState();
// }

// class _PlayGroundState extends State<PlayGround> {
//       var food = 390;
//     var colors = [Colors.grey, Colors.red, Colors.blue];
//     var snake = [350, 351, 352, 353];

//     move_snake(direction) {
//       switch (direction) {
//         case "right":
//           snake.remove(snake.first);
//           snake.add(snake.last + 1);
//           break;
//         case "left":
//           snake.remove(snake.first);
//           snake.insert(0, snake.first - 1);
//           break;

//         case "up":
//           snake.remove(snake.first);
//           snake.add(snake.last - 20);

//           break;
//         case "down":
//           snake.remove(snake.first);
//           snake.add(snake.last + 20);
//           break;
//       }
//     }
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding:
//             const EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
//         child: GridView.builder(
//             itemCount: 620,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 20, crossAxisSpacing: 5, mainAxisSpacing: 5),
//             itemBuilder: (context, index) {
//               return Container(
//                   color: (snake.contains(index)
//                       ? colors[1]
//                       : (index == food)
//                           ? colors[2]
//                           : colors[0]));
//             }),
//       ),
//     );
//   }
// }
