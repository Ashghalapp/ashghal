// يمثل نص عرض المزيد كزر قابل للنقر widget دالة لارجاع
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/localization/app_localization.dart';
import '../../../../../core/widget/app_buttons.dart';

class PostCommentsFunctionWidgets {
  static Widget buildShowMoreTextButton({
    required int moreCounts,
    required void Function() onTap,
    required bool isReply,
  }) {
    return Container(
      padding: EdgeInsets.only(
        top: 7,
        right: Get.locale?.languageCode == 'ar' ? 50 : 0,
        left: Get.locale?.languageCode == 'en' ? 50 : 0,
        bottom: 10,
      ),
      alignment: AlignmentDirectional.centerStart,
      child: CustomTextAndIconButton(
        text: Text(
          "${AppLocalization.view.tr} $moreCounts ${isReply ? AppLocalization.moreReplies.tr : AppLocalization.moreComments.tr}",
          style: Get.textTheme.bodyLarge,
        ),
        onPressed: onTap,
        icon: const Icon(null, size: 0),
      ),
    );
  }
}
