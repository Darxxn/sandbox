import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/chat_vm.dart';
import '../widgets/chat_input_field.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "I'm Q, your AI helper!\nLet me know how I can help.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          _buildSuggestionChips(viewModel),
          ChatInputField(viewModel: viewModel), // Reusable Chat Input
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChips(ChatViewModel viewModel) {
    List<String> suggestions = [
      "Ask me how to treat a specific bug.",
      "Need help talking to customers? Let's Practice!",
      "I can identify bugs - Upload an image!"
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: suggestions.map((text) => _buildChip(viewModel, text)).toList(),
        ),
      ),
    );
  }

  Widget _buildChip(ChatViewModel viewModel, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () => viewModel.sendMessage(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade300,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 1, // Chat is selected
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
