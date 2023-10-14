import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CommentInputController extends GetxController {
  RxBool isAddReplyFocused = false.obs;
  RxBool isAddCommentFocused = true.obs;

  TextEditingController textController = TextEditingController();
}
