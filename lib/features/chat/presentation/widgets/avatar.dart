import 'dart:io';
import 'dart:math';

import 'package:ashghal_app_frontend/core/widget/user_status_Widgets.dart';
import 'package:ashghal_app_frontend/core_api/services/image_checker_cacher.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/full_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class Avatar extends StatelessWidget {
//   final double width;
//   final double height;
//   final String url;
//   final bool isOnline;

//   const Avatar({
//     this.width = 60.0,
//     this.height = 60.0,
//     required this.url,
//     this.isOnline = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         color: background,
//         boxShadow: softShadows,
//         shape: BoxShape.circle,
//       ),
//       child: Stack(
//         children: <Widget>[
//           Container(
//             margin: const EdgeInsets.all(2.0),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: NetworkImage(url),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Animations {
//   // slide animation from right to left
//   // we need animation of type double
//   static fromLeft(Animation<double> _animation,
//       Animation<double> _secondaryAnimation, Widget _child) {
//     return SlideTransition(
//       child: _child,
//       position: Tween<Offset>(end: Offset.zero, begin: Offset(1.0, 0.0))
//           .animate(_animation),
//     );
//   }

//   // slide animation from left to right
//   static fromRight(Animation<double> _animation,
//       Animation<double> _secondaryAnimation, Widget _child) {
//     return SlideTransition(
//       child: _child,
//       position: Tween<Offset>(end: Offset.zero, begin: Offset(-1.0, 0.0))
//           .animate(_animation),
//     );
//   }

//   // slide animation from top to bottom
//   static fromTop(Animation<double> _animation,
//       Animation<double> _secondaryAnimation, Widget _child) {
//     return SlideTransition(
//       child: _child,
//       position: Tween<Offset>(end: Offset.zero, begin: Offset(0.0, -1.0))
//           .animate(_animation),
//     );
//   }

//   // slide animation from bottom to top
//   static fromBottom(Animation<double> _animation,
//       Animation<double> _secondaryAnimation, Widget _child) {
//     return SlideTransition(
//       child: _child,
//       position: Tween<Offset>(end: Offset.zero, begin: Offset(0.0, 1.0))
//           .animate(_animation),
//     );
//   }

//   // slide animation with grow effect
//   static grow(Animation<double> _animation,
//       Animation<double> _secondaryAnimation, Widget _child) {
//     return ScaleTransition(
//       scale: Tween<double>(end: 1.0, begin: 0.0).animate(CurvedAnimation(
//           parent: _animation,
//           curve: Interval(0.00, 0.50, curve: Curves.linear))),
//       child: _child,
//     );
//   }

//   // slide animation with shrink effect
//   static shrink(Animation<double> _animation,
//       Animation<double> _secondaryAnimation, Widget _child) {
//     return ScaleTransition(
//       child: _child,
//       scale: Tween<double>(end: 1.0, begin: 1.2).animate(CurvedAnimation(
//           parent: _animation,
//           curve: Interval(0.50, 1.00, curve: Curves.linear))),
//     );
//   }
// }

// _openDialogBoxGrow(BuildContext context) {
//   return showGeneralDialog(
//     context: context,
//     barrierLabel: '',
//     // this is mandatory so we are passing it empty string
//     barrierDismissible: true,
//     transitionDuration: Duration(milliseconds: 300),
//     transitionBuilder: (context, _animation, _secondaryAnimation, _child) {
//       return Animations.shrink(_animation, _secondaryAnimation, _child);
//     },
//     pageBuilder: (_animation, _secondaryAnimation, _child) {
//       return AlertDialog(
//         title: Text('Title'),
//         content: Container(
//           margin: EdgeInsets.only(top: 10),
//           child: Text('Animation example Grow.'),
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Okay'),
//           ),
//         ],
//       );
//     },
//   );
// }

// ignore: must_be_immutable
class AvatarWithImageOrLetter extends StatelessWidget {
  final int userId;
  final String? imageUrl;
  final String userName;
  final double raduis;
  final Color borderColor;
  final int boderThickness;
  final bool showImageOnPress;

  AvatarWithImageOrLetter({
    super.key,
    required this.userId,
    this.imageUrl,
    required this.userName,
    this.raduis = 25,
    this.borderColor = Colors.blue,
    this.boderThickness = 2,
    this.showImageOnPress = false,
  });

