import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/widget/circle_cached_networkimage.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/screens/account/specific_user_account_screen.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserCardWidget extends StatelessWidget {
  final User user;
  const UserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          print("<<<<<<<<<<<<<<<<<<<<<<<<<<user card clicked>>>>>>>>>>>>>>>>>>>>>>>>>>");
          print("<<<<<<<<<<<<user: ${user.id} ${user.name}>>>>>>>");
          Get.to(() => SpecificUserAccountScreen(userId: user.id), preventDuplicates: false);
        },
        child: ListTile(
          leading: CircleCachedNetworkImageWidget(
            imageUrl: user.imageUrl,
            radius: 46,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 14,
            color: AppColors.iconColor,
          ),
          title: Container(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user.provider == null)
                  Text(user.name, style: Get.textTheme.titleMedium),
                if (user.provider != null)
                  getProviderTitle(user.name),

                if (user.provider != null)
                  Text(
                    user.provider!.jobName!,
                    style: Get.textTheme.bodyMedium,
                  ),
                Text(
                  "${AppLocalization.joinAt} ${DateFormat('yyyy MM dd').format(user.createdAt)}",
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.textTheme.bodyMedium?.color,
                  ),
                ),
                // const SizedBox(height: 5),
                Divider(color: Get.theme.dividerColor, thickness: 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getProviderTitle(String userName) {
    return Row(
      children: [
        Text(userName, style: Get.textTheme.titleMedium),
        Expanded(
          child: Center(
            child: Card(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  "Provider",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.bodySmall
                      ?.copyWith(color: Get.textTheme.titleMedium?.color),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
