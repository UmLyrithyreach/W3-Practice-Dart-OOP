import 'dart:convert';
import 'dart:io';
import '../domain/quiz.dart';

class QuizRepository {
  final String filePath;
  QuizRepository(this.filePath);

  // Read a single quiz (first one from the list)
  Quiz readQuiz() {
    final quizzes = readAllQuizzes();
    if (quizzes.isEmpty) {
      throw Exception("No quizzes found in file");
    }
    return quizzes.first;
  }

  // Read all quizzes
  List<Quiz> readAllQuizzes() {
    final file = File(filePath);
    if (!file.existsSync()) return [];

    final content = file.readAsStringSync();
    if (content.isEmpty) return [];

    final data = jsonDecode(content);
    var quizzesJson = data['quizzes'] as List;

    return quizzesJson.map((quizJson) {
      var questionsJson = quizJson['questions'] as List;
      var questions = questionsJson.map((q) {
        return Question(
          id: q['id'],
          title: q['title'],
          choices: List<String>.from(q['choices']),
          goodChoice: q['goodChoice'],
          point: q['point'],
        );
      }).toList();
      return Quiz(questions: questions);
    }).toList();
  }

  // Add a new quiz definition
  void addQuiz(Quiz quiz) {
    final file = File(filePath);

    Map<String, dynamic> data = {"quizzes": []};
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      if (content.isNotEmpty) {
        data = jsonDecode(content);
      }
    }

    if (data["quizzes"] == null || data["quizzes"] is! List) {
      data["quizzes"] = [];
    }

    (data["quizzes"] as List).add({
      "questions": quiz.questions
          .map((q) => {
                "id": q.id,
                "title": q.title,
                "choices": q.choices,
                "goodChoice": q.goodChoice,
                "point": q.point,
              })
          .toList()
    });

    file.writeAsStringSync(jsonEncode(data), flush: true);
  }
}

class SubmissionRepository {
  final String filePath;
  SubmissionRepository(this.filePath);

  void saveSubmission(Quiz quiz, Player player) {
    final file = File(filePath);

    Map<String, dynamic> data = {"submissions": []};
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      if (content.isNotEmpty) {
        data = jsonDecode(content);
      }
    }

    if (data["submissions"] == null || data["submissions"] is! List) {
      data["submissions"] = [];
    }

    (data["submissions"] as List).add({
      "player": {
        "name": player.name,
        "scoreInPoint": player.scoreInPoint,
        "scoreInPercentage": player.scoreInPercentage,
      },
      "answers": quiz.answers
          .map((a) => {
                "questionId": a.questionID,
                "answerChoice": a.answerChoice,
                "isGood": a.isGood(quiz.questions),
              })
          .toList(),
      "timestamp": DateTime.now().toIso8601String(),
    });

    file.writeAsStringSync(jsonEncode(data), flush: true);
    print("Submission saved successfully!");
  }

  // Method to read all submissions
  List<Map<String, dynamic>> readAllSubmissions() {
    final file = File(filePath);
    if (!file.existsSync()) return [];

    final content = file.readAsStringSync();
    if (content.isEmpty) return [];

    final data = jsonDecode(content);
    return List<Map<String, dynamic>>.from(data['submissions'] ?? []);
  }
}
