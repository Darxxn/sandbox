import 'package:flutter/material.dart';
import '../viewmodels/chat_vm.dart';

class ChatInputField extends StatelessWidget {
  final ChatViewModel viewModel;

  ChatInputField({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_circle, size: 28),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: viewModel.messageController,
              decoration: InputDecoration(
                hintText: "Start a conversation...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.mic, size: 28),
            onPressed: () => viewModel.startVoiceInput(),
          ),
        ],
      ),
    );
  }
}
