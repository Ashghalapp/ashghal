import 'package:ashghal_app_frontend/config/app_routes.dart';
import 'package:ashghal_app_frontend/core/helper/shared_preference.dart';
import 'package:ashghal_app_frontend/features/account/Screen/more_acccount_details_screen.dart';
import 'package:ashghal_app_frontend/features/account/widgets/header_widgets/provider_data_widget.dart';
import 'package:ashghal_app_frontend/features/account/widgets/header_widgets/statistics_widget.dart';
import 'package:ashghal_app_frontend/features/account/widgets/header_widgets/user_image_with_back_shape_widget.dart';
import 'package:ashghal_app_frontend/features/auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Settings_Screen.dart';

class ProfileAccountHeaderWidget extends StatelessWidget {
  final User user;
  const ProfileAccountHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // صورة المستخدم مع الشكل الخلفي للصورة
        UserImageWithBackShapeWidget(
          imageUrl: user.imageUrl,
          aboveWidget: [
            // details icon button
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () =>
                    Get.to(() => MoreAccountDetailsScreen(user: user)),
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
                  Get.to(() => SettingScreen(user: user));
                },
                icon: const Icon(Icons.settings),
              ),
            ),
          ],
        ),

        // name widget
        Center(
          child: Text(
            user.name,
            style: Get.textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 10),

        // the statistics widget
        StatisticsWidget(
          followers: user.followersUsers.length,
          followings: user.followingUsers.length,
          likes: 37,
        ),
        const SizedBox(height: 10),

        // provider data of user widget
        if (user.provider != null) ProviderDataWidget(provider: user.provider!),
      ],
    );
  }
}
