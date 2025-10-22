import 'dart:convert';
import 'dart:io';

import '../domain/quiz.dart';

class QuizRepository {
  final String filePath;
  QuizRepository(this.filePath);

  Quiz readQuiz() {
    final file = File(filePath);
    if (!file.existsSync()) {
      // Return empty quiz if file not exists
      return Quiz(questions: []);
    }
    final content = file.readAsStringSync();
    final data = jsonDecode(content);

    // Map JSON to domain objects
    var questionsJson = data['questions'] as List<dynamic>;
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
  }

  void saveQuiz(Quiz quiz) {
    final file = File(filePath);
    final data = {
      'questions': quiz.questions.map((q) {
        return {
          'id': q.id,
          'title': q.title,
          'choices': q.choices,
          'goodChoice': q.goodChoice,
          'point': q.point,
        };
      }).toList()
    };
    file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(data));
  }

  List<dynamic> readPlayerSubmissions(String submissionsFilePath) {
    final file = File(submissionsFilePath);
    if (!file.existsSync()) return [];
    final content = file.readAsStringSync();
    if (content.trim().isEmpty) return [];
    try {
      return jsonDecode(content) as List<dynamic>;
    } catch (_) {
      return [];
    }
  }

  void savePlayerSubmission(
      String submissionsFilePath, Map<String, dynamic> submission) {
    final file = File(submissionsFilePath);
    List<dynamic> submissions = [];
    if (file.existsSync()) {
      final content = file.readAsStringSync();
      if (content.trim().isNotEmpty) {
        try {
          submissions = jsonDecode(content) as List<dynamic>;
        } catch (_) {
          submissions = [];
        }
      }
    }
    submissions.add(submission);
    file.writeAsStringSync(JsonEncoder.withIndent('  ').convert(submissions));
  }
}
