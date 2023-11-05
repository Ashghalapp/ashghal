import 'dart:io';

import 'package:ashghal_app_frontend/core/app_functions.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/widget/app_buttons.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/getx/account/specific_user_account_controller.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/account/specific_user_account_screen.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/comment_input_controller.dart';
import 'package:ashghal_app_frontend/core/widget/circle_cached_networkimage.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/comment_input_widget.dart';
import 'package:ashghal_app_frontend/features/post/presentation/widget/popup_menu_button_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../app_library/app_data_types.dart';
import '../display_image_on_tap.dart';
import '../display_sending_image_widget.dart';
import '../../../../../core/widget/cashed_image_widget.dart';

// ignore: must_be_immutable
abstract class CommentReplyWidgetAbstract extends StatelessWidget {
  final int userId;
  final String userName;
  final String? userImageUrl;
  final String content;
  final String? imageUrl;
  final DateTime time;
  final CommentStatus status;
  DateTime currentTimeWidget = DateTime.now();

  CommentReplyWidgetAbstract({
    super.key,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.content,
    required this.imageUrl,
    required this.time,
    // required this.replyController,
    this.status = CommentStatus.recieved,
    DateTime? setCurrentTime,
  }) {
    if (setCurrentTime != null) {
      currentTimeWidget = setCurrentTime;
    }
  }

  /// متغير يتم استخدامه لعرض الردود الخاصة بالتعليق
  final RxBool showReplies = false.obs;

  /// متغير يتم استخدامه لعرض صندوق الكتابة عند الرغبة في الرد على تعليق محدد
  final RxBool isAddReply = false.obs;

  ///
  bool isNextTapToHideField = false;

  final CommentInputController focusedController = Get.find();

  // late ReplyController replyController;

  /// متحكم يتم استخدامه في صندوق ادخال الرد لكل تعليق حتى يتم الاحتفاظ بالقيمة
  final TextEditingController textInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // printInfo(
    // info:
    // ":::comment user id: $userId :::and current user data are: $currentUserData");

