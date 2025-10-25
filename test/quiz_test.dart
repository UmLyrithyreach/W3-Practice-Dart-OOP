import '../lib/domain/quiz.dart';
import '../lib/domain/player.dart';
import 'package:test/test.dart';

main() {
  test('Quiz with 2 questions - Test score calculation', () {
    // Create a quiz with 2 questions as specified in PDF
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
          point: 10)
    ];
    Quiz quiz = Quiz(questions: questions);
    
    // Add correct answers to both questions
    Answer answer1 = Answer(questionId: questions[0].id, answerChoice: "Paris");
    Answer answer2 = Answer(questionId: questions[1].id, answerChoice: "4");
    quiz.addAnswer(answer1);
    quiz.addAnswer(answer2);

    // Test correctness
    expect(questions[0].goodChoice, equals("Paris"));
    expect(questions[1].goodChoice, equals("4"));

    // Test points
    expect(questions[0].point, equals(50));
    expect(questions[1].point, equals(10));

    // Test score calculation - should get 100% (60/60 points)
    expect(quiz.getScoreInPercentage(), equals(100));
    expect(quiz.getScoreInPoint(), equals(60));
  });

  test('Quiz with partial correct answers', () {
    // Create a quiz with 2 questions
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
          point: 10)
    ];
    Quiz quiz = Quiz(questions: questions);
    
    // Add one correct and one incorrect answer
    Answer answer1 = Answer(questionId: questions[0].id, answerChoice: "Paris");
    Answer answer2 = Answer(questionId: questions[1].id, answerChoice: "2");
    quiz.addAnswer(answer1);
    quiz.addAnswer(answer2);

    // Test score calculation - should get 83% (50/60 points)
    expect(quiz.getScoreInPercentage(), equals(83));
    expect(quiz.getScoreInPoint(), equals(50));
  });

  test('Quiz with no correct answers', () {
    // Create a quiz with 2 questions
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
          point: 10)
    ];
    Quiz quiz = Quiz(questions: questions);
    
    // Add incorrect answers
    Answer answer1 = Answer(questionId: questions[0].id, answerChoice: "London");
    Answer answer2 = Answer(questionId: questions[1].id, answerChoice: "2");
    quiz.addAnswer(answer1);
    quiz.addAnswer(answer2);

    // Test score calculation - should get 0% (0/60 points)
    expect(quiz.getScoreInPercentage(), equals(0));
    expect(quiz.getScoreInPoint(), equals(0));
  });

  test('Multiple players test - Add players and check submission scores', () {
    // Create a quiz with 2 questions
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
          point: 10)
    ];
    Quiz quiz = Quiz(questions: questions);
    
    // Create multiple players
    var player1 = Player(name: "Alice");
    var player2 = Player(name: "Bob");
    var player3 = Player(name: "Charlie");
    
    // Player 1 gets all correct (100%)
    quiz.answers.clear();
    Answer answer1_1 = Answer(questionId: questions[0].id, answerChoice: "Paris");
    Answer answer1_2 = Answer(questionId: questions[1].id, answerChoice: "4");
    quiz.addAnswer(answer1_1);
    quiz.addAnswer(answer1_2);
    player1.updateScore(point: quiz.getScoreInPoint(), percentage: quiz.getScoreInPercentage());
    
    // Player 2 gets partial correct (83%)
    quiz.answers.clear();
    Answer answer2_1 = Answer(questionId: questions[0].id, answerChoice: "Paris");
    Answer answer2_2 = Answer(questionId: questions[1].id, answerChoice: "2");
    quiz.addAnswer(answer2_1);
    quiz.addAnswer(answer2_2);
    player2.updateScore(point: quiz.getScoreInPoint(), percentage: quiz.getScoreInPercentage());
    
    // Player 3 gets none correct (0%)
    quiz.answers.clear();
    Answer answer3_1 = Answer(questionId: questions[0].id, answerChoice: "London");
    Answer answer3_2 = Answer(questionId: questions[1].id, answerChoice: "2");
    quiz.addAnswer(answer3_1);
    quiz.addAnswer(answer3_2);
    player3.updateScore(point: quiz.getScoreInPoint(), percentage: quiz.getScoreInPercentage());
    
    // Test player scores
    expect(player1.scoreInPoint, equals(60));
    expect(player1.scoreInPercentage, equals(100));
    
    expect(player2.scoreInPoint, equals(50));
    expect(player2.scoreInPercentage, equals(83));
    
    expect(player3.scoreInPoint, equals(0));
    expect(player3.scoreInPercentage, equals(0));
    
    // Test player names
    expect(player1.name, equals("Alice"));
    expect(player2.name, equals("Bob"));
    expect(player3.name, equals("Charlie"));
  });
}
