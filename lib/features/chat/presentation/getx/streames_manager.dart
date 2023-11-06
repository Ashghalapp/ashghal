import 'dart:async';

import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/conversation_last_message_and_count.dart';

class StreamsManager {
  static StreamsManager? _instance;
  static StreamSubscription<List<LocalConversation>>? allConversationsStream;
  static StreamSubscription<List<ConversationlastMessageAndCount>>?
      conversationsLastMessageAndCountStream;
  static StreamSubscription<List<LocalMessage>>? allMessagesStream;
  static StreamSubscription<List<MessageAndMultimediaModel>>?
      messagesAndMultimediaStream;
  StreamsManager._();
  factory StreamsManager() {
    return _instance ?? StreamsManager._();
  }
  listenToConversationsStream(Stream<List<LocalConversation>> stream,
      void Function(List<LocalConversation>)? onData) async {
    if (allConversationsStream != null) {
      AppPrint.printWarning("Cancel all conversations previuos listener");
      await allConversationsStream!.cancel();
    } else {
      AppPrint.printWarning("Create all conversations first listener");
    }
    allConversationsStream = stream.listen(onData);
  }

  listenToConversationsLastMessageAndCountStream(
      Stream<List<ConversationlastMessageAndCount>> stream,
      void Function(List<ConversationlastMessageAndCount>)? onData) async {
    if (conversationsLastMessageAndCountStream != null) {
      AppPrint.printWarning(
          "Cancel conversations last message and count previuos listener");
      await conversationsLastMessageAndCountStream!.cancel();
    } else {
      AppPrint.printWarning(
          "Create conversations last message and count first listener");
    }
    conversationsLastMessageAndCountStream = stream.listen(onData);
  }

  listenAllMessagesStream(Stream<List<LocalMessage>> stream,
      void Function(List<LocalMessage>)? onData) async {
    if (allMessagesStream != null) {
      AppPrint.printWarning("Cancel all messages previuos listener");
      await allMessagesStream!.cancel();
    } else {
      AppPrint.printWarning("Create all messages first listener");
    }
    allMessagesStream = stream.listen(onData);
  }

  listenMessagesAndMultimediaStream(
      Stream<List<MessageAndMultimediaModel>> stream,
      void Function(List<MessageAndMultimediaModel>)? onData) async {
    if (messagesAndMultimediaStream != null) {
      AppPrint.printWarning("Cancel messages and multimedia previuos listener");
      await messagesAndMultimediaStream!.cancel();
    } else {
      AppPrint.printWarning("Create messages and multimedia first listener");
    }
    messagesAndMultimediaStream = stream.listen(onData);
  }

  cancelConversationsListener() async {
    if (allConversationsStream != null) {
      AppPrint.printWarning("Cancel all conversations previuos listener");
      await allConversationsStream!.cancel();
    }
    allConversationsStream = null;
  }

  cancelToConversationsLastMessageAndCountListener() async {
    if (conversationsLastMessageAndCountStream != null) {
      AppPrint.printWarning(
          "Cancel conversations last message and count previuos listener");
      await conversationsLastMessageAndCountStream!.cancel();
    }
    conversationsLastMessageAndCountStream = null;
  }

  cancelAllMessagesListener() async {
    if (allMessagesStream != null) {
      AppPrint.printWarning("Cancel all messages previuos listener");
      await allMessagesStream!.cancel();
    }
    allMessagesStream = null;
  }

  cancelMessagesAndMultimediaListener() async {
    if (messagesAndMultimediaStream != null) {
      AppPrint.printWarning("Cancel messages and multimedia previuos listener");
      await messagesAndMultimediaStream!.cancel();
    }
    messagesAndMultimediaStream = null;
  }
}
