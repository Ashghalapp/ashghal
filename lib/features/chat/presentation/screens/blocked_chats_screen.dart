import 'package:flutter/material.dart';

class BlockedChatsScreen extends StatelessWidget {
  const BlockedChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blocked Chats")),
      body: Center(
        child: Text("No Blocked Chats"),
      ),
    );
  }
}