    // getMentionUserData();
    // print("<<<<<<<<<<<<<<<<<<<<<<$userImageUrl>>>>>>>>>>>>>>>>>>>>>>");
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المستخدم
            Container(
              // color: Colors.amber,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: CircleCachedNetworkImageWidget(
                imageUrl: userImageUrl,
                radius: 46,
              ),
            ),
            // اسم المستخد ونص التعليق وزر الرد وعرذ الردود وشريط الانتظار
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Get.theme.cardColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleWidget(),

                        if (imageUrl != null) _buildImageWidget(),
                        _buildContentWidget(),

                        // زر الرد وعرض الردود وشريط التحميل
                        _buildBottomBarWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // صندوق ادخال رد
        Padding(
          padding: EdgeInsets.only(
            right: Get.locale?.languageCode == 'ar' ? 40 : 0,
            left: Get.locale?.languageCode == 'en' ? 40 : 0,
          ),
          child: // صندوق ادخال لكتابة الرد على تعليق معين
              Obx(
            () => isAddReply.value ? onReplyTap() : const SizedBox(),
          ),
        ),

        // الردود على التعليق
        Padding(
          padding: EdgeInsets.only(
            right: Get.locale?.languageCode == 'ar' ? 40 : 0,
            left: Get.locale?.languageCode == 'en' ? 40 : 0,
          ),
          child: Obx(
            () => showReplies.value
                ? buildRepliesWidgets() ?? const SizedBox()
                : const SizedBox(),
          ),
        )
      ],
    );
  }

  Widget _buildTitleWidget() {
    // Map<String, dynamic> currentUserData = SharedPref.getCurrentUserData() ?? {};
    Map<String, dynamic>? currentUserData =
        SharedPref.getCurrentUserBasicData();
    return SizedBox(
      height: 25,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            userName,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.fade,
          ),
          if (userId == currentUserData?['id'])
            PopupMenuButtonWidget(
              onSelected: _onPopupItemSelected,
              items: OperationsOnCommentPopupMenuValues.values
                  .asNameMap()
                  .keys
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildContentWidget() {
    Map<String, dynamic>? userData = getMentionUserData();
    printError(info: ">>>>> mentionUserData: $userData");
    return RichText(
      overflow: TextOverflow.clip,
      text: TextSpan(
        children: [
          // comment mention
          if (userData != null)
            TextSpan(
              text: "${userData['name'] ?? "unknown".tr}  ",
              style: Get.textTheme.bodyMedium
                  ?.copyWith(color: Get.theme.primaryColor),
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    Get.to(SpecificUserAccountScreen(userId: userData['id'])),
            ),

          // comment content
          TextSpan(
            text: content,
            style: Get.textTheme.bodyMedium,
            // overflow: TextOverflow.clip,
          ),

          // comment time
          TextSpan(
            text: "\n${DateFormat('yyyy/MM/dd h:mm a').format(time)}",
            style: Get.textTheme.bodySmall
                ?.copyWith(color: Get.textTheme.titleSmall?.color),
          )
        ],
        // ),
      ),
      // ],
    );
  }

  Widget _buildImageWidget() {
    if (status == CommentStatus.sending || status == CommentStatus.faild) {
      return Container(
        constraints: const BoxConstraints(maxHeight: 250),
        child: Image.file(
          File(imageUrl!),
          fit: BoxFit.fill,
        ),
      );
    }
    // else url= imageUrl;
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      child: CashedNetworkImageWidget(
        imageUrl: AppFunctions.handleImagesToEmulator(imageUrl!),
        onTap: () => Get.to(() => ImagePage(imageUrl: imageUrl!)),
        errorAssetImagePath: "assets/images/unKnown.jpg",
        fit: BoxFit.fill,
      ),
    );
  }

  void _onPopupItemSelected(String value) {
    if (value == OperationsOnCommentPopupMenuValues.edit.name) {
      onEdit();
    } else if (value == OperationsOnCommentPopupMenuValues.delete.name) {
      onDelete();
    } else if (value == OperationsOnCommentPopupMenuValues.report.name) {
      onReport();
    }
  }

  // زر الرد وعرض الردود وشريط التحميل
  Widget _buildBottomBarWidget() {
    Widget resultWidget;
    if (status == CommentStatus.sending) {
      resultWidget = SizedBox(
        width: 25,
        child: AppUtil.addProgressIndicator(20),
      );
    } else if (status == CommentStatus.faild) {
      resultWidget = CustomTextAndIconButton(
        text: Text(
          "sending faild",
          style: Get.textTheme.bodyMedium
              ?.copyWith(color: Get.theme.colorScheme.error),
        ),
        onPressed: onSendingFaildTap,
        icon: Icon(Icons.refresh, color: Get.theme.colorScheme.error),
      );
    } else {
      resultWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // زر الرد
          CustomTextAndIconButton(
            text: Text("Reply", style: Get.textTheme.bodyMedium),
            onPressed: () {
              if (!isNextTapToHideField) {
                isAddReply.value = !isAddReply.value;
                focusedController.isAddCommentFocused.value = !isAddReply.value;
                isNextTapToHideField = false;
              }
              isNextTapToHideField = false;
            },
            icon: const Icon(Icons.reply_rounded),
          ),
          const SizedBox(width: 12),

          // زر عرض الردود للتعليقات فقط ولا يظهر للردود على التعليقات
          // if (comment.repliesCount > 0)
          buildShowRepliesButton() ?? const SizedBox(),
        ],
      );
    }
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.only(right: 5, left: 5),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black26)),
      ),
      child: resultWidget,
    );
  }

  /// دالة لعرض صندوق الكتابة لكتابة رد على تعليق معين
  Widget showTextFieldToWriteReply({
    required int parentId,
    required Map<String, dynamic> userData,
    required Function() onTapOutside,
    required Function(String content) onSend,
    required Function(String content, String imagePath) onImageIconTap,
    // required void Function(int parentId, String content) onSendTap,
  }) {
    // final node = FocusNode();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CommentInputWidget(
        parentId: parentId,
        basicUserData: userData,
        hintText: "Write a reply",
        textController: textInputController,
        autoFocuse: true,
        onTapOutside: onTapOutside,
        onSend: (String content) {
          onSend(content);
          showReplies.value = true;
          isAddReply.value = false;
          focusedController.isAddCommentFocused.value = true;
          textInputController.clear();
        },
        onPrefixIconPressed: () async {
          final imagePicker = ImagePicker();
          XFile? pickedFile =
              await imagePicker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            Get.to(
              () => DisplaySendingImageWidget(
                imageUrl: pickedFile.path,
                onSend: (content, imagePath) {
                  onImageIconTap(content, imagePath);
                  showReplies.value = true;
                },
              ),
            );
          }
        },
      ),
    );
  }

  /// function to use when the user click on the reply button
  /// you must use the showTextFieldToWriteReply function to be
  /// a returned from this function
  Widget onReplyTap();

  void onSendingFaildTap();

  Widget? buildShowRepliesButton() {
    return null;
  }

  Widget? buildRepliesWidgets() {
    return null;
  }

  /// function to use when delete the comment or reply
  void onDelete() {}

  /// function to use when edit the comment or reply
  void onEdit() {}

  /// function to use when report the comment or reply
  void onReport() {}

  /// function to get user data to mention it on reply
  Map<String, dynamic>? getMentionUserData() {
    return null;
  }
}
