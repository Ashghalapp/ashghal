// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class MessageInfoPage extends StatelessWidget {
  MessageAndMultimediaModel message;
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
                child: MessageRowWidget(
                  message: message,
                ),
              ),
            ),
            const SizedBox(height: 20),
            cardWedgit(
              'Received At:',
              message.message.recievedAt != null
                  ? "${message.message.recievedAt!.hour}:${message.message.recievedAt!.minute}:${message.message.recievedAt!.second}"
                  : 'Message has not been received yet',
              Colors.grey,
            ),
            cardWedgit(
              'Read At:',
              message.message.readAt != null
                  ? "${message.message.readAt!.hour}:${message.message.readAt!.minute}:${message.message.readAt!.second}"
                  : 'Message has not been read yet',
              Colors.blue,
            ),
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
