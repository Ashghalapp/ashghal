import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/data/models/message_and_multimedia.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/appbar/conversation_screen_appbar.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/chat_text_form_field_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/emoji_picker_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/message_widget.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/footer/send_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ConversationScreen extends StatefulWidget {
  final LocalConversation conversation;

  ConversationScreen({
    super.key,
    required this.conversation,
  });

  static String groupMessageDateAndTime(DateTime dateTime) {
    // var dt = DateTime.fromMicrosecondsSinceEpoch(int.parse(time.toString()));
    // var originalDate = DateFormat('MM/dd/yyyy').format(dt);

    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String difference = '';
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      difference = "Today";
    } else if (messageDate == yesterday) {
      difference = "Yesterday";
    } else {
      difference = AppUtil.formatDateTimeyMMMd(dateTime);
    }

    return difference;
  }

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ConversationScreenController _screenController = Get.find();

  final InsertingMessageController insertingMessageController = Get.put(
    InsertingMessageController(),
  );

  final MultimediaController multimediaController = Get.put(
    MultimediaController(),
  );

  final AudioController audioController = Get.put(AudioController());

  // final VideoController videoController = Get.put(VideoController());
  final int currentUserId = SharedPref.currentUserId!;

  DateTime getDateMDY(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) {
    //     _screenController.scrollToPosition(
    //         _screenController.conversationController.messages.length - 1);
    //   },
    // );
  }

  // final isSearching = false.obs;
  @override
  Widget build(BuildContext context) {
    // _screenController.conversationId = 5
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(60),
      //   child: Obx(
      //     () => toggleAppBar(),
      //   ),
      // ),
      backgroundColor: const Color.fromRGBO(34, 48, 60, 1),
      appBar: ConversationScreenAppBar(conversation: widget.conversation),
      body: WillPopScope(
        onWillPop: insertingMessageController.backButtonPressed,
        child: Column(
          children: [
            Expanded(
              child: GetX<ConversationController>(
                builder: (controller) {
                  return controller.messages.isEmpty
                      ? const Text("No Messages Yet")
                      : Stack(
                          children: [
                            buildMessagesList(controller),
                            Obx(
                              () => _screenController.showScrollDownIcon.value
                                  ? Positioned(
                                      bottom: 30,
                                      right: 8,
                                      child: InkWell(
                                        onTap: () => _screenController
                                            .scrollToFirstOrBottom(true),
                                        child: const Icon(
                                          Icons
                                              .keyboard_double_arrow_down_outlined,
                                          color: Colors.white,
                                          size: 30,
                                          // size: 20,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        );
                },
              ),
            ),
            _buildFooter(context)
          ],
        ),
      ),
    );
  }

  ScrollablePositionedList buildMessagesList(
      ConversationController controller) {
    return ScrollablePositionedList.builder(
      reverse: true,
      shrinkWrap: true,
      itemCount: controller.messages.length,
      itemScrollController: _screenController.messagesScrollController,
      itemPositionsListener: _screenController.scrollListener,
      itemBuilder: (_, index) {
        final currentMessage = controller.messages[index];

        // bool isSameDate = false;
        // String? newDate = '';

        // final DateTime date = DateTime(
        //   currentMessage.message.createdAt.year,
        //   currentMessage.message.createdAt.month,
        //   currentMessage.message.createdAt.day,
        // );

        // if (index == 0 && controller.messages.length == 1) {
        //   newDate = groupMessageDateAndTime(currentMessage.message.createdAt);
        // } else if (index == controller.messages.length - 1) {
        //   newDate = groupMessageDateAndTime(currentMessage.message.createdAt);
        // } else {
        //   final DateTime date = getDateMDY(currentMessage.message.createdAt);
        //   final DateTime prevDate = getDateMDY(controller.messages[index+1].message.createdAt);

        // returnDateAndTimeFormat(
        //     messagesList[index + 1].timeStamp.toString());
        // isSameDate = date.isAtSameMomentAs(prevDate);

        // if (kDebugMode) {
        //   print("$date $prevDate $isSameDate");
        // }
        // newDate = isSameDate
        //     ? ''
        //     : groupMessageDateAndTime(
        //             messagesList[index - 1].timeStamp.toString())
        //         .toString();
        // }
        // print(currentMessage.message.toString());
        // print(currentMessage.multimedia.toString());
        // if (currentMessage.multimedia != null) {
        //   return Text("Message With multimedia");
        // } else {
        //   return Text("Only Text");
        // }
        return Obx(
          () {
            return InkWell(
              onTap: () {
                _screenController.selectMessage(currentMessage.message.localId);
              },
              onLongPress: () {
                _screenController.selectionEnabled.value = true;
                _screenController.selectMessage(currentMessage.message.localId);
              },
              child: buildMessageWidget(currentMessage, index),
            );
          },
        );
      },
    );
  }

  Container buildMessageWidget(
      MessageAndMultimediaModel currentMessage, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      color: _screenController.selectedMessagesIds
                  .contains(currentMessage.message.localId) ||
              index == _screenController.searchSelectedMessage.value
          ? Colors.green.withOpacity(0.4)
          : null,
      child: MessageWidget(message: currentMessage),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      // color: Colors.grey,
      // alignment: Alignment.bottomCenter,

      decoration: const BoxDecoration(
          color: Color.fromRGBO(25, 39, 52, 1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: ChatTextFormFieldWidget(),
              ),
              Expanded(
                child: SendButtonWidget(
                  insertingMessageController: insertingMessageController,
                ),
              )
            ],
          ),
          //this widget shows or unshows its child based on the offstage value
          GetX<InsertingMessageController>(
            builder: (controller) => Offstage(
              offstage: !controller.emojiPickerShowing.value,
              child: SizedBox(
                height: 250,
                child: EmojiPickerWidget(
                  textEditingController:
                      insertingMessageController.messageTextEdittingController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
