import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/core/widget/circle_cached_networkimage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserImageWithBackShapeWidget extends StatelessWidget {
  final String? imageUrl;
  final List<Widget>? aboveWidget;
  const UserImageWithBackShapeWidget({
    super.key,
    required this.imageUrl,
    this.aboveWidget,
  });

  @override
  Widget build(BuildContext context) {
    // final currentUserId = SharedPref.getCurrentUserData()['id'];
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        // stack تحجيم ارتفاع الـ
        // const SizedBox(height: 250),

        // الشكل الخلفي للصورة
        ClipPath(
          clipper: WaveClipper(),
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.asset(
              "assets/images/chatbg12.jpg",
              fit: BoxFit.fitWidth,
            ),
          ),
        ),

        // صورة المستخدم
        Container(
          padding: const EdgeInsets.only(top: 115, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleCachedNetworkImageWidget(imageUrl: imageUrl, radius: 150),
            ],
          ),
        ),

        if (aboveWidget != null)
          ...aboveWidget!,

        // if (userData.id != currentUserId)
        //   Container(
        //     alignment: AlignmentDirectional.topStart,
        //     padding: const EdgeInsets.all(8.0),
        //     child: IconButton(
        //         onPressed: () => Get.back(),
        //         icon: const Icon(Icons.arrow_back)),
        //   ),

        // Container(
        //   alignment: userData.id == currentUserId
        //       ? AlignmentDirectional.topStart
        //       : AlignmentDirectional.topEnd,
        //   padding: const EdgeInsets.all(8.0),
        //   child: IconButton(onPressed: () {}, icon: const Icon(Icons.details)),
        // ),

        // // ايقونة الاعدادات
        // if (userData.id == currentUserId)
        //   Container(
        //     // padding: EdgeInsets.only(top: Get.mediaQuery.viewPadding.top),
        //     alignment: AlignmentDirectional.topEnd,
        //     padding: const EdgeInsets.all(8.0),
        //     child: IconButton(
        //       onPressed: () {
        //         SharedPref.setUserLoggedIn(false);
        //         Get.offAllNamed(AppRoutes.logIn);
        //         // Get.to(() => const Setting());
        //       },
        //       icon: const Icon(Icons.settings),
        //       style: IconButton.styleFrom(
        //         elevation: 20,
        //         // shadowColor: ,
        //         // backgroundColor: Colors.green,
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    debugPrint(size.width.toString());
    debugPrint(size.height.toString());

    double width = size.width;
    double height = size.height;

    var path = Path();
    path.lineTo(0, height); // start path with this if you are
    path.lineTo(width / 8, height); // start path with this if you are

    var firstStart = Offset(width / 5, height);
    var firstEnd = Offset(width / 4 + width / 20, height - height / 6);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var middleStart = Offset(width / 2, height / 2 - 30);
    var middleEnd = Offset(width / 2 + width / 5, height - height / 6);
    path.quadraticBezierTo(
        middleStart.dx, middleStart.dy, middleEnd.dx, middleEnd.dy);

    var secondStart = Offset(width - width / 5, height);
    var secondEnd = Offset(width - width / 8, height);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(width, height); //end with this path if you
    path.lineTo(width, 0); //end with this path if you
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
