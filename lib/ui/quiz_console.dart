import 'dart:io';
import 'dart:convert';
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
          Answer answer =
              Answer(answerChoice: userInput, questionId: question.id);
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
      // Save submission to file
      _saveSubmission(
        player: player,
        scoreInPoint: scoreInPoint,
        scoreInPercentage: scoreInPercentage,
        answers: quiz.answers,
      );
    }
  }

  void _saveSubmission({
    required Player player,
    required int scoreInPoint,
    required int scoreInPercentage,
    required List<Answer> answers,
  }) {
    final filePath = 'lib/data/player_submission.json';
    final file = File(filePath);

    List<dynamic> submissions = [];
    if (file.existsSync()) {
      try {
        final content = file.readAsStringSync();
        if (content.trim().isNotEmpty) {
          submissions = jsonDecode(content) as List<dynamic>;
        }
      } catch (e) {
        // ignore and start fresh
        submissions = [];
      }
    }

    final submission = {
      'id': player.userId,
      'name': player.name,
      'timestamp': DateTime.now().toIso8601String(),
      'scoreInPoint': scoreInPoint,
      'scoreInPercentage': scoreInPercentage,
      'answers': answers
          .map((a) =>
              {'questionId': a.questionId, 'answerChoice': a.answerChoice})
          .toList(),
    };

    submissions.add(submission);
    file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(submissions));
  }
}
