import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/date_time_formatter.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:get/get.dart';

class ChatMediaLinksScreenController extends GetxController {
  ConversationController conversationController = Get.find();

  Map<String, List<MessageAndMultimedia>> getMessagesGroupedByDate(
      List<MessageAndMultimedia> messagesList) {
    Map<String, List<MessageAndMultimedia>> mediaByDate = {};

    for (var media in messagesList) {
      final date =
          DateTimeFormatter.getRecentOrYesterdayOrLastMonthOrMonthOrYear(
              media.message.createdAt);

      if (!mediaByDate.containsKey(date)) {
        mediaByDate[date] = [];
      }

      mediaByDate[date]!.add(media);
    }
    return mediaByDate;
  }

  Map<String, List<LocalMultimedia>> get mediaList {
    return getMessagesGroupedByDate(
      conversationController.messages
          .where(
            (m) =>
                m.multimedia != null &&
                m.multimedia!.path != null &&
                (m.multimedia!.type ==
                        MultimediaTypes.image.value.toLowerCase() ||
                    m.multimedia!.type ==
                        MultimediaTypes.video.value.toLowerCase()),
          )
          .toList(),
    ).map(
      (key, value) => MapEntry(
        key,
        value.map((e) => e.multimedia!).toList(),
      ),
    );
  }

  Map<String, List<LocalMultimedia>> get docsList {
    return getMessagesGroupedByDate(
      conversationController.messages
          .where(
            (m) =>
                m.multimedia != null &&
                m.multimedia!.path != null &&
                (m.multimedia!.type ==
                        MultimediaTypes.file.value.toLowerCase() ||
                    m.multimedia!.type ==
                        MultimediaTypes.archive.value.toLowerCase()),
          )
          .toList(),
    ).map(
      (key, value) => MapEntry(
        key,
        value.map((e) => e.multimedia!).toList(),
      ),
    );
  }

  Map<String, List<LocalMessage>> get linksList {
    return getMessagesGroupedByDate(
      conversationController.messages
          .where((m) =>
              m.message.body != null && AppUtil.hasURLInText(m.message.body!))
          .toList(),
    ).map(
      (key, value) => MapEntry(
        key,
        value
            .map(
              (e) => e.message,
            )
            .toList(),
      ),
    );
  }
}
