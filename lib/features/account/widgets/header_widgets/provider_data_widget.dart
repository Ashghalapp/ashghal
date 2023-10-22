import 'package:ashghal_app_frontend/features/auth/domain/entities/provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderDataWidget extends StatelessWidget {
  final Provider provider;
  const ProviderDataWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.only(right: 4, left: 4, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(AppLocalization.providerData, style: Get.textTheme.titleMedium),
            Text(
              provider.jobName!,
              style: Get.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (provider.jobDesc != null)
              Text(
                provider.jobDesc!,
                style: Get.textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
