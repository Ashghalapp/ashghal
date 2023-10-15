// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
// import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
// import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';

// class TempChatPage extends StatefulWidget {
//   final LocalConversation conversation;
//   // final ConversationScreenController _screenController;
//   const TempChatPage({super.key, required this.conversation});
//   // : _screenController = Get.put(
//   //       ConversationScreenController(conversation: conversation));

//   @override
//   State<TempChatPage> createState() => _TempChatPageState();
// }

// class _TempChatPageState extends State<TempChatPage> {
//   types.Status getMessageStatus(LocalMessage message) {
//     if (message.sentAt != null) {
//       if (message.recievedAt != null) {
//         if (message.readAt != null) {
//           return types.Status.seen;
//         }
//         return types.Status.delivered;
//       }
//       return types.Status.sent;
//     }
//     return types.Status.sending;
//   }

//   types.TextMessage toTextMessage(LocalMessage message) {
//     return types.TextMessage(
//       author: _conversationController.currentUser,
//       createdAt: message.createdAt.millisecond,
//       id: message.localId.toString(),
//       remoteId: message.remoteId?.toString(),
//       roomId: _conversationController.conversationId.toString(),
//       showStatus: SharedPref.currentUserId == message.senderId,
//       status: getMessageStatus(message),
//       type: types.MessageType.text,
//       updatedAt: message.updatedAt.millisecond,
//       text: message.body ?? "",
//     );
//   }

//   types.Message toMultimediaMessage(
//       types.Message message, LocalMultimedia multimedia) {
//     if (multimedia.type == "file") {
//       return types.FileMessage(
//         author: _conversationController.currentUser,
//         name: multimedia.fileName,
//         size: num.parse("15"),
//         uri: multimedia.url!,
//         createdAt: message.createdAt,
//         id: message.id.toString(),
//         remoteId: message.remoteId?.toString(),
//         roomId: _conversationController.conversationId.toString(),
//         showStatus: message.showStatus,
//         status: message.status,
//         type: types.MessageType.text,
//         updatedAt: message.updatedAt,
//         // text: message.body ?? "",
//       );
//     }
//     // else if(multimedia.type=="image"){
//     return types.ImageMessage(
//       author: _conversationController.currentUser,
//       name: multimedia.fileName,
//       size: num.parse("15"),
//       uri: multimedia.url!,
//       createdAt: message.createdAt,
//       id: message.id.toString(),
//       remoteId: message.remoteId?.toString(),
//       roomId: _conversationController.conversationId.toString(),
//       showStatus: message.showStatus,
//       status: message.status,
//       type: types.MessageType.text,
//       updatedAt: message.updatedAt,
//       // text: message.body ?? "",
//     );
//     // }
//   }

//   List<types.Message> _messages = [];
//   // bool isLoading = true;
//   // final _user = const types.User(
//   //   id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
//   // );
//   final ConversationScreenController _screenController = Get.find();
//   final ConversationController _conversationController = Get.find();
//   @override
//   void initState() {
//     super.initState();
//     _conversationController.listenToAllMessages().listen((localMessages) {
//       for (var localMessage in localMessages) {
//         // _insertOrReplaceMessage(localMessage);
//         _insertOrReplaceMessage(localMessage);
//       }
//     });

//     _conversationController.listenToMultimedia().listen((localMultimedia) {
//       for (var multimedia in localMultimedia) {
//         // _insertOrReplaceMessage(localMessage);
//         insertOrReplaceMultimedia(multimedia);
//       }
//     });
//     // _conversationController.insertOrReplaceMessage =
//     //     (localMessage) => _insertOrReplaceMessage(localMessage);
//     // _conversationController.initialize().then((value) {
//     //   if (mounted) {
//     //     setState(() {
//     //       isLoading = false;
//     //     });
//     //     // _loadMessages();
//     //   }
//     // });
//   }

//   void _insertOrReplaceMessage(LocalMessage message) {
//     int index = _messages
//         .indexWhere((element) => element.id == message.localId.toString());
//     if (index == -1) {
//       setState(() {
//         _messages.insert(0, toTextMessage(message));
//       });
//       print(
//           "<><><><><><> Mine Inserted New Message, messages length:${_messages.length}");
//     } else {
//       // _messages[index] = toTextMessage(message);
//       setState(() {
//         _messages[index] = toTextMessage(message);
//       });
//       // _messages.replaceRange(index - 1, index, [toTextMessage(message)]);
//       print(
//           "<><><><><><> Mine Message updated, messages length:${_messages.length}");
//     }
//     // messages.refresh();
//   }

//   void insertOrReplaceMultimedia(LocalMultimedia multimedia) {
//     int index = _messages
//         .indexWhere((element) => element.id == multimedia.messageId.toString());
//     if (index == -1) {
//     } else {
//       // print("multimedia ${multimedia.toString()}");
//       setState(() {
//         _messages.replaceRange(index - 1, index,
//             [toMultimediaMessage(_messages[index], multimedia)]);
//         // _messages[index] = ;
//       });
//       print(
//           "<><><><><><> Mine Multimedia updated, messages length:${_messages.length}");
//       // messages[index] = messages[index].copyWith(multimedia: multimedia);
//     }
//     // messages.refresh();
//   }

