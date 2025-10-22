import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Question {
  final String id;
  final String title;
  final List<String> choices;
  final String goodChoice;
  final int point;

  Question({
    String? id,
    required this.title,
    required this.choices,
    required this.goodChoice,
    required this.point,
  }) : id = id ?? uuid.v4();
}

class Answer {
  final String id;
  final String questionId;
  final String answerChoice;

  Answer({
    String? id,
    required this.questionId,
    required this.answerChoice,
  }) : id = id ?? uuid.v4();
}

class Quiz {
  final String id;
  List<Question> questions;
  List<Answer> answers = [];

  Quiz({
    String? id,
    required this.questions,
  }) : id = id ?? uuid.v4();

  void addAnswer(Answer answer) {
    answers.add(answer);
  }

  Question? getQuestionById(String id) =>
      questions.firstWhere((q) => q.id == id,
          orElse: () => throw Exception('Question not found'));

  int getScoreInPercentage() {
    int totalScore = 0, max = 0;

    for (var answer in answers) {
      var q = getQuestionById(answer.questionId);
      if (answer.answerChoice == q!.goodChoice) {
        totalScore += q.point;
      }
      max += q.point;
    }
    return ((totalScore / max) * 100).toInt();
  }

  int getScoreInPoint() {
    int totalScore = 0;
    for (var answer in answers) {
      var q = getQuestionById(answer.questionId);
      if (answer.answerChoice == q!.goodChoice) {
        totalScore += q.point;
      }
    }
    return totalScore;
  }
}
