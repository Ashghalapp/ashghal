import 'package:flutter/material.dart';
import 'package:get/get.dart';

// لبناء صف يحتوي على عدد المتابعين والمتابعات والاعجابات widget
class StatisticsWidget extends StatelessWidget {
  final int followers;
  final int followings;
  final int likes;
  const StatisticsWidget({
    super.key,
    required this.followers,
    required this.followings,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatisticColumn(text: "followers", count: followers),
        _buildStatisticColumn(text: "following", count: followings),
        _buildStatisticColumn(text: "likes", count: likes),
      ],
    );
  }

  Column _buildStatisticColumn({required String text, required int count}) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Get.textTheme.titleMedium?.copyWith(
              color: Get.theme.primaryColor, fontWeight: FontWeight.bold),
        ),
        Text(text, style: Get.textTheme.bodyMedium),
      ],
    );
  }
}
