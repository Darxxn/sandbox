import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'package:markdown/markdown.dart' as md;

class AssistantService {
  static final String apiKey = dotenv.env['OPENAI_API_KEY']!;
  static final String assistantId = dotenv.env['OPENAI_ASSISTANT_ID']!;
  static const String apiUrl = "https://api.openai.com/v1/assistants";

  static Future<String> sendMessage(String message) async {
    final url = Uri.parse("https://api.openai.com/v1/threads");

    try {
      print("🔹 Sending request to create thread...");

      final threadResponse = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'OpenAI-Beta': 'assistants=v2'
        },
      );

      if (threadResponse.statusCode != 200) {
        return "Error creating thread: ${threadResponse.body}";
      }

      final threadId = jsonDecode(threadResponse.body)['id'];
      print("✅ Thread Created: $threadId");

      // Step 2: Send user message
      final messageUrl = Uri.parse("https://api.openai.com/v1/threads/$threadId/messages");
      await http.post(
        messageUrl,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'OpenAI-Beta': 'assistants=v2'
        },
        body: jsonEncode({
          "role": "user",
          "content": message
        }),
      );

      // Step 3: Run the assistant
      final runUrl = Uri.parse("https://api.openai.com/v1/threads/$threadId/runs");
      final runResponse = await http.post(
        runUrl,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'OpenAI-Beta': 'assistants=v2'
        },
        body: jsonEncode({
          "assistant_id": assistantId,
        }),
      );

      if (runResponse.statusCode != 200) {
        return "Error running assistant: ${runResponse.body}";
      }

      final runId = jsonDecode(runResponse.body)['id'];
      print("✅ Run Started: $runId");

      // Step 4: Poll for response (keep checking every 2 seconds)
      return await _waitForResponse(threadId);
    } catch (e) {
      return "Error: $e";
    }
  }

  static Future<String> _waitForResponse(String threadId) async {
      final responseUrl = Uri.parse("https://api.openai.com/v1/threads/$threadId/messages");

      for (int i = 0; i < 15; i++) { // Try for 30 seconds
        await Future.delayed(Duration(seconds: 2));

        final response = await http.get(
          responseUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
            'OpenAI-Beta': 'assistants=v2'
          },
        );

        print("🔍 Polling for Response... Attempt ${i + 1}");
        final data = jsonDecode(response.body);
        print("Data: $data");

        if (response.statusCode == 200) {
          final messages = data['data'];
          await _saveRawResponse(jsonEncode(data));
          List<String> responseList = [];

          for (var msg in messages) {
            if (msg['role'] == 'assistant' && msg['content'] is List) {
              for (var content in msg['content']) {
                if (content['type'] == 'text') {
                  responseList.add(content['text']['value']);
                }
              }
            }
          }

          if (responseList.isNotEmpty) {
            String finalResponse = _convertMarkdown(responseList.join(" "));
            await _saveChatHistory(finalResponse);
            print("✅ Chat history saved!");

            return finalResponse;
          }
        }
      }
      return "Error: Assistant did not respond in time.";
  }


  // ✅ Converts Markdown to readable plain text
  static String _convertMarkdown(String markdownText) {
    String html = md.markdownToHtml(markdownText);
    html = html
        .replaceAll(RegExp(r'</p>'), '\n')
        .replaceAll(RegExp(r'<br\s*/?>'), '\n');

    String plainText = html.replaceAll(RegExp(r'<[^>]+>'), '');
    plainText = plainText.replaceAll(RegExp(r'ã.*?ã'), '');
    plainText = plainText
        .replaceAll("&nbsp;", " ")
        .replaceAll("â€™", "'")
        .replaceAll("â€œ", '"')
        .replaceAll("â€", '"')
        .replaceAll("â€“", "-")
        .replaceAll("â€”", "--")
        // Replace multiple spaces or tabs with a single space (leaving newlines intact).
        .replaceAll(RegExp(r'[ \t]{2,}'), ' ')
        .trim();

    return plainText;
  }


  // ✅ Saves raw API responses to a file
  static Future<void> _saveRawResponse(String response) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, "raw_responses.json");
      final file = File(filePath);

      await file.writeAsString(response, mode: FileMode.write);
      print("📂 Raw response saved to ${file.path}");
    } catch (e) {
      print("❌ Error saving raw response: $e");
    }
  }


  // ✅ Saves cleaned chat messages to a file
  static Future<void> _saveChatHistory(String response) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, "chat_history.txt");
      final file = File(filePath);

      await file.writeAsString(response, mode: FileMode.write);
      print("📂 Chat history updated in ${file.path}");
    } catch (e) {
      print("❌ Error saving chat history: $e");
    }
  }
}
