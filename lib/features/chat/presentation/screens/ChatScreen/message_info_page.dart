// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class MessageInfoPage extends StatelessWidget {
  LocalMessage message;
  MessageInfoPage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Message Body:'),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5), // Replace with your desired color
              ),
              child: SizedBox(
                width: 700,
                child: MessageWidget(
                  message: message,
                ),
              ),
            ),
            const SizedBox(height: 20),
            cardWedgit(
              'Read At:',
              message.readAt != null
                  ? message.readAt.toString()
                  : 'Message has not been read yet',
              Colors.blue,
            ),
            cardWedgit(
              'Received At:',
              message.recievedAt != null
                  ? message.recievedAt.toString()
                  : 'Message has not been received yet',
              Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Card cardWedgit(String title, String subtitle, Color? color) {
    return Card(
        child: ListTile(
      title: Text(
        "$title  ",
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),

        // textAlign: TextAlign.center,
      ),
      subtitle: Text(
        "$subtitle  ",
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Container(
        child: color != null
            ? Icon(
                FontAwesomeIcons.checkDouble,
                color: color,
                size: 15,
              )
            : Text(""),
      ),
    ));
  }
}
