import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/account/more_acccount_details_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/provider_data_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/statistics_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/user_image_with_back_shape_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../screens/settings/settings_screen.dart';

class ProfileAccountHeaderWidget extends StatefulWidget {
  User user;
  ProfileAccountHeaderWidget({super.key, required this.user});

  @override
  State<ProfileAccountHeaderWidget> createState() => _ProfileAccountHeaderWidgetState();
}

class _ProfileAccountHeaderWidgetState extends State<ProfileAccountHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // صورة المستخدم مع الشكل الخلفي للصورة
        UserImageWithBackShapeWidget(
          imageUrl: widget.user.imageUrl,
          aboveWidget: [
            // details icon button
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () =>
                    Get.to(() => MoreAccountDetailsScreen(user: widget.user)),
                icon: const Icon(Icons.info),
              ),
            ),

            // settings icon button
            Container(
              alignment: AlignmentDirectional.topEnd,
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  // SharedPref.setUserLoggedIn(false);
                  // Get.offAllNamed(AppRoutes.logIn);
                  Get.to(() => SettingScreen(user: widget.user))?.then((value) {
                    print("<<<<<<<<<<<<<<<Back to profile screen>>>>>>>>>>>>>>>");
                    setState(() {
                      final currentUserData= SharedPref.getCurrentUserData();
                      if (currentUserData != null) {
                        widget.user = SharedPref.getCurrentUserData()!;
                      }
                    });
                  });
                },
                icon: const Icon(Icons.settings),
              ),
            ),
          ],
        ),

        // name widget
        Center(
          child: Text(
            widget.user.name,
            style: Get.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 10),

        // the statistics widget
        StatisticsWidget(
          userId: widget.user.id,
          followers: widget.user.followersUsers.length,
          followings: widget.user.followingUsers.length,
          likes: 37,
        ),

        // follow and chat buttons
        const SizedBox(height: 10),
        // _buildFollowingAndChatButtonsWidget(isSending: false, isFollowed: true),

        // provider data of user widget
        if (widget.user.provider != null) ProviderDataWidget(provider: widget.user.provider!),
      ],
    );
  }
}


// Widget _buildFollowingAndChatButtonsWidget(
//     {bool isSending = false, bool isFollowed = false}) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Container(
//         height: 36,
//         padding: const EdgeInsets.symmetric(horizontal: 5),
//         // width: Get.width / 3,
//         child: ElevatedButton.icon(
//           onPressed: () {},
//           icon: isSending
//               ? AppUtil.addProgressIndicator(
//                   18, Get.textTheme.displayLarge?.color)
//               : isFollowed
//                   ? Image.asset("assets/icons/person_added.png", width: 20, height: 20)
//                   : Icon(
//                       Icons.person_add_alt_1,
//                       color: Get.textTheme.displayLarge?.color,
//                       size: 20,
//                     ),
//           label: Text(
//             isFollowed? "Followed" : "Follow",
//             style: Get.textTheme.displayLarge,
//           ),
//           style: ElevatedButton.styleFrom(elevation: 3),
//         ),
//       ),
//       const SizedBox(width: 10),
//       Material(
//         borderRadius: BorderRadius.circular(8),
//         elevation: 3,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: CustomTextAndIconButton(
//             height: 36,
//             icon: SvgPicture.asset(
//               AppIcons.chatBorder,
//               height: 18,
//             ),
//             onPressed: () {},
//             text: Text(
//               "Chat",
//               style: Get.textTheme.displayLarge
//                   ?.copyWith(color: Get.textTheme.bodyMedium?.color),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
