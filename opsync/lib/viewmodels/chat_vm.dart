import 'package:flutter/material.dart';
import '../services/assistant_service.dart';

class ChatViewModel extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final List<String> messages = []; // Stores chat messages

  void sendMessage() async {
    String message = messageController.text.trim();
    if (message.isEmpty) return;

    _addUserMessage(message);

    messageController.clear(); // Clear input field

    // Get GPT response from AssistantService
    String response = await AssistantService.sendMessage(message);

    _addBotMessage(response);
  }

  void sendPredefinedMessage(String message) {
    _addUserMessage(message);
    sendMessage();
  }

  void _addUserMessage(String message) {
    messages.add("You: $message");
    notifyListeners();
  }

  void _addBotMessage(String message) {
    messages.add("Q: $message");
    notifyListeners();
  }
}
