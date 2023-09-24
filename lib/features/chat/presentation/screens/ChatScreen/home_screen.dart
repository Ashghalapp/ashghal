import 'package:ashghal_app_frontend/features/chat/presentation/screens/ChatScreen/chat_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/ChatScreen/profile_chat_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/file_message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' as foundation;

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
            // leadingWidth: 75,
            // leading: InkWell(
            //   onTap: () {
            //     Get.back();
            //   },
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Icon(
            //         Icons.arrow_back,
            //         size: 25,
            //       ),
            //       AvatarWithImageOrLetter(
            //         imageUrl: null,
            //         userName: "Mujahid Hilal",
            //         raduis: 35,
            //       ),
            //     ],
            //   ),
            // ),
            // title: Padding(
            //   padding: const EdgeInsets.all(5.0),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Mujahid Hilal",
            //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            //       ),
            //       Text(
            //         "Last Seen since 2014/12/4",
            //         style: TextStyle(fontSize: 13),
            //       ),
            //     ],
            //   ),
            // ),
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.videocam),
            //     onPressed: () {},
            //   ),
            //   IconButton(
            //     icon: const Icon(Icons.call),
            //     onPressed: () {},
            //   ),
            // ],
            ),
        body: ListView(
          children: [
            FileMessageCard(),
            FileMessageCard(),
            ElevatedButton(
              onPressed: () {
                Get.to(() => ChatScreen());
              },
              child: const Text("Open Chat"),
            ),
          ],
        )
        // Container(
        // height: MediaQuery.sizeOf(context).height,
        // width: MediaQuery.sizeOf(context).width,
        //this widget enables you to controll when the user presses the back button
        //   child: WillPopScope(
        //     onWillPop: _screenController.backButtonPressed,
        //     child: Stack(
        //       children: [
        //         ListView(
        //           shrinkWrap: true,
        //           // controller: _screenController.scrollController,
        //           children: [
        //             ElevatedButton(
        //               onPressed: () {
        //                 Get.to(() => ChatScreen());
        //               },
        //               child: const Text("Open Chat"),
        //             ),
        //           ],
        //         ),
        //         _buildFooter(context)
        //       ],
        //     ),
        //   ),
        // ),

        //     Column(
        //   children: [
        //     // Image.network(
        //     //     "http://localhost:8000/storage/multimedia/users/images/vlcVyqiok0SxffEswrhZJZ8UwLUtGLnDIsd7RDVa.jpg"),
        //     Center(
        //       child: ElevatedButton(
        //         onPressed: () {
        //           Get.to(() => ChatScreen());
        //         },
        //         child: const Text("Open Chat"),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }

  // Align _buildFooter(BuildContext context) {
  //   return Align(
  //     alignment: Alignment.bottomCenter,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Row(
  //           children: [
  //             // Image.asset(
  //             //   "assets/images/whatsapp_Back.png",
  //             //   height: MediaQuery.of(context).size.height,
  //             //   width: MediaQuery.of(context).size.width,
  //             //   fit: BoxFit.cover,
  //             // ),
  //             Container(
  //               width: MediaQuery.sizeOf(context).width * 0.85,
  //               child: Card(
  //                 margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(25),
  //                 ),
  //                 child: TextFormField(
  //                   controller: _screenController.messageTextEdittingController,
  //                   focusNode: _screenController.messageFieldFocusNode,
  //                   textAlignVertical: TextAlignVertical.center,
  //                   keyboardType: TextInputType.multiline,
  //                   maxLines: 5,
  //                   minLines: 1,
  //                   decoration: InputDecoration(
  //                     hintText: "Message",
  //                     contentPadding: EdgeInsets.all(5),
  //                     border: InputBorder.none,
  //                     prefixIcon: GetX<InsertingMessageController>(
  //                       builder: (controller) => IconButton(
  //                         onPressed: controller.imojiButtonPressed,
  //                         icon: Icon(controller.emojiPickerShowing.value
  //                             ? Icons.keyboard
  //                             : Icons.emoji_emotions_outlined),
  //                       ),
  //                     ),
  //                     suffixIcon: Row(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         IconButton(
  //                           onPressed: () {},
  //                           icon: Icon(Icons.attach_file),
  //                         ),
  //                         IconButton(
  //                           onPressed: () {},
  //                           icon: Icon(Icons.camera_alt),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             _buildSendOrRegiterButton(),
  //           ],
  //         ),
  //         //this widget shows or unshows its child based on the offstage value
  //         GetX<InsertingMessageController>(
  //           builder: (controller) => Offstage(
  //             offstage: !controller.emojiPickerShowing.value,
  //             child: SizedBox(
  //               height: 250,
  //               child: emojiPicker(),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget emojiPicker() {
  //   return EmojiPicker(
  //     onEmojiSelected: (Category? category, Emoji emoji) {
  //       // _screenController.messageTextEdittingController.text += emoji.emoji;
  //     },
  //     onBackspacePressed: () {
  //       // Do something when the user taps the backspace button (optional)
  //       // Set it to null to hide the Backspace-Button
  //     },
  //     textEditingController: _screenController
  //         .messageTextEdittingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
  //     config: Config(
  //       columns: 7,
  //       emojiSizeMax: 32 *
  //           (foundation.defaultTargetPlatform == TargetPlatform.iOS
  //               ? 1.30
  //               : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
  //       verticalSpacing: 0,
  //       horizontalSpacing: 0,
  //       gridPadding: EdgeInsets.zero,
  //       initCategory: Category.RECENT,
  //       bgColor: Color(0xFFF2F2F2),
  //       indicatorColor: Colors.blue,
  //       iconColor: Colors.grey,
  //       iconColorSelected: Colors.blue,
  //       backspaceColor: Colors.blue,
  //       skinToneDialogBgColor: Colors.white,
  //       skinToneIndicatorColor: Colors.grey,
  //       enableSkinTones: true,
  //       recentTabBehavior: RecentTabBehavior.RECENT,
  //       recentsLimit: 28,
  //       noRecents: const Text(
  //         'No Recents',
  //         style: TextStyle(fontSize: 20, color: Colors.black26),
  //         textAlign: TextAlign.center,
  //       ), // Needs to be const Widget
  //       loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
  //       tabIndicatorAnimDuration: kTabScrollDuration,
  //       categoryIcons: const CategoryIcons(),
  //       buttonMode: ButtonMode.MATERIAL,
  //     ),
  //   );
  // }

  // Padding _buildSendOrRegiterButton() {
  //   return Padding(
  //     padding: const EdgeInsets.only(
  //       bottom: 8,
  //       right: 2,
  //       left: 2,
  //     ),
  //     child: CircleAvatar(
  //         radius: 25,
  //         backgroundColor: const Color(0xFF128C7E),
  //         child: GetX<InsertingMessageController>(
  //           builder: (controller) {
  //             return IconButton(
  //               icon: Icon(
  //                 controller.sendButtonEnabled.value ? Icons.send : Icons.mic,
  //                 color: Colors.white,
  //               ),
  //               onPressed: () {
  //                 if (_screenController.sendButtonEnabled.value) {
  //                   // _screenController.scrollController.animateTo(
  //                   //   _screenController
  //                   //       .scrollController.position.maxScrollExtent,
  //                   //   duration: const Duration(milliseconds: 300),
  //                   //   curve: Curves.easeOut,
  //                   // );
  //                 }
  //               },
  //             );
  //           },
  //         )),
  //   );
  // }
}

/// Example for EmojiPickerFlutter
class TestEmoji extends StatefulWidget {
  @override
  _TestEmojiState createState() => _TestEmojiState();
}

class _TestEmojiState extends State<TestEmoji> {
  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Emoji Picker Example App'),
        ),
        body: Column(
          children: [
            const Spacer(),
            Container(
                height: 66.0,
                color: Colors.blue,
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            emojiShowing = !emojiShowing;
                          });
                        },
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                            controller: _controller,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 16.0,
                                  bottom: 8.0,
                                  top: 8.0,
                                  right: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            )),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                          onPressed: () {
                            // send message
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    )
                  ],
                )),
            Offstage(
              offstage: !emojiShowing,
              child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    textEditingController: _controller,
                    onBackspacePressed: _onBackspacePressed,
                    config: Config(
                      columns: 7,
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      emojiSizeMax: 32 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.30
                              : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      recentTabBehavior: RecentTabBehavior.RECENT,
                      recentsLimit: 28,
                      replaceEmojiOnLimitExceed: false,
                      noRecents: const Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      loadingIndicator: const SizedBox.shrink(),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                      checkPlatformCompatibility: true,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
