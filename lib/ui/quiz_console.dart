import 'dart:io';
import '../domain/quiz.dart';
import '../data/quiz_file_provider.dart';

class QuizConsole {
  Quiz quiz;
  Map<String, Player> players = {};
  late SubmissionRepository submissionRepo;

  QuizConsole({required this.quiz}) {
    submissionRepo = SubmissionRepository("lib/data/userData.json");
  }

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
        if (userInput == null || userInput.isEmpty) {
          print('No answer entered. Skipping question.');
        } else {
          Answer answer =
              Answer(questionID: question.id, answerChoice: userInput);
          quiz.addAnswer(answer);
        }

        print('');
      }
      int scoreInPoint = quiz.getScoreInPoint();
      int scoreInPercentage = quiz.getScoreInPercentage();

      player.updateScore(point: scoreInPoint);
      player.scoreInPercentage = scoreInPercentage;

      players[nameInput] = player;

      // Save the submission to userData.json
      submissionRepo.saveSubmission(quiz, player);

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
