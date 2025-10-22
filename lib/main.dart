import 'dart:io';
import 'domain/quiz.dart';
import 'ui/quiz_console.dart';
import 'data/quiz_file_provider.dart';
import 'ui/admin_console.dart';

class InvalidOptionException implements Exception {
  final String? input;
  InvalidOptionException(this.input);

  @override
  String toString() =>
      """Invalid Options ${input!.isEmpty ? "(Empty Input)" : "$input"} is not a valid choice.""";
}

void answerThroughUI() {
  List<Question> questions = [
    Question(
        title: "Capital of France?",
        choices: ["Paris", "London", "Rome"],
        goodChoice: "Paris",
        point: 50),
    Question(
        title: "2 + 2 = ?",
        choices: ["2", "4", "5"],
        goodChoice: "4",
        point: 10),
  ];

  Quiz quiz = Quiz(questions: questions);
  QuizConsole console = QuizConsole(quiz: quiz);

  console.startQuiz();
}

void answerThroughJSON() {
  var repo = QuizRepository('lib/data/quiz.json');
  var quiz = repo.readQuiz();
  var console = QuizConsole(quiz: quiz);
  console.startQuiz();
}

void main() {
  stdout.writeln("""
Please choose your options:
\t1. Quiz Through UI
\t2. Quiz Through JSON
\t3. Are you an Admin?
  """);
  String? opt = stdin.readLineSync();
  try {
    switch (opt) {
      case "1":
        answerThroughUI();
        break;
      case "2":
        answerThroughJSON();
        break;
      case "3":
        // Launch admin console which can list/add/save questions
        var repoQuiz = QuizRepository('lib/data/quiz.json');
        var admin = AdminConsole(quizRepo: repoQuiz);
        admin.start();
      default:
        throw InvalidOptionException(opt);
    }
  } on InvalidOptionException catch (e) {
    print(e);
  } catch (e) {
    throw ("Error: $e");
  }
}
