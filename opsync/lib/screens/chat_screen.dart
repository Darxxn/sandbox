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
            child: viewModel.messages.isEmpty
                ? _buildIntroMessage()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(viewModel.messages[index]);
                    },
                  ),
          ),
          _buildSuggestionChips(viewModel),
          ChatInputField(viewModel: viewModel), // Reusable Chat Input
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildIntroMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "I'm Q, your AI assistant!\nLet me know how I can help.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
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
        onPressed: () {
          viewModel.sendPredefinedMessage(text); // Use predefined messages
        },
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

  Widget _buildMessageBubble(String message) {
    bool isUser = message.startsWith("You:");
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.replaceFirst("You: ", "").replaceFirst("Q: ", ""),
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      color: Color(0xFF1C202A), // Match navbar background
      padding: const EdgeInsets.only(top: 15.0), // Increase navbar height
      child: BottomNavigationBar(
        currentIndex: 1, // Chat is selected
        backgroundColor: Color(0xFF1C202A), // Dark navbar background
        selectedItemColor: Color(0xFF5FB4FF), // Highlight color when selected
        unselectedItemColor: Colors.white, // Default color for unselected items
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
