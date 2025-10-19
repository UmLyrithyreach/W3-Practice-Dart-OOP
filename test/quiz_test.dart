import 'package:my_first_project/domain/quiz.dart';
import 'package:test/test.dart';

main() {
  test('My first test', () {
    // Do something
    Question question = Question(
        title: "Who is my mother",
        choices: ["Idk", "What?", "What kind of question is that"],
        goodChoice: "Lol", point: 20);

    // Check something
    expect(question.goodChoice, equals("Lol"));
    expect(1+1, equals(2));
  });
}
