// import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
// import 'package:ashghal_app_frontend/core/util/app_util.dart';
// import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
// import 'package:ashghal_app_frontend/features/post/domain/entities/reply.dart';
// import 'package:ashghal_app_frontend/features/post/presentation/getx/comment_controller.dart';
// import 'package:ashghal_app_frontend/features/post/presentation/getx/comment_input_controller.dart';
// // import 'package:ashghal_app_frontend/features/post/domain/entities/reply.dart';
// import 'package:ashghal_app_frontend/features/post/presentation/widget/circle_cached_networkimage.dart';
// import 'package:ashghal_app_frontend/features/post/presentation/widget/comment_input_widget.dart';
// import 'package:ashghal_app_frontend/features/post/presentation/widget/comment_reply_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../app_library/app_data_types.dart';
// import '../../domain/entities/comment.dart';
// import '../getx/reply_controller.dart';


// class CommentCardWidget extends StatelessWidget {
//   final dynamic comment;
//   CommentStatus status;
//   // bool isFaildToSend;
//   final void Function(int, String, {DateTime widgetCreatedAt})? resendFunction;
//   final void Function(int, int, String, {DateTime widgetCreatedAt})?
//       resendReplyFunction;
//   DateTime currentTimeWidget = DateTime.now();
//   CommentCardWidget({
//     super.key,
//     required this.comment,
//     this.status = CommentStatus.recieved,
//     // this.isFaildToSend = false,
//     this.resendFunction,
//     DateTime? setCurrentTime,
//     this.resendReplyFunction,
//   }) {
//     if (setCurrentTime != null) {
//       currentTimeWidget = setCurrentTime;
//     }
//   }

//   /// متغير يتم استخدامه لعرض الردود الخاصة بالتعليق
//   final RxBool showReplies = false.obs;

//   /// متغير يتم استخدامه لعرض صندوق الكتابة عند الرغبة في الرد على تعليق محدد
//   final RxBool isAddReply = false.obs;

//   ///
//   bool isNextTapToHideField = false;

//   final CommentInputController focusedController = Get.find();

//   late ReplyController replyController;

//   final int randInt = DateTime.now().millisecondsSinceEpoch;

//   // final RxList<Reply> replies = <Reply>[].obs;

