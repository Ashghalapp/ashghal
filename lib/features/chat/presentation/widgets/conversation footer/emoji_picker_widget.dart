import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class EmojiPickerWidget extends StatelessWidget {
  final TextEditingController textEditingController;

  const EmojiPickerWidget({
    super.key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      onEmojiSelected: (Category? category, Emoji emoji) {
        textEditingController.text += emoji.emoji;
      },
      onBackspacePressed: () {},
      textEditingController: textEditingController,
      config: Config(
        columns: 7,
        emojiSizeMax: 32 *
            (foundation.defaultTargetPlatform == TargetPlatform.iOS
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
        noRecents: Text(
          AppLocalization.noRecents,
          style: const TextStyle(fontSize: 20, color: Colors.black26),
          textAlign: TextAlign.center,
        ), // Needs to be const Widget
        loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
        tabIndicatorAnimDuration: kTabScrollDuration,
        categoryIcons: const CategoryIcons(),
        buttonMode: ButtonMode.MATERIAL,
      ),
    );
  }
}
