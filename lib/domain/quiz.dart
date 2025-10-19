class Question {
  final String id;
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int point;

  Question(
      {required this.id,
      required this.title,
      required this.choices,
      required this.goodChoice,
      required this.point});
}

class Answer {
  final String questionID;
  final String answerChoice;

  Answer({required this.questionID, required this.answerChoice});

  bool isGood(List<Question> questions) {
    final question = questions.firstWhere((q) => q.id == questionID);
    return answerChoice == question.goodChoice;
  }
}

class Quiz {
  List<Question> questions;
  List<Answer> answers = [];

  Quiz({required this.questions});

  void addAnswer(Answer asnwer) {
    this.answers.add(asnwer);
  }

  int getScoreInPercentage() {
    int totalScore = 0, max = 0;

    for (Answer answer in answers) {
      final question = questions.firstWhere((q) => q.id == answer.questionID);
      if (answer.isGood(questions)) {
        totalScore += question.point;
      }
      max += question.point;
    }
    if (max == 0) return 0;
    return ((totalScore / max) * 100).toInt();
  }

  int getScoreInPoint() {
    int totalScore = 0;
    for (Answer answer in answers) {
      final question = questions.firstWhere((q) => q.id == answer.questionID);
      if (answer.isGood(questions)) {
        totalScore += question.point;
      }
    }
    return totalScore;
  }
}

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
