import '../lib/domain/quiz.dart';
import 'package:test/test.dart';

main() {
  test('My first test', () {
    // Do something
    List<Question> questions = [
      Question(
          title: "Who is my mother",
          choices: ["Idk", "What?", "What kind of question is that"],
          goodChoice: "Lol",
          point: 20)
    ];
    Quiz quiz = Quiz(questions: questions);
    // Check something
    Answer answer = Answer(question: questions[0], answerChoice: "Lol");
    quiz.addAnswer(answer);

    print("Test Correctness");
    expect(answer.question.goodChoice, equals("Lol"));

    print("Test Point");
    expect(answer.question.point, equals(20));

    print("Test Score percentage");
    expect(quiz.getScoreInPercentage(), equals(100));
  });
}
