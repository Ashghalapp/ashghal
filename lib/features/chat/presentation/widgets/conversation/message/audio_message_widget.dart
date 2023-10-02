import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:flutter/material.dart';

class AudioMessageWidget extends StatelessWidget {
  const AudioMessageWidget({
    super.key,
    required this.message,
    required this.isMine,
  });

  final LocalMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
      width: MediaQuery.sizeOf(context).width * 0.50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isMine
            ? ChatStyle.ownMessageColor
            : ChatStyle.ownMessageColor.withOpacity(0.3),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.play_arrow,
            size: 25,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.black,
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   width: 5,
          // ),
          const Text(
            "1:50",
            style: TextStyle(),
          ),
        ],
      ),
    );
  }
}
