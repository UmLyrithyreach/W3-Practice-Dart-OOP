import 'dart:io';
import 'data/quiz_file_provider.dart';
import 'domain/quiz.dart';
import 'ui/quiz_console.dart';

class InputException implements Exception {
  final String? input;
  InputException(this.input);

  @override
  String toString() => """
Error! Invalid input: ${input!.isEmpty ? '(Empty input)' : '"$input"'} is not a valid option.
Please enter 1, 2 or 3.
""";
}

// Option 1: Hardcoded quiz
void quizThroughUI() {
  List<Question> questions = [
    Question(
        id: '1',
        title: "Capital of France?",
        choices: ["Paris", "London", "Rome"],
        goodChoice: "Paris",
        point: 50),
    Question(
        id: '2',
        title: "2 + 2 = ?",
        choices: ["2", "4", "5"],
        goodChoice: "4",
        point: 10),
  ];

  Quiz quiz = Quiz(questions: questions);
  QuizConsole console = QuizConsole(quiz: quiz);
  console.startQuiz();
}

// Option 2: Load quiz from JSON
void quizThroughJSON() {
  final repo = QuizRepository("lib/data/quiz.json");
  final quiz = repo.readQuiz();

  QuizConsole console = QuizConsole(quiz: quiz);
  console.startQuiz();
}

// Option 3: Admin creates a new quiz and saves it
void adminPanel() {
  final repo = QuizRepository("lib/data/quiz.json");

  stdout.writeln("How many questions do you want to add?");
  int count = int.parse(stdin.readLineSync()!);

  List<Question> questions = [];

  for (int i = 0; i < count; i++) {
    stdout.writeln("Enter ID for question ${i + 1}:");
    String id = stdin.readLineSync()!;

    stdout.writeln("Enter title for question ${i + 1}:");
    String title = stdin.readLineSync()!;

    stdout.writeln("Enter choices separated by commas:");
    List<String> choices =
        stdin.readLineSync()!.split(",").map((c) => c.trim()).toList();

    stdout.writeln("Enter the correct choice:");
    String goodChoice = stdin.readLineSync()!;

    stdout.writeln("Enter points for this question:");
    int point = int.parse(stdin.readLineSync()!);

    questions.add(Question(
      id: id,
      title: title,
      choices: choices,
      goodChoice: goodChoice,
      point: point,
    ));
  }

  Quiz quiz = Quiz(questions: questions);
  repo.addQuiz(quiz);
  stdout.writeln("Quiz added successfully!");
}

// Main menu
void main() {
  print("""
Choose your options:
\t1. Quiz Through UI
\t2. Quiz Through JSON
\t3. Are you an admin?
""");

  String? choice = stdin.readLineSync();
  try {
    switch (choice) {
      case "1":
        quizThroughUI();
        break;
      case "2":
        quizThroughJSON();
        break;
      case "3":
        stdout.writeln("Enter your password:");
        String? password = stdin.readLineSync();
        if (password == "yes") {
          adminPanel();
        }
        break;
      default:
        throw InputException(choice);
    }
  } on InputException catch (e) {
    print(e);
  } catch (e) {
    print("Error: $e");
  }
}
