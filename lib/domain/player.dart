import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Player {
  final String name;
  String id = uuid.v4();
  int scoreInPoint;
  int scoreInPercentage;

  Player(
      {required this.name, this.scoreInPoint = 0, this.scoreInPercentage = 0});

  String get userId => id;

  void updateScore({required int point}) {
    scoreInPoint = point;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Player Name: ${name} \t Score: ${scoreInPoint}pts";
  }
}
