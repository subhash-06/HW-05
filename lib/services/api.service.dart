import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String _baseUrl = 'https://opentdb.com/api.php';

  /// Fetches quiz questions from OpenTDB API
  static Future<List<dynamic>> fetchQuestions({
    required int amount,
    required String category,
    required String difficulty,
    required String type,
  }) async {
    final Uri url = Uri.parse(
      '$_baseUrl?amount=$amount&category=$category&difficulty=$difficulty&type=$type',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['response_code'] == 0) {
          return data['results'];
        } else {
          throw Exception('No questions found. Please try different parameters.');
        }
      } else {
        throw Exception('Failed to load questions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
}
