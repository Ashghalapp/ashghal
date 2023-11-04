// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/date_time_formatter.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MessageInfoPage extends StatelessWidget {
  bool get isMine => message.message.senderId == SharedPref.currentUserId;
  MessageAndMultimediaModel message;
  MessageInfoPage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Get.isPlatformDarkMode ? ChatTheme.dark : ChatTheme.light,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalization.messageInfo.tr),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Opacity(
                opacity: 1,
                child: MessageRowWidget(
                  message: message,
                ),
              ),
              const SizedBox(height: 25),
              if (isMine)
                cardWedgit(
                  AppLocalization.chatSent.tr,
                  message.message.sentAt != null
                      ? DateTimeFormatter.formatDateTimeyMMMdHHSS(
                          message.message.sentAt!,
                        )
                      : AppLocalization.notSentYet.tr,
                  FontAwesomeIcons.check,
                  // Colors.grey,
                ),
              cardWedgit(
                AppLocalization.received.tr,
                message.message.recievedAt != null
                    ? DateTimeFormatter.formatDateTimeyMMMdHHSS(
                        message.message.recievedAt!,
                      )
                    : AppLocalization.notReceivedYet.tr,
                FontAwesomeIcons.checkDouble,
              ),
              cardWedgit(
                AppLocalization.read.tr,
                message.message.readAt != null
                    ? DateTimeFormatter.formatDateTimeyMMMdHHSS(
                        message.message.readAt!,
                      )
                    : AppLocalization.notReadYet.tr,
                FontAwesomeIcons.checkDouble,
                Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card cardWedgit(String title, String date, IconData icon, [Color? color]) {
    return Card(
        child: ListTile(
      title: Text(
        "$title  ",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Get.isPlatformDarkMode ? Colors.white : Colors.black,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          date,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Get.isPlatformDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
      ),
      leading: Icon(
        icon,
        color: color,
        size: 16,
      ),
    ));
  }
}
