import 'dart:async';

import 'package:ashghal_app_frontend/features/chat/presentation/widgets/filled_outline_button.dart';
import 'package:ashghal_app_frontend/features/post/presentation/getx/post_controller.dart';
import 'package:ashghal_app_frontend/tester%20copy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyCustomWidget extends StatelessWidget {
  MyCustomWidget({super.key});

  // bool isPressed = true;

  // bool isPressed2 = true;
  RxBool isHighlighted = true.obs;
  RxBool isTapped = false.obs;
  RxBool isTapped2 = false.obs;
 
  @override
  Widget build(BuildContext context) {
    AnimationController _controller1 = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.4,
      upperBound: 1,
    );
    // ..repeat(
    //     reverse: true, // min: 0.5, max:1  // it's take it from upperBound
    //   );
    Animation<double>? _animation1 =
        CurvedAnimation(parent: _controller1, curve: Curves.linear);

    return SizedBox(
      height: 50,
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        padding: const EdgeInsets.only(left: 10, top: 7, bottom: 7),
        scrollDirection: Axis.horizontal,
        children: [
          // InkWell(
          //   highlightColor: Colors.transparent,
          //   splashColor: Colors.transparent,
          //   onTap: () {
          //     setState(() {
          //       isPressed = !isPressed;
          //     });
          //   },
          //   child: AnimatedContainer(
          //     height: 50,
          //     width: 50,
          //     curve: Curves.fastLinearToSlowEaseIn,
          //     duration: Duration(milliseconds: 300),
          //     decoration: BoxDecoration(
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(isPressed ? 0.2 : 0.0),
          //           blurRadius: 20,
          //           offset: Offset(5, 10),
          //         ),
          //       ],
          //       color:
          //           isPressed ? Colors.white : Colors.black.withOpacity(0.1),
          //       shape: BoxShape.circle,
          //     ),
          //     child: Icon(
          //       Icons.favorite,
          //       color: isPressed
          //           ? Colors.black.withOpacity(0.7)
          //           : Colors.black.withOpacity(0.5),
          //     ),
          //   ),
          // ),

          // for (PostFilters filter in PostFilters.values)
          //   SizedBox(
          //       height: 36,
          //       width: 100,
          //       child: CustomOutlineButton(
          //           onPress: () {}, text: filter.value, isFilled: true)),
          // Obx(() => Container(
          //       // duration: const Duration(milliseconds: 400),
          //       padding: const EdgeInsets.only(right: 10),
          //       margin: EdgeInsets.all(isTapped.value ? 10 : 0),
          //       child: CustomOutlineButton(
          //         onPress: () {},
          //         text: "origin",
          //         isFilled: true,
          //         onHighlightChanged: (value) {
          //           print("?????:highLight Changed: $value");
          //           isTapped.value = !isTapped.value;
          //           print(
          //               "??????????????::isTapped Changed: ${isTapped.value}");
          //         },
          //       ),
          //     )),
          // Obx(
          //   () => Container(
          //     // duration: const Duration(milliseconds: 400),
          //     padding: const EdgeInsets.only(right: 10),
          //     margin: EdgeInsets.all(isTapped2.value ? 10 : 0),
          //     child: CustomOutlineButton(
          //       onPress: () {},
          //       text: "origin2",
          //       isFilled: true,
          //       onHighlightChanged: (value) {
          //         print("?????:highLight Changed: $value");
          //         isTapped2.value = !isTapped2.value;
          //         print("??????????????::isTapped Changed: ${isTapped.value}");
          //       },
          //     ),
          //   ),
          // ),
          // SizedBox(width: 2),
          // Obx(
          //   () => Container(
          //     // duration: const Duration(milliseconds: 400),
          //     padding: const EdgeInsets.only(right: 10),
          //     margin: EdgeInsets.all(isTapped2.value ? 10 : 0),
          //     child: CustomOutlineButton(
          //       onPress: () {},
          //       text: "origin2",
          //       isFilled: true,
          //       onHighlightChanged: (value) {
          //         print("?????:highLight Changed: $value");
          //         isTapped2.value = !isTapped2.value;
          //         print("??????????????::isTapped Changed: ${isTapped.value}");
          //       },
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 36,
            width: 100,
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.fastLinearToSlowEaseIn,
                margin: EdgeInsets.all(isHighlighted.value ? 4 : 0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Get.theme.primaryColor),
                  ),
                  elevation: 2,
                  color: Get.theme.primaryColor,
                  onPressed: () {},
                  onHighlightChanged: (value) {
                    print(":::::::::::::::highLight Changed: $value");
                    isHighlighted.value = !isHighlighted.value;
                    // print(":::::::::::::::isTapped Changed: ${isTapped.value}");
                  },
                  child: Text(
                    "text2222",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      // fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onHighlightChanged: (value) async {
              // print(":::::::::::::::highLight Changed value: $value");
              // isTapped2.value = !isTapped2.value;
              // if (value){
              //   // await _controller1.forward();
              // } else{
              //   // await _controller1.reverse();
              //   // isTapped2.value = value;
              // }
              // isTapped2.value = !isTapped2.value;
              // if (!value) {
              //   print(":::::::::::::::highLight Changed: ${isTapped2.value}");
              //   await _controller1.reverse();
              //   isTapped2.value = false;
              // }
              // print(":::::::::::::::after: $value");
              // print(":::::::::::::::after: ${isTapped2.value}");
              // // await _controller1.reverse();
              // print(":::::::::::::::isTapped Changed: ${isTapped.value}");
            },
            onTapUp: (v) async {
              // if (ticker != null) {
              //   await ticker!.whenComplete(() async {
              //     print("<<<<<<<<<<<Completed>>>>>>>>>>>");
              //     await _controller1.reverse();
              //     print("<<<<<<<<<<${_controller1.status}>>>>>>>>>>");
              //   });
              //   // isTapped2.value = false;
              //   print("????????????????????????");
              // }
            },
            onLongPress: () {
              
            },
            onTap: () async {
              print("#########################3");
              // isTapped2.value = true;
              _controller1.forward();
              Future.delayed(Duration(milliseconds: 150), () {
                _controller1.reverse();
              });
              // isTapped2.value = !isTapped2.value;
              // print(":::::::::::::::highLight Changed: ${isTapped2.value}");
              // if (isTapped2.value){
              //   await _controller1.forward();
              // }
              //  print(":::::::::::::::after: ${isTapped2.value}");
              // await _controller1.reverse();
              //  else{
              //   await _controller1.reverse();
              // }
            },
            child: ScaleTransition(
              scale: _animation1,
              child: const FlutterLogo(size: 300),
            ),
          ),
          SizedBox(
            key: GlobalObjectKey(33),
            height: 36,
            width: 100,
            child: Obx(
              () => AnimatedContainer(
                key: GlobalObjectKey(3),
                duration: const Duration(milliseconds: 100),
                curve: Curves.fastLinearToSlowEaseIn,
                margin: EdgeInsets.all(isTapped.value ? 4 : 0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Get.theme.primaryColor),
                  ),
                  elevation: 2,
                  color: Get.theme.primaryColor,
                  onPressed: () {},
                  onHighlightChanged: (value) {
                    print(":::::::::::::::highLight Changed: $value");
                    isTapped.value = !isTapped.value;
                    // print(":::::::::::::::isTapped Changed: ${isTapped.value}");
                  },
                  child: Text(
                    "text2222",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      // fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Obx(
            () => InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {},
              onHighlightChanged: (value) {
                print(":::::::::::::::highLight Changed: $value");
                // setState(() {

                isHighlighted.value = !isHighlighted.value;
                // });
                // isTapped.value = !isTapped.value;
                // print(":::::::::::::::isTapped Changed: ${isTapped.value}");
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastLinearToSlowEaseIn,
                margin: EdgeInsets.all(isHighlighted.value ? 2 : 0),
                // padding: const EdgeInsets.all(15),
                height: isHighlighted.value ? 25 : 30,
                width: isHighlighted.value ? 120 : 130,
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  border: Border.all(color: Get.theme.primaryColor),
                  borderRadius: BorderRadius.circular(30),
                ),

                // child: Material(
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(30),
                //   side: BorderSide(color: Get.theme.primaryColor),
                // ),
                // elevation: isFilled ? 2 : 0,

                // color: isFilled ? Get.theme.primaryColor : null,
                // onPressed: onPress,
                // onHighlightChanged: (value) {
                //   print(":::::::::::::::highLight Changed: $value");
                //   isTapped.value = !isTapped.value;
                //   print(":::::::::::::::isTapped Changed: ${isTapped.value}");
                // },
                child: Text(
                  "text",
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    // fontSize: 15,
                  ),
                ),
                // ),
              ),
            ),
          ),

          Obx(
            () => InkWell(
              key: GlobalObjectKey("ink0"),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onHighlightChanged: (value) {
                // setState(() {
                isHighlighted.value = !isHighlighted.value;
                // });
              },
              onTap: () {
                // setState(() {
                //   isPressed2 = !isPressed2;
                // });
              },
              child: AnimatedContainer(
                key: GlobalObjectKey(0),
                margin: EdgeInsets.all(isHighlighted.value ? 0 : 2.5),
                height: isHighlighted.value ? 50 : 45,
                width: isHighlighted.value ? 50 : 45,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(5, 10),
                    ),
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: true //isPressed2
                    ? Icon(
                        Icons.favorite_border,
                        color: Colors.black.withOpacity(0.6),
                      )
                    : Icon(
                        Icons.favorite,
                        color: Colors.pink.withOpacity(1.0),
                      ),
              ),
            ),
          ),
          Obx(
            () => InkWell(
              key: GlobalObjectKey("ink1"),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onHighlightChanged: (value) {
                // setState(() {
                isHighlighted.value = !isHighlighted.value;
                // });
              },
              onTap: () {
                // setState(() {
                //   isPressed2 = !isPressed2;
                // });
              },
              child: AnimatedContainer(
                key: GlobalObjectKey(1),
                margin: EdgeInsets.all(isHighlighted.value ? 0 : 2.5),
                height: isHighlighted.value ? 50 : 45,
                width: isHighlighted.value ? 50 : 45,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(5, 10),
                    ),
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: true //isPressed2
                    ? Icon(
                        Icons.favorite_border,
                        color: Colors.black.withOpacity(0.6),
                      )
                    : Icon(
                        Icons.favorite,
                        color: Colors.pink.withOpacity(1.0),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
