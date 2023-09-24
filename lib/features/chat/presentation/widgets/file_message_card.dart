import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/Chat/inserting_message_controller.dart';

class FileMessageCard extends StatelessWidget {
  // final InsertingMessageController insertingMessageController;

  const FileMessageCard({
    super.key,
    // required this.insertingMessageController,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Container(
          width: MediaQuery.sizeOf(context).width / 1.7,
          height: MediaQuery.sizeOf(context).height / 2.5,
          // width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    /// TODO: Show image in full screen
                  },
                  child: Card(
                    color: Colors.grey,
                    margin: const EdgeInsets.all(3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/images/11111.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      bottom: 30,
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    child: Text(
                      "hey there hey there hey there hey there hey there hey there hey there",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        // color: style.textColor,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '${DateTime.now().hour}:${DateTime.now().minute}   '),
                        // !true
                        //     ? const SizedBox(width: 5)
                        //     : MessageStatusIcon(message: message)
                      ],
                    ),
                  )
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Flexible(
              //         child: Text(
              //           "hey there hey there hey there hey there hey there hey there hey there",
              //           overflow: TextOverflow.visible,
              //           softWrap: true,
              //         ),
              //       ),
              //       SizedBox(
              //         width: 5,
              //       ),
              //       Text('${DateTime.now().hour}:${DateTime.now().minute}   '),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
