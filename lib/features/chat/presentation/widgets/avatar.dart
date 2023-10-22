import 'dart:io';
import 'dart:math';

import 'package:ashghal_app_frontend/core/widget/user_status_Widgets.dart';
import 'package:ashghal_app_frontend/core_api/services/image_checker_cacher.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/style2.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final bool isOnline;

  const Avatar({
    this.width = 60.0,
    this.height = 60.0,
    required this.url,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: background,
        boxShadow: softShadows,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(url),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarWithImageOrLetter extends StatelessWidget {
  final String? imageUrl;
  final String userName;
  final double raduis;
  final Color borderColor;
  final int boderThickness;

  const AvatarWithImageOrLetter({
    super.key,
    this.imageUrl,
    required this.userName,
    this.raduis = 25,
    this.borderColor = Colors.blue,
    this.boderThickness = 2,
  });

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
        random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
  }

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? _buildLetterCircleAvatar()
        : FutureBuilder<String?>(
            future: ImageCheckerAndCacher().loadImage(imageUrl!),
            builder: (_, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return _buildImageCirculAvatar(snapshot.data!);
              }
              return _buildLetterCircleAvatar();
            },
          );
  }

  Container _buildImageCirculAvatar(String path) {
    return Container(
      // padding: EdgeInsets.all(2),
      height: raduis * 2,
      width: raduis * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raduis),
        // color: borderColor,
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
        // backgroundColor: _getRandomColor(),
        backgroundColor: Colors.grey,
        child: Text(
          userName.substring(0, 1).toUpperCase(),
          // "1",
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // User Image
        InkWell(
          onTap: () {
            //TODO: Open the user image in a full screen
          },
          child: AvatarWithImageOrLetter(
            userName: userName,
            imageUrl: imageUrl,
            raduis: raduis,
            borderColor: borderColor,
            boderThickness: boderThickness,
          ),
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
