import 'package:ashghal_app_frontend/config/chat_theme.dart';
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
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ConversationScreen extends StatelessWidget {
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

  final ConversationScreenController _screenController = Get.find();

  final InsertingMessageController insertingMessageController = Get.put(
    InsertingMessageController(),
  );

  final MultimediaController multimediaController = Get.put(
    MultimediaController(),
  );

  final AudioController audioController = Get.put(AudioController());

  final int currentUserId = SharedPref.currentUserId!;

  DateTime getDateMDY(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Get.isPlatformDarkMode ? ChatTheme.dark : ChatTheme.light,
      child: Scaffold(
        appBar: ConversationScreenAppBar(conversation: conversation),
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
                                          child: Icon(
                                            Icons
                                                .keyboard_double_arrow_down_outlined,
                                            color: Get.isPlatformDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            size: 33,
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
              Card(
                color: Get.isPlatformDarkMode
                    ? ChatColors.appBarDark
                    : ChatColors.appBarLight,
                margin: const EdgeInsets.all(0),
                child: ActionBar(),
              )

              // _buildFooter(context)
            ],
          ),
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

        bool isSameDate = false;
        String? dateString = null;

        // final DateTime date = DateTime(
        //   currentMessage.message.createdAt.year,
        //   currentMessage.message.createdAt.month,
        //   currentMessage.message.createdAt.day,
        // );
        // take care the messages list is reversed by the Listview
        // if the index 0 and the number of all messages are one
        print("index $index");
        if (index == 0 && controller.messages.length == 1) {
          dateString =
              groupMessageDateAndTime(currentMessage.message.createdAt);
        } else if (index == controller.messages.length - 1) {
          dateString =
              groupMessageDateAndTime(currentMessage.message.createdAt);
        }
        // else if(){

        // }
        else {
          final DateTime date = getDateMDY(currentMessage.message.createdAt);
          final DateTime prevDate =
              getDateMDY(controller.messages[index + 1].message.createdAt);
          isSameDate = date.isAtSameMomentAs(prevDate);
          dateString = isSameDate
              ? ''
              : groupMessageDateAndTime(
                  controller.messages[index].message.createdAt);
          // if (prevDate != date) {

          //   dateString =
          //       groupMessageDateAndTime(currentMessage.message.createdAt);
        }
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
              child:
                  buildMessageWidget(currentMessage, index, dateString ?? ""),
            );
          },
        );
      },
    );
  }

  Widget buildMessageWidget(
    MessageAndMultimediaModel currentMessage,
    int index,
    String dateString,
  ) {
    return Column(
      children: [
        if (dateString.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(dateString),
          ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          color: _screenController.selectedMessagesIds
                      .contains(currentMessage.message.localId) ||
                  index == _screenController.searchSelectedMessage.value
              ? Colors.green.withOpacity(0.4)
              : null,
          child: MessageWidget(message: currentMessage),
        ),
      ],
    );
  }

  // Widget _buildFooter(BuildContext context) {
  //   return Card(
  //     color: Get.isPlatformDarkMode
  //         ? ChatColors.appBarDark
  //         : ChatColors.appBarLight,
  //     margin: const EdgeInsets.only(top: 0),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(15),
  //         topRight: Radius.circular(15),
  //       ),
  //     ),
  //     // color: Colors.grey,
  //     // alignment: Alignment.bottomCenter,

  //     // decoration: BoxDecoration(
  //     //   // color: Color.fromRGBO(25, 39, 52, 1),

  //     //   borderRadius: const BorderRadius.only(
  //     //     topLeft: Radius.circular(15),
  //     //     topRight: Radius.circular(15),
  //     //   ),
  //     // ),
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 8.0),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Row(
  //             children: [
  //               // Expanded(
  //               //   flex: 5,
  //               //   child: ChatTextFormFieldWidget(),
  //               // ),
  //               Expanded(
  //                 child: SendButtonWidget(
  //                   insertingMessageController: insertingMessageController,
  //                 ),
  //               )
  //             ],
  //           ),
  //           //this widget shows or unshows its child based on the offstage value
  //           GetX<InsertingMessageController>(
  //             builder: (controller) => Offstage(
  //               offstage: !controller.emojiPickerShowing.value,
  //               child: SizedBox(
  //                 height: 250,
  //                 child: EmojiPickerWidget(
  //                   textEditingController: insertingMessageController
  //                       .messageTextEdittingController,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
