class Player {
  final String name;
  int scoreInPoint;
  int scoreInPercentage;

  Player(
      {required this.name, this.scoreInPoint = 0, this.scoreInPercentage = 0});

  void updateScore({required int point}) {
    scoreInPoint = point;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Player Name: ${name} \t Score: ${scoreInPoint}pts";
  }
}
