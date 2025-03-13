import 'dart:convert';
import 'package:http/http.dart' as http;

class GPTService {
  static const String apiUrl = "https://api.openai.com/v1/chat/completions";
  static const String apiKey = "YOUR_OPENAI_API_KEY"; // Replace with your actual API key

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4-turbo',
          'messages': [
            {"role": "system", "content": "You are a pest control assistant."},
            {"role": "user", "content": message},
          ]
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['choices'][0]['message']['content'];
      } else {
        return "Error: Unable to connect to AI.";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
