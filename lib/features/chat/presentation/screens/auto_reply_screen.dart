import 'package:flutter/material.dart';

class AutoReplyScreen extends StatelessWidget {
  const AutoReplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auto Replies"),
      ),
      body: Center(
        child: Text("Auto Reply Screen"),
      ),
    );
  }
}
