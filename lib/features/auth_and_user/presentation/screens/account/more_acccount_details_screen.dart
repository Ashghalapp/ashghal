import 'package:ashghal_app_frontend/app_library/public_entities/address.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/provider_data_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/statistics_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/presentation/widgets/account/header_widgets/user_image_with_back_shape_widget.dart';
import 'package:ashghal_app_frontend/features/auth_and_user/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoreAccountDetailsScreen extends StatelessWidget {
  final User user;
  const MoreAccountDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المستخدم مع الشكل الخلفي للصورة
            UserImageWithBackShapeWidget(
              imageUrl: user.imageUrl,
              aboveWidget: [
                // back icon button
                Container(
                  alignment: AlignmentDirectional.topStart,
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back)),
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
          
            // statistics widget
            StatisticsWidget(
              userId: user.id,
              followers: user.followersUsers.length,
              followings: user.followingUsers.length,
              posts: user.postsCount,
            ),
            const SizedBox(height: 10),
          
            // provider data of user widget
            if (user.provider != null) ProviderDataWidget(provider: user.provider!),
          
            const SizedBox(height: 10),
          
            // personal details
            _buildGroupOfLabeledData(
              groupTitle: AppLocalization.personalInfo,
              labeledData: [
                {'label': AppLocalization.name, 'data': user.name},
                {'label': AppLocalization.gender, 'data': user.gender.name},
                {
                  'label': AppLocalization.birthDate,
                  'data': DateFormat('yyyy MMMM dd').format(user.birthDate)
                },
                {
                  'label':AppLocalization.joinAt,
                  'data': DateFormat('yyyy MMMM dd').format(user.createdAt)
                },
              ],
            ),
            const SizedBox(height: 10),
          
            // address details
            if (user.address != null) _buildAddressDataWidget(user.address!),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDataWidget(Address address) {
    return _buildGroupOfLabeledData(
      groupTitle: AppLocalization.address,
      labeledData: [
        if (address.city != null) {'label': AppLocalization.city, 'data': address.city!},
        if (address.district != null)
          {'label': AppLocalization.street, 'data': address.district!},
        if (address.desc != null)
          {'label':AppLocalization.description, 'data': address.desc!},
      ],
    );
  }
}

Widget _buildGroupOfLabeledData({
  required String groupTitle,
  required List<Map<String, String>> labeledData,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTitleWidget(groupTitle),
      for (Map<String, String> data in labeledData)
        _buildLabelAndDataText(data['label']!, data['data']!),
    ],
  );
}

Widget _buildTitleWidget(String title) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
    margin: const EdgeInsets.only(bottom: 5),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 0,
          color: Get.textTheme.bodyMedium?.color ?? Colors.black,
        ),
        top: BorderSide(
          width: 0,
          color: Get.textTheme.bodyMedium?.color ?? Colors.black,
        ),
      ),
      color: Get.theme.inputDecorationTheme.fillColor,
    ),
    child: Text(title, style: Get.textTheme.titleMedium),
  );
}

Widget _buildLabelAndDataText(String label, String data) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: data,
            style: Get.textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}
