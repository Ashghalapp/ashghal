import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/core/widget/scale_down_transition.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// صنوق ادخال نص التعليق والذي يظهر بجانبه زر الارسال وصورة المستخدم الذي سيقوم بالتعليق
// ويتم ارسال الدالة التي ستقوم بالعمل اثناء الضغط على زر ارسال
class CommentInputWidget extends StatelessWidget {
  final int parentId;
  final String? imageUrl;
  final String hintText;
  final void Function() onTapOutside;
  final bool autoFocuse;
  final FocusNode? node;
  final Map<String, dynamic>? basicUserData;
  final Function(String content) onSend;
  final void Function()? onPrefixIconPressed;

  CommentInputWidget({
    super.key,
    required this.parentId,
    this.imageUrl,
    required this.hintText,
    required this.textController,
    required this.onTapOutside,
    this.autoFocuse = false,
    this.node,
    this.basicUserData,
    required this.onSend,
    this.onPrefixIconPressed,
  });

  // final CommentInputController con = Get.find();
  final TextEditingController textController;
  final CommentController commentController = Get.find();
  RxBool enabledSendButton = false.obs;

  static GlobalKey formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.grey),
    );
    textController.addListener(() {
      // printInfo(info: textController.text);
      enabledSendButton.value = textController.text.trim().isNotEmpty;
    });

    // if (basicUserData != null) {
    //   textController.text = "${basicUserData!['name']}";
    // }
    // textController.selection= TextSelection.fromPosition(TextPosition(offset: 10, affinity: ));
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (basicUserData != null)
            Container(
              margin: EdgeInsets.only(
                right: Get.locale?.languageCode == 'ar' ? 10 : 0,
                left: Get.locale?.languageCode == 'en' ? 10 : 0,
              ),
              // color: Colors.red,
              child: Text("Reply to ${basicUserData!['name']}"),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Form(
              key: formKey,
              child: TextFormField(
                autofocus: autoFocuse,
                onTapOutside: (event) {
                  onTapOutside();
                },
                focusNode: node,
                controller: textController,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  enabledBorder: fieldBorder,
                  focusedBorder: fieldBorder,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  hintText: hintText,
                  // prefix: basicUserData != null
                  //     ? Container(
                  //         decoration: BoxDecoration(
                  //             color: Get.theme.highlightColor,
                  //             borderRadius: BorderRadius.circular(15)),
                  //         child: CustomTextAndIconButton(
                  //           icon: const Icon(null, size: 0),
                  //           text: Text(
                  //             basicUserData!['name'].toString(),
                  //             style: Get.textTheme.bodyMedium
                  //                 ?.copyWith(color: Get.theme.primaryColor),
                  //           ),
                  //           onPressed: () {
                  //             // go to profile screen by use user id in basicUserData['id]
                  //           },
                  //         ),
                  //       )
                  //     : null,
                  prefixIcon: ScaleDownTransitionWidget(
                    child: IconButton(
                      // highlightColor: Colors.transparent,
                      icon: const Icon(Icons.image_outlined),
                      onPressed: onPrefixIconPressed,
                    ),
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 4.0),
                    width: 70.0,
                    child: ScaleDownTransitionWidget(
                      child: IconButton(
                        // highlightColor: Colors.transparent,
                        onPressed: () {
                          if (enabledSendButton.value) {
                            if (SharedPref.getCurrentUserBasicData() != null) {
                              onSend(
                                // postId,
                                textController.text,
                              );
                            } else {
                              Get.focusScope?.unfocus();
                              DialogUtil.showSignInDialog();
                            }
                          }
                        },
                        icon: Obx(
                          () => enabledSendButton.value
                              ? const Icon(Icons.send, size: 25.0)
                              : const Icon(Icons.send,
                                  size: 25.0, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
            
                // onChanged: (value) {
                //   printError();
                //   enabled.value = value.trim().isNotEmpty;
                // },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
