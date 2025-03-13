import 'package:flutter/material.dart';
import '../services/gpt_services.dart';

class ChatViewModel extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final List<String> messages = [];

  void sendMessage(String message) async {
    if (message.isEmpty) return;

    messages.add("You: $message");
    notifyListeners();

    // Send message to GPT API
    String response = await GPTService.sendMessage(message);
    messages.add("Q: $response");
    notifyListeners();
  }

  void startVoiceInput() {
    // TODO: Implement voice-to-text functionality
  }
}
