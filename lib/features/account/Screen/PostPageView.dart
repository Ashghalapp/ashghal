import 'package:flutter/material.dart';

import '../../../config/app_images.dart';

class PostPageView extends StatelessWidget {
  const PostPageView({super.key});

  Widget buildPostWidget() {
    return Image.asset(
      AppImages.avatar,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(2),
      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //   crossAxisCount: 1,
      //   crossAxisSpacing: 10,
      //   mainAxisSpacing: 2,
      // ),
      itemCount: 40,
      itemBuilder: (context, index) => buildPostWidget(),
    );
  }
}