//   // void _addMessage(types.Message message) {
//   //   setState(() {
//   //     _messages.insert(0, message);
//   //   });
//   // }

//   // void _loadMessages() async {
//   //   final response = await rootBundle.loadString('assets/messages.json');
//   //   final messages = (jsonDecode(response) as List)
//   //       .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
//   //       .toList();

//   //   setState(() {
//   //     _messages = messages;
//   //   });
//   // }

//   void _handleAttachmentPressed() {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) => SafeArea(
//         child: SizedBox(
//           height: 144,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // _handleImageSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Photo'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleFileSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('File'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Cancel'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleFileSelection() async {
//     print("File Selection");
//     print(_conversationController.insertOrReplaceMessage.toString());
//     // final result = await FilePicker.platform.pickFiles(
//     //   type: FileType.any,
//     // );

//     // if (result != null && result.files.single.path != null) {
//     //   final message = types.FileMessage(
//     //     author: _user,
//     //     createdAt: DateTime.now().millisecondsSinceEpoch,
//     //     id: Random().nextDouble().toString(),
//     //     // mimeType: lookupMimeType(result.files.single.path!),
//     //     name: result.files.single.name,
//     //     size: result.files.single.size,
//     //     uri: result.files.single.path!,
//     //   );

//     //   _addMessage(message);
//     // }
//   }

//   // void _handleImageSelection() async {
//   //   final result = await ImagePicker().pickImage(
//   //     imageQuality: 70,
//   //     maxWidth: 1440,
//   //     source: ImageSource.gallery,
//   //   );

//   //   if (result != null) {
//   //     final bytes = await result.readAsBytes();
//   //     final image = await decodeImageFromList(bytes);

//   //     final message = types.ImageMessage(
//   //       author: _user,
//   //       createdAt: DateTime.now().millisecondsSinceEpoch,
//   //       height: image.height.toDouble(),
//   //       id: Random().nextDouble().toString(),
//   //       name: result.name,
//   //       size: bytes.length,
//   //       uri: result.path,
//   //       width: image.width.toDouble(),
//   //     );

//   //     _addMessage(message);
//   //   }
//   // }

//   // void _handleMessageTap(BuildContext _, types.Message message) async {
//   //   if (message is types.FileMessage) {
//   //     var localPath = message.uri;

//   //     if (message.uri.startsWith('http')) {
//   //       try {
//   //         // final index =
//   //         //     _messages.indexWhere((element) => element.id == message.id);
//   //         // final updatedMessage =
//   //         //     (_messages[index] as types.FileMessage).copyWith(
//   //         //   isLoading: true,
//   //         // );

//   //         // setState(() {
//   //         //   _messages[index] = updatedMessage;
//   //         // });

//   //         final client = http.Client();
//   //         final request = await client.get(Uri.parse(message.uri));
//   //         final bytes = request.bodyBytes;
//   //         final documentsDir = (await getApplicationDocumentsDirectory()).path;
//   //         localPath = '$documentsDir/${message.name}';

//   //         if (!File(localPath).existsSync()) {
//   //           final file = File(localPath);
//   //           await file.writeAsBytes(bytes);
//   //         }
//   //       } finally {
//   //         final index =
//   //             _messages.indexWhere((element) => element.id == message.id);
//   //         final updatedMessage =
//   //             (_messages[index] as types.FileMessage).copyWith(
//   //           isLoading: null,
//   //         );

//   //         setState(() {
//   //           _messages[index] = updatedMessage;
//   //         });
//   //       }
//   //     }

//   //     await OpenFile.open(localPath);
//   //   }
//   // }

//   // void _handlePreviewDataFetched(
//   //   types.TextMessage message,
//   //   types.PreviewData previewData,
//   // ) {
//   //   final index = _messages.indexWhere((element) => element.id == message.id);
//   //   final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
//   //     previewData: previewData,
//   //   );

//   //   setState(() {
//   //     _messages[index] = updatedMessage;
//   //   });
//   // }

//   void _handleSendPressed(types.PartialText message) {
//     // final textMessage = types.TextMessage(
//     //   author: _user,
//     //   createdAt: DateTime.now().millisecondsSinceEpoch,
//     //   id: Random().nextDouble().toString(),
//     //   text: message.text,
//     // );

//     // _addMessage(textMessage);
//   }

//   // void _loadMessages() async {
//   //   final response = await rootBundle.loadString('assets/messages.json');
//   //   final messages = (jsonDecode(response) as List)
//   //       .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
//   //       .toList();

//   //   setState(() {
//   //     _messages = messages;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           // isLoading
//           //     ? const Center(
//           //         child: CircularProgressIndicator(),
//           //       )
//           //     :
//           Chat(
//         messages: _messages,
//         onAttachmentPressed: _handleAttachmentPressed,
//         // onMessageTap: _handleMessageTap,
//         // onPreviewDataFetched: _handlePreviewDataFetched,
//         onSendPressed: _handleSendPressed,
//         showUserAvatars: true,
//         showUserNames: true,
//         user: _conversationController.currentUser,
//       ),
//     );
//   }
// }
