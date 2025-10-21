 
import 'domain/quiz.dart';
import 'ui/quiz_console.dart';

void main() {

  List<Question> questions = [
    Question(
        title: "Capital of France?",
        choices: ["Paris", "London", "Rome"],
        goodChoice: "Paris", point: 50),
    Question(
        title: "2 + 2 = ?", 
        choices: ["2", "4", "5"], 
        goodChoice: "4", point: 10),
  ];

  Quiz quiz = Quiz(questions: questions);
  QuizConsole console = QuizConsole(quiz: quiz);

  console.startQuiz();
}
