// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'dart:async';
// import 'package:markdown/markdown.dart' as md;

// class AssistantService {
//   static final String apiKey = dotenv.env['OPENAI_API_KEY']!;
//   static final String assistantId = dotenv.env['OPENAI_ASSISTANT_ID']!;
//   static const String apiUrl = "https://api.openai.com/v1/assistants";

//   static Future<String> sendMessage(String message) async {
//     final url = Uri.parse("https://api.openai.com/v1/threads");

//     try {
//       print("🔹 Sending request to create thread...");

//       final threadResponse = await http.post(
//         url,
//         headers: {
//           'Authorization': 'Bearer $apiKey',
//           'Content-Type': 'application/json',
//           'OpenAI-Beta': 'assistants=v2'
//         },
//       );

//       if (threadResponse.statusCode != 200) {
//         return "Error creating thread: ${threadResponse.body}";
//       }

//       final threadId = jsonDecode(threadResponse.body)['id'];
//       print("✅ Thread Created: $threadId");

//       // Step 2: Send user message
//       final messageUrl = Uri.parse("https://api.openai.com/v1/threads/$threadId/messages");
//       await http.post(
//         messageUrl,
//         headers: {
//           'Authorization': 'Bearer $apiKey',
//           'Content-Type': 'application/json',
//           'OpenAI-Beta': 'assistants=v2'
//         },
//         body: jsonEncode({
//           "role": "user",
//           "content": message
//         }),
//       );

//       // Step 3: Run the assistant
//       final runUrl = Uri.parse("https://api.openai.com/v1/threads/$threadId/runs");
//       final runResponse = await http.post(
//         runUrl,
//         headers: {
//           'Authorization': 'Bearer $apiKey',
//           'Content-Type': 'application/json',
//           'OpenAI-Beta': 'assistants=v2'
//         },
//         body: jsonEncode({
//           "assistant_id": assistantId,
//         }),
//       );

//       if (runResponse.statusCode != 200) {
//         return "Error running assistant: ${runResponse.body}";
//       }

//       final runId = jsonDecode(runResponse.body)['id'];
//       print("✅ Run Started: $runId");

//       // Step 4: Poll for response (keep checking every 2 seconds)
//       return await _waitForResponse(threadId);
//     } catch (e) {
//       return "Error: $e";
//     }
//   }

//   static Future<String> _waitForResponse(String threadId) async {
//     final responseUrl = Uri.parse("https://api.openai.com/v1/threads/$threadId/messages");

//     for (int i = 0; i < 10; i++) { // Try for 20 seconds
//       await Future.delayed(Duration(seconds: 2));

//       final response = await http.get(
//         responseUrl,
//         headers: {
//           'Authorization': 'Bearer $apiKey',
//           'Content-Type': 'application/json',
//           'OpenAI-Beta': 'assistants=v2'
//         },
//       );

//       print("🔍 Polling for Response... Attempt ${i + 1}");
//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         final messages = data['data'];

//         // ✅ Collect assistant responses from all message chunks
//         List<String> responseList = [];

//         for (var msg in messages) {
//           if (msg['role'] == 'assistant' && msg['content'] is List) {
//             for (var content in msg['content']) {
//               if (content['type'] == 'text') {
//                 responseList.add(content['text']['value']);
//               }
//             }
//           }
//         }

//         if (responseList.isNotEmpty) {
//           return _convertMarkdown(responseList.join(" ")); // ✅ Process final response
//         }
//       }
//     }

//     return "Error: Assistant did not respond in time.";
//   }

//   // ✅ Converts Markdown to readable plain text
//   static String _convertMarkdown(String markdownText) {
//     return md.markdownToHtml(markdownText)
//         .replaceAll(RegExp(r'<[^>]+>'), '') // ✅ Strip HTML tags
//         .replaceAll("&nbsp;", " ") // ✅ Fix spaces
//         .trim();
//   }
// }

import 'dart:convert';
import 'dart:io';
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

  // static Future<String> _waitForResponse(String threadId) async {
  //   final responseUrl = Uri.parse("https://api.openai.com/v1/threads/$threadId/messages");

  //   for (int i = 0; i < 10; i++) { // Try for 20 seconds
  //     await Future.delayed(Duration(seconds: 2));

  //     final response = await http.get(
  //       responseUrl,
  //       headers: {
  //         'Authorization': 'Bearer $apiKey',
  //         'Content-Type': 'application/json',
  //         'OpenAI-Beta': 'assistants=v2'
  //       },
  //     );

  //     print("🔍 Polling for Response... Attempt ${i + 1}");
  //     final data = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       final messages = data['data'];

  //       // ✅ Store raw JSON response in a file
  //       await _saveRawResponse(jsonEncode(data));

  //       // ✅ Collect assistant responses from all message chunks
  //       List<String> responseList = [];

  //       for (var msg in messages) {
  //         if (msg['role'] == 'assistant' && msg['content'] is List) {
  //           for (var content in msg['content']) {
  //             if (content['type'] == 'text') {
  //               responseList.add(content['text']['value']);
  //             }
  //           }
  //         }
  //       }

  //       if (responseList.isNotEmpty) {
  //         String finalResponse = _convertMarkdown(responseList.join(" "));

  //         // ✅ Save cleaned response in a file
  //         await _saveChatHistory(finalResponse);

  //         return finalResponse; // ✅ Display response in chat
  //       }
  //     }
  //   }

  //   return "Error: Assistant did not respond in time.";
  // }

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

          // ✅ Store raw JSON response in a file
          await _saveRawResponse(jsonEncode(data));

          // ✅ Collect assistant responses from all message chunks
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

            // ✅ Save cleaned response in a file **before returning**
            await _saveChatHistory(finalResponse);
            print("✅ Chat history saved!");

            return finalResponse; // ✅ Display response in chat
          }
        }
      }

      return "Error: Assistant did not respond in time.";
  }


  // ✅ Converts Markdown to readable plain text
  static String _convertMarkdown(String markdownText) {
    return md.markdownToHtml(markdownText)
        .replaceAll(RegExp(r'<[^>]+>'), '') // ✅ Strip HTML tags
        .replaceAll("&nbsp;", " ") // ✅ Fix spaces
        .replaceAll("â€™", "'") // ✅ Fix apostrophes
        .replaceAll("â€œ", '"') // ✅ Fix left double quote
        .replaceAll("â€", '"') // ✅ Fix right double quote
        .replaceAll("â€“", "-") // ✅ Fix en dash
        .replaceAll("â€”", "--") // ✅ Fix em dash
        .replaceAll(RegExp(r'\s{2,}'), ' ') // ✅ Normalize spaces
        .trim();
  }

  // ✅ Saves raw API responses to a file
  static Future<void> _saveRawResponse(String response) async {
    try {

      final file = File('/Users/isaacnash/Desktop/OPSYNC/sandbox/opsync/lib/services/raw_responses.json');

      await file.writeAsString(response, mode: FileMode.write); // ✅ Overwrites file to avoid corruption
      print("📂 Raw response saved to ${file.path}");
    } catch (e) {
      print("❌ Error saving raw response: $e");
    }
  }

  // ✅ Saves cleaned chat messages to a file
  static Future<void> _saveChatHistory(String response) async {
      try {
        final file = File('/Users/isaacnash/Desktop/OPSYNC/sandbox/opsync/lib/services/chat_history.txt');

        await file.writeAsString("$response\n", mode: FileMode.append, encoding: utf8); // ✅ Append instead of overwrite
        print("📂 Chat history updated in ${file.path}");
      } catch (e) {
        print("❌ Error saving chat history: $e");
      }
  }
}