  final ChatScreenController _screenController = Get.find();

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
        random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
  }

  final GlobalKey avatarKey = GlobalKey();

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: avatarKey,
      onTap: () {
        if (showImageOnPress) {
          final RenderBox renderBox =
              avatarKey.currentContext?.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          _buildAnimatedDialog(context, position, imagePath);
        } else {
          _screenController.openUserProfileImageInFullScreen(
              imagePath, userName, userId);
        }
      },
      child: imageUrl == null
          ? _buildLetterCircleAvatar()
          : FutureBuilder<String?>(
              future: ImageCheckerAndCacher().loadImage(imageUrl!),
              builder: (_, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  imagePath = snapshot.data!;
                  return _buildImageCirculAvatar(snapshot.data!);
                }
                return _buildLetterCircleAvatar();
              },
            ),
    );
  }

  _buildAnimatedDialog(
      BuildContext context, Offset position, String? imagePath) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "asd",
      context: context,
      pageBuilder: (ctx, animation, animation2) {
        final initialPosition = Offset(
          position.dx / MediaQuery.of(context).size.width,
          position.dy / MediaQuery.of(context).size.height,
        );

        return SlideTransition(
          position: Tween<Offset>(
            end: const Offset(0, -0.15),
            begin: initialPosition - const Offset(0.5, 0.5),
          ).animate(animation),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.1, end: 1.0).animate(animation),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.1, end: 1.0).animate(animation),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                insetPadding: const EdgeInsets.symmetric(horizontal: 80),
                contentPadding: const EdgeInsets.all(0),
                actionsPadding: const EdgeInsets.all(0),
                content: SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            color: imagePath == null ? Colors.grey : null,
                            height: 200,
                            width: Get.size.width - 160,
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => FullImageScreen(
                                    imagePath: imagePath,
                                    title: userName,
                                    userId: userId,
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Hero(
                                  tag: userId,
                                  child: imagePath == null
                                      ? Center(child: _buildLetterText(50))
                                      : Image.file(
                                          File(imagePath),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          _buildDialogTitle(),
                        ],
                      ),
                      _buildDialogActions(imagePath)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Container _buildDialogTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: const BoxDecoration(
        color: Colors.black45,
      ),
      child: Row(
        children: [
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Card _buildDialogActions(String? imagePath) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      elevation: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                LocalConversation? conversation =
                    _screenController.getConversationWithUserId(userId);
                if (conversation != null) {
                  Get.back();
                  _screenController.goToConversationScreen(conversation);
                }
              },
              icon: Icon(
                Icons.chat,
                color: Get.theme.primaryColor,
              )),
          IconButton(
            onPressed: () {
              _screenController.openUserProfileImageInFullScreen(
                  imagePath, userName, userId);
            },
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: Get.theme.primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              LocalConversation? conversation =
                  _screenController.getConversationWithUserId(userId);
              if (conversation != null) {
                Get.back();

                _screenController.goToChatProfileScreen(conversation);
              }
            },
            icon: Icon(
              Icons.info_outline,
              color: Get.theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildImageCirculAvatar(String path) {
    return Container(
      height: raduis * 2,
      width: raduis * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raduis),
        border: Border.all(
          color: borderColor,
          width: boderThickness.toDouble(),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(raduis - boderThickness),
        ),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  CircleAvatar _buildLetterCircleAvatar() {
    return CircleAvatar(
      backgroundColor: borderColor,
      radius: raduis,
      child: CircleAvatar(
        radius: raduis - boderThickness,
        backgroundColor: Colors.grey,
        child: _buildLetterText(),
      ),
    );
  }

  Text _buildLetterText([double fontSize = 20]) {
    return Text(
      userName.substring(0, 1).toUpperCase(),
      // "1",
      style: TextStyle(color: Colors.white, fontSize: fontSize),
    );
  }
}

class UserImageAvatarWithStatusWidget extends StatelessWidget {
  const UserImageAvatarWithStatusWidget({
    super.key,
    required this.userId,
    required this.userName,
    this.raduis = 25,
    this.borderColor = Colors.transparent,
    this.boderThickness = 2,
    this.imageUrl,
    this.statusRadius = 9,
    this.statusActiveColor = Colors.blue,
    this.statusUnactiveColor = Colors.grey,
    this.statusBorderColor = Colors.white,
    this.showImageDirectly = false,
  });

  final int userId;
  final String userName;
  final double raduis;
  final Color borderColor;
  final int boderThickness;
  final String? imageUrl;
  final double statusRadius;
  final Color statusActiveColor;
  final Color statusUnactiveColor;
  final Color statusBorderColor;
  final bool showImageDirectly;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // User Image
        AvatarWithImageOrLetter(
          userId: userId,
          userName: userName,
          imageUrl: imageUrl,
          raduis: raduis,
          borderColor: borderColor,
          boderThickness: boderThickness,
          showImageOnPress: !showImageDirectly,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: UserStatusAvatar(
            userId: userId,
            radius: statusRadius,
            activeColor: statusActiveColor,
            unactiveColor: statusUnactiveColor,
            borderColor: statusBorderColor,
          ),
        )
      ],
    );
  }
}
