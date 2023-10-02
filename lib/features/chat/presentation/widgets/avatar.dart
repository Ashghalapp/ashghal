import 'dart:math';

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
    this.borderColor = Colors.transparent,
    this.boderThickness = 2,
  });

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
        random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
  }

  @override
  Widget build(BuildContext context) {
    return
        // imageUrl == null
        //     ?
        CircleAvatar(
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
    // :
    // CachedNetworkImage(
    //     imageUrl: imageUrl ?? "",
    //     placeholder: (context, url) => const CircularProgressIndicator(),
    //     errorWidget: (context, url, error) => CircleAvatar(
    //       backgroundColor: _getRandomColor(),
    //       child: Text(
    //         userName.substring(0, 1),
    //         // "1",
    //         style: const TextStyle(color: Colors.white, fontSize: 20),
    //       ),
    //     ),
    //     imageBuilder: (context, imageProvider) => CircleAvatar(
    //       backgroundImage: imageProvider,
    //     ),
    //   );
  }
}
