import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostShimmer extends StatelessWidget {
  /// من البوستات المطلوب عرضها shimmer متغير يستقبل عدد 
  final int shimmerNumber;
  final double width;
  const PostShimmer({super.key, required this.width, this.shimmerNumber = 2});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (int i = 0; i< shimmerNumber; i++)
        buildPostShimmer()
      ],
    );
  }

  Widget buildPostShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.5 , vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBarShimmer(),
            const SizedBox(height: 15),
            _buildContentShimmer(),
            const SizedBox(height: 12),
            _buildContainerShimmer(double.infinity, 200, null),
            const Divider(color: Colors.black, thickness: 0.3),
            _buildBottomBarShimmer(),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarShimmer() {
    return ListTile(
      leading: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: const CircleAvatar(radius: 25),
      ),
      title: _buildContainerShimmer(70, 20, null),
      // subtitle: _buildContainerShimmer(100, 15, null),
      trailing: const Icon(Icons.more_vert),
    );
  }

  // final double width= Get.mediaQuery.size.width;

  Widget _buildContentShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContainerShimmer(width - 40 - 150, 20, null),
        const SizedBox(height: 7),
        _buildContainerShimmer(width - 40 - 40, 16, null),
      ],
    );
  }

  Widget _buildBottomBarShimmer() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.comment),
            Text(" Comment"),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.favorite),
            Text(" Favorite"),
          ],
        ),
      ],
    );
  }

  Widget _buildContainerShimmer(double width, double height, Widget? child) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
