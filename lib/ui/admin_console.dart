import 'dart:io';
import 'dart:convert';

import '../domain/quiz.dart';
import '../data/quiz_file_provider.dart';

class AdminConsole {
  final QuizRepository quizRepo;
  late Quiz quiz;

  AdminConsole({required this.quizRepo}) {
    quiz = quizRepo.readQuiz();
  }

  void start() {
    stdout.writeln('--- Admin Console ---');
    while (true) {
      stdout.writeln('''
Choose an option:
1. List questions
2. List player submissions
3. Add question
4. Save and exit
''');
      stdout.write('> ');
      var input = stdin.readLineSync();
      switch (input) {
        case '1':
          _listQuestions();
          break;
        case '2':
          _listPlayerSubmissions();
          break;
        case '3':
          _addQuestion();
          break;
        case '4':
          quizRepo.saveQuiz(quiz);
          stdout.writeln('Saved. Exiting admin console.');
          return;
        default:
          stdout.writeln('Invalid option.');
      }
    }
  }

  void _listQuestions() {
    if (quiz.questions.isEmpty) {
      stdout.writeln('No questions available.');
      return;
    }
    for (var i = 0; i < quiz.questions.length; i++) {
      var q = quiz.questions[i];
      stdout.writeln('---- Question ${i + 1} ----');
      stdout.writeln('ID: ${q.id}');
      stdout.writeln('Title: ${q.title}');
      stdout.writeln('Choices: ${q.choices}');
      stdout.writeln('Good choice: ${q.goodChoice}');
      stdout.writeln('Points: ${q.point}');
      stdout.writeln('');
    }
  }

  void _addQuestion() {
    stdout.write('Enter question title: ');
    var title = stdin.readLineSync();
    if (title == null || title.trim().isEmpty) {
      stdout.writeln('Title cannot be empty.');
      return;
    }

    List<String> choices = [];
    for (var i = 0; i < 3; i++) {
      stdout.write('Enter choice ${i + 1}: ');
      var c = stdin.readLineSync();
      if (c == null || c.trim().isEmpty) {
        stdout.writeln('Choice cannot be empty. Try again.');
        i--;
        continue;
      }
      choices.add(c);
    }

    stdout.write('Enter index (1-3) of correct choice: ');
    var idxStr = stdin.readLineSync();
    var idx = int.tryParse(idxStr ?? '');
    if (idx == null || idx < 1 || idx > choices.length) {
      stdout.writeln('Invalid index. Aborting add.');
      return;
    }

    stdout.write('Enter point value for this question (integer): ');
    var pointStr = stdin.readLineSync();
    var point = int.tryParse(pointStr ?? '');
    if (point == null) {
      stdout.writeln('Invalid point value. Aborting add.');
      return;
    }

    var q = Question(
        title: title,
        choices: choices,
        goodChoice: choices[idx - 1],
        point: point);
    quiz.questions.add(q);
    stdout.writeln('Question added with id: ${q.id}');
  }

  void _listPlayerSubmissions() {
    final submissions =
        quizRepo.readPlayerSubmissions('lib/data/player_submission.json');
    if (submissions.isEmpty) {
      stdout.writeln('No player submissions found.');
      return;
    }

    for (var i = 0; i < submissions.length; i++) {
      final s = submissions[i] as Map<String, dynamic>;
      stdout.writeln('---- Submission ${i + 1} ----');
      stdout.writeln('ID: ${s['id'] ?? ''}');
      stdout.writeln('Name: ${s['name'] ?? ''}');
      stdout.writeln('Timestamp: ${s['timestamp'] ?? ''}');
      stdout.writeln('Score (points): ${s['scoreInPoint'] ?? ''}');
      stdout.writeln('Score (%): ${s['scoreInPercentage'] ?? ''}');
      stdout.writeln('Answers:');
      final answers = s['answers'] as List<dynamic>? ?? [];
      for (var a in answers) {
        final am = a as Map<String, dynamic>;
        stdout.writeln(' - questionId: ${am['questionId']}  answer: ${am['answerChoice']}');
      }
      stdout.writeln('');
    }
  }
}
