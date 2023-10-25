import 'package:flutter/material.dart';

class StarredMessagesScreen extends StatelessWidget {
  const StarredMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Starred Messages"),
      ),
      body: Center(
        child: Text("Starred Messages Screen"),
      ),
    );
  }
}
