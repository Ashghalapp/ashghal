import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/domain/entities/matched_conversation_and_messages.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/highlightable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationSearchWidget extends StatelessWidget {
  final MatchedConversationsAndMessage matchedConversation;
  final String? searchText;

  ConversationSearchWidget({
    super.key,
    required this.matchedConversation,
    this.searchText,
  });

  final ChatScreenController _controller = Get.find();

  String getLastMessageStringDate() {
    return AppUtil.formatDateTime(matchedConversation.message.createdAt);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _controller.forwardSelectionEnabled.value
          ? _controller
              .selectConversation(matchedConversation.conversation.localId)
          : _controller.goToConversationScreen(
              matchedConversation.conversation,
              matchedConversation.message,
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      matchedConversation.conversation.userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text(
                  getLastMessageStringDate(),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Opacity(
                opacity: 0.8,
                child: buildSearchMatchedMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? buildSearchMatchedMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: HighlightableTextWidget(
            text: matchedConversation.message.body ?? "",
            searchText: searchText ?? "",
          ),
        ),
      ],
    );
  }
}