//   /// متحكم يتم استخدامه في صندوق ادخال الرد لكل تعليق حتى يتم الاحتفاظ بالقيمة
//   final TextEditingController textInputController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     printInfo(info: ":::::::::::$currentTimeWidget");
//     // focusedController.isAddCommentFocused.value = true;
//     replyController = Get.find<ReplyController>();
//     // replyController = Get.put(ReplyController(), tag: comment.id.toString());
//     // var commentController = Get.put(CommentController());
//     return GetBuilder(
//         init: CommentController(),
//         builder: (controller) {
//           return Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // صورة المستخدم
//                   Container(
//                     // color: Colors.amber,
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     child: buildCircleCachedNetworkImage(
//                       imageUrl: comment.imageUrl,
//                       radius: 46,
//                     ),
//                   ),
//                   // اسم المستخد ونص التعليق وزر الرد
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(
//                             right: Get.locale?.languageCode == 'en' ? 5 : 0,
//                             left: Get.locale?.languageCode == 'ar' ? 5 : 0,
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 7, horizontal: 15),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 comment.basicUserData['name'].toString(),
//                                 style: Get.textTheme.titleMedium?.copyWith(
//                                   color: Colors.black,
//                                 ),
//                                 overflow: TextOverflow.clip,
//                               ),
//                               // const SizedBox(height: 2),
//                               if (comment is Reply)
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       color: Get.theme.highlightColor,
//                                       borderRadius: BorderRadius.circular(15)),
//                                   child: CustomTextAndIconButton(
//                                     icon: const Icon(null, size: 0),
//                                     text: Text(
//                                       comment.basicUserData!['name'].toString(),
//                                       style: Get.textTheme.bodyMedium?.copyWith(
//                                           color: Get.theme.primaryColor),
//                                     ),
//                                     onPressed: () {
//                                       // go to profile screen by use user id in basicUserData['id]
//                                     },
//                                   ),
//                                 ),
//                               Text(
//                                 comment.content,
//                                 style: Get.textTheme.bodyMedium,
//                                 overflow: TextOverflow.clip,
//                               ),

//                               // زر الرد وعرض الردود وشريط التحميل
//                               _buildBottomBarWidget(),
//                             ],
//                           ),
//                         ),

//                         // صندوق ادخال لكتابة الرد على تعليق معين
//                         Obx(
//                           () => isAddReply.value
//                               ? _showTextFieldToWriteReply(
//                                   userData: comment.basicUserData,
//                                   // onSendTap: (parentId, content) {
//                                   //   commentController.submitAddComment(parentId,
//                                   //       content);
//                                   //   showReplies.value = true;
//                                   //   isAddReply.value = false;
//                                   //   CommentController().refresh();
//                                   // },
//                                   onTapOutside: () {
//                                     printInfo(
//                                         info:
//                                             "Implement onTapOutSide Function");
//                                     isAddReply.value = !isAddReply.value;
//                                     focusedController.isAddCommentFocused
//                                         .value = !isAddReply.value;
//                                     isNextTapToHideField = true;
//                                   })
//                               : const SizedBox(),
//                         ),
//                         // الردود على التعليق
//                         Obx(
//                           () => showReplies.value
//                               ? _buildRepliesWidgets()
//                               : const SizedBox(),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         });
//   }

//   // زر الرد وعرض الردود وشريط التحميل
//   Widget _buildBottomBarWidget() {
//     Widget resultWidget;
//     if (status == CommentStatus.sending) {
//       resultWidget = SizedBox(
//         width: 25,
//         child: AppUtil.addProgressIndicator(20),
//       );
//     } else if (status == CommentStatus.faild) {
//       resultWidget = CustomTextAndIconButton(
//         text: Text(
//           "sending faild",
//           style: Get.textTheme.bodyMedium
//               ?.copyWith(color: Get.theme.colorScheme.error),
//         ),
//         onPressed: () {
//           if (resendFunction != null) {
//             int parentId = comment.parentPostId;
//             print("<<<<<<<<$parentId>>>>>>>>");
//             resendFunction!(parentId, comment.content,
//                 widgetCreatedAt: currentTimeWidget);
//           }
//           // else if (resendReplyFunction != null) {
//           //   int parentId = comment.parentCommentId;
//           //   print("<<<<????<<<<$parentId>>>>>>>>");

//           //   resendReplyFunction!(
//           //       parentId, comment.content, comment.basicUserData['id'],
//           //       widgetCreatedAt: currentTimeWidget);
//           // }
//         },
//         icon: Icon(Icons.refresh, color: Get.theme.colorScheme.error),
//       );
//     } else {
//       resultWidget = Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           // زر الرد
//           CustomTextAndIconButton(
//             text: Text("Reply", style: Get.textTheme.bodyMedium),
//             onPressed: () {
//               if (!isNextTapToHideField) {
//                 isAddReply.value = !isAddReply.value;
//                 focusedController.isAddCommentFocused.value = !isAddReply.value;
//                 isNextTapToHideField = false;
//               }
//               isNextTapToHideField = false;
//             },
//             icon: const Icon(Icons.reply_rounded),
//           ),
//           const SizedBox(width: 12),

//           // زر عرض الردود للتعليقات فقط ولا يظهر للردود على التعليقات
//           if (comment is Comment && comment.repliesCount > 0)
//             _buildShowRepliesButton(),
//         ],
//       );
//     }
//     return Container(
//       margin: const EdgeInsets.only(top: 5),
//       padding: const EdgeInsets.only(top: 3, right: 5, left: 5),
//       decoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: Colors.black26)),
//       ),
//       child: resultWidget,
//     );
//   }

//   /// دالة لعرض زر عرض الردود على التعليق
//   Widget _buildShowRepliesButton() {
//     return CustomTextAndIconAndCircleCounterButton(
//       text: Text("Show Replies ", style: Get.textTheme.bodyMedium),
//       onPressed: () {
//         showReplies.value = !showReplies.value;
//         if (showReplies.value) {
//           replyController.getCommentReplies(comment.id);
//         }
//       },
//       icon: const Icon(Icons.comment, size: 0),
//       count: comment.repliesCount.toString(),
//     );
//   }

//   Widget _buildRepliesWidgets() {
//     return replyController.repliesList.isNotEmpty ||
//             replyController.sendingReplies.isNotEmpty
//         ? Column(
//             children: [
//               for (int i = 0; i < replyController.repliesList.length; i++) ...{
//                 const Divider(),
//                 ReplyWidget2(
//                   reply: replyController.repliesList[i],
//                   // onReply: _showTextFieldToWriteReply,
//                   // resendFunction: ,
//                   // sendReplyFunction: ,
//                 ),
//                 // ReplyCardWidget(
//                 //   reply: replyController.repliesList[i],
//                 //   onReply: _showTextFieldToWriteReply,
//                 //   showReplyName:
//                 //       replyController.repliesList[i].replyToUser['id'] !=
//                 //           comment.basicUserData['id'],
//                 // )
//               },
//               for (int i = 0; i < replyController.sendingReplies.length; i++)
//                 ...{const Divider(), replyController.sendingReplies[i]}
//                     .toList(),
//             ],
//           )
//         : replyController.isRequestFinishWithoutData
//             ? Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(AppLocalization.thereIsSomethingError),
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: AppUtil.addProgressIndicator(20),
//               );
//   }

//   /// دالة لعرض صندوق الكتابة لكتابة رد على تعليق معين
//   Widget _showTextFieldToWriteReply({
//     required Map<String, dynamic> userData,
//     required Function() onTapOutside,
//     // required void Function(int parentId, String content) onSendTap,
//   }) {
//     // final node = FocusNode();
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: CommentInputWidget(
//         postId: comment.id,
//         basicUserData: userData,
//         hintText: "Write a reply",
//         textController:
//             textInputController, //replyController.replyTextEditingController,
//         autoFocuse: true,
//         onTapOutside: onTapOutside,
//         onSend: (String content) {
//           replyController.submitAddReply(
//               comment.id, comment.basicUserData['id'], content);
//           showReplies.value = true;
//           isAddReply.value = false;
//           // CommentController().refresh();
//         },
//       ),
//     );
//   }
// }

// class ReplyCardWidget extends StatelessWidget {
//   final Reply reply;
//   CommentStatus status;
//   // bool isFaildToSend;
//   final void Function(int, int, String, {DateTime widgetCreatedAt})?
//       resendFunction;
//   final Widget Function(
//       {required Map<String, dynamic> userData,
//       required Function() onTapOutside}) onReply;
//   final bool showReplyName;
//   DateTime currentTimeWidget = DateTime.now();
//   ReplyCardWidget({
//     super.key,
//     required this.reply,
//     this.status = CommentStatus.recieved,
//     // this.isFaildToSend = false,
//     this.resendFunction,
//     this.showReplyName = false,
//     DateTime? setCurrentTime,
//     required this.onReply,
//   }) {
//     if (setCurrentTime != null) {
//       currentTimeWidget = setCurrentTime;
//     }
//   }

//   /// متغير يتم استخدامه لعرض الردود الخاصة بالتعليق
//   final RxBool showReplies = false.obs;

//   /// متغير يتم استخدامه لعرض صندوق الكتابة عند الرغبة في الرد على تعليق محدد
//   final RxBool isAddReply = false.obs;

//   ///
//   bool isNextTapToHideField = false;

//   final CommentInputController focusedController = Get.find();

//   late ReplyController replyController;

//   // final int randInt = DateTime.now().millisecondsSinceEpoch;

//   // final RxList<Reply> replies = <Reply>[].obs;
//   @override
//   Widget build(BuildContext context) {
//     printInfo(info: ":::::::::::$currentTimeWidget");
//     // focusedController.isAddCommentFocused.value = true;
//     replyController = Get.put(ReplyController(), tag: reply.id.toString());
//     return GetBuilder(
//         init: CommentController(),
//         builder: (context) {
//           return Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // صورة المستخدم
//                   Container(
//                     // color: Colors.amber,
//                     margin: const EdgeInsets.symmetric(horizontal: 5),
//                     child: buildCircleCachedNetworkImage(
//                       imageUrl: reply.imageUrl,
//                       radius: 46,
//                     ),
//                   ),
//                   // اسم المستخد ونص التعليق وزر الرد
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(
//                             right: Get.locale?.languageCode == 'en' ? 5 : 0,
//                             left: Get.locale?.languageCode == 'ar' ? 5 : 0,
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 7, horizontal: 15),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 reply.basicUserData['name'].toString(),
//                                 style: Get.textTheme.titleMedium?.copyWith(
//                                   color: Colors.black,
//                                 ),
//                                 overflow: TextOverflow.clip,
//                               ),
//                               // const SizedBox(height: 2),
//                               if (showReplyName)
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       color: Get.theme.highlightColor,
//                                       borderRadius: BorderRadius.circular(15)),
//                                   child: CustomTextAndIconButton(
//                                     icon: const Icon(null, size: 0),
//                                     text: Text(
//                                       reply.replyToUser['name'].toString(),
//                                       style: Get.textTheme.bodyMedium?.copyWith(
//                                           color: Get.theme.primaryColor),
//                                     ),
//                                     onPressed: () {
//                                       // go to profile screen by use user id in basicUserData['id]
//                                     },
//                                   ),
//                                 ),
//                               Text(
//                                 reply.content,
//                                 style: Get.textTheme.bodyMedium,
//                                 overflow: TextOverflow.clip,
//                               ),

//                               // زر الرد وعرض الردود وشريط التحميل
//                               _buildBottomBarWidget(),
//                             ],
//                           ),
//                         ),

//                         // صندوق ادخال لكتابة الرد على تعليق معين
//                         Obx(
//                           () => isAddReply.value
//                               ? onReply(
//                                   userData: reply.basicUserData,
//                                   onTapOutside: () {
//                                     printInfo(
//                                         info:
//                                             "Implement onTapOutSide in reply Function");
//                                     isAddReply.value = !isAddReply.value;
//                                     focusedController.isAddCommentFocused
//                                         .value = !isAddReply.value;
//                                     isNextTapToHideField = true;
//                                   }) // _showTextFieldToWriteReply()
//                               : const SizedBox(),
//                         ),
//                         // الردود على التعليق
//                         // Obx(
//                         //   () => showReplies.value
//                         //       ? _buildRepliesWidgets()
//                         //       : const SizedBox(),
//                         // )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           );
//         });
//   }

//   // زر الرد وعرض الردود وشريط التحميل
//   Widget _buildBottomBarWidget() {
//     Widget resultWidget;
//     if (status == CommentStatus.sending) {
//       resultWidget = SizedBox(
//         width: 25,
//         child: AppUtil.addProgressIndicator(20),
//       );
//     } else if (status == CommentStatus.faild) {
//       resultWidget = CustomTextAndIconButton(
//         text: Text(
//           "sending faild",
//           style: Get.textTheme.bodyMedium
//               ?.copyWith(color: Get.theme.colorScheme.error),
//         ),
//         onPressed: () {
//           resendFunction!(reply.parentCommentId, 2, reply.content,
//               widgetCreatedAt: currentTimeWidget);
//         },
//         icon: Icon(Icons.refresh, color: Get.theme.colorScheme.error),
//       );
//     } else {
//       resultWidget = Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           // زر الرد
//           CustomTextAndIconButton(
//             text: Text("Reply", style: Get.textTheme.bodyMedium),
//             onPressed: () {
//               if (!isNextTapToHideField) {
//                 isAddReply.value = !isAddReply.value;
//                 focusedController.isAddCommentFocused.value = !isAddReply.value;
//                 isNextTapToHideField = false;
//               }
//               isNextTapToHideField = false;
//             },
//             icon: const Icon(Icons.reply_rounded),
//           ),
//           const SizedBox(width: 12),

//           // زر عرض الردود للتعليقات فقط ولا يظهر للردود على التعليقات
//           // if (comment is Comment && comment.repliesCount > 0)
//           //   _buildShowRepliesButton(),
//         ],
//       );
//     }
//     return Container(
//       margin: const EdgeInsets.only(top: 5),
//       padding: const EdgeInsets.only(top: 3, right: 5, left: 5),
//       decoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: Colors.black26)),
//       ),
//       child: resultWidget,
//     );
//   }

//   / دالة لعرض زر عرض الردود على التعليق
//   Widget _buildShowRepliesButton() {
//     return CustomTextAndIconAndCircleCounterButton(
//       text: Text("Show Replies ", style: Get.textTheme.bodyMedium),
//       onPressed: () {
//         showReplies.value = !showReplies.value;
//         if (showReplies.value) {
//           replyController.getCommentReplies(comment.id);
//         }
//       },
//       icon: const Icon(Icons.comment, size: 0),
//       count: comment.repliesCount.toString(),
//     );
//   }

//   Widget _buildRepliesWidgets() {
//     return replyController.repliesList.isNotEmpty ||
//             replyController.sendingReplies.isNotEmpty
//         ? Column(
//             children: [
//               for (int i = 0; i < replyController.repliesList.length; i++) ...{
//                 const Divider(),
//                 ReplyCardWidget(
//                   comment: replyController.repliesList[i],
//                 )
//               },
//               for (int i = 0; i < replyController.sendingReplies.length; i++)
//                 ...{const Divider(), replyController.sendingReplies[i]}
//                     .toList(),
//             ],
//           )
//         : replyController.isRequestFinishWithoutData
//             ? Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(AppLocalization.thereIsSomethingError),
//               )
//             : Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: AppUtil.addProgressIndicator(20),
//               );
//   }

//   / دالة لعرض صندوق الكتابة لكتابة رد على تعليق معين
//   Widget _showTextFieldToWriteReply() {
//     // final node = FocusNode();
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: CommentInputWidget(
//         postId: reply.id,
//         basicUserData: reply.basicUserData,
//         hintText: "Write a reply",
//         textController: replyController.replyTextEditingController,
//         autoFocuse: true,
//         onTapOutside: () {
//           printInfo(info: "Implement onTapOutSide Function");
//           isAddReply.value = !isAddReply.value;
//           focusedController.isAddCommentFocused.value = !isAddReply.value;
//           isNextTapToHideField = true;
//         },
//         onSend: (int commentId, String content){
//           // onReply();
//           replyController.submitAddReply(commentId, int.parse(reply.basicUserData['id'].toString()), content);
//           showReplies.value = true;
//           isAddReply.value = false;
//           CommentController().refresh();
//         }
//          ,
//       ),
//     );
//   }
// }