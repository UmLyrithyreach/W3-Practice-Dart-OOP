import 'dart:io';
import '../domain/player.dart';
import '../domain/quiz.dart';

class QuizConsole {
  Quiz quiz;
  Map<String, Player> players = {};

  QuizConsole({required this.quiz});

  void startQuiz() {
    print('--- Welcome to the Quiz ---\n');

    while (true) {
      stdout.write("Your name: ");
      String? nameInput = stdin.readLineSync();
      if (nameInput == null || nameInput.isEmpty) {
        break;
      }

      Player player = players[nameInput] ?? Player(name: nameInput);

      quiz.answers.clear();

      for (var question in quiz.questions) {
        print('Question: ${question.title}       (${question.point} points)');
        print('Choices: ${question.choices}');
        stdout.write('Your answer: ');
        String? userInput = stdin.readLineSync();

        // Check for null input
        if (userInput != null && userInput.isNotEmpty) {
          Answer answer = Answer(question: question, answerChoice: userInput);
          quiz.addAnswer(answer);
        } else {
          print('No answer entered. Skipping question.');
        }

        print('');
      }
      int scoreInPoint = quiz.getScoreInPoint();
      int scoreInPercentage = quiz.getScoreInPercentage();

      player.updateScore(point: scoreInPoint);

      players[nameInput] = player;
      print("""
${player.name}, your score:
- In percentage: $scoreInPercentage %
- In points: $scoreInPoint
""");

      // Show all players' scores
      print('\n--- All Players Scores ---');
      for (var p in players.values) {
        print(p);
      }
      print('');
    }
  }
}
