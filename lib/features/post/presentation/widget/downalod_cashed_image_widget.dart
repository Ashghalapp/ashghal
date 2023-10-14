import 'dart:io';

import 'package:ashghal_app_frontend/core_api/network_info/network_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class DownloadCashedImage extends StatelessWidget {
  final String imageUrl;
  final String errorAssetImagePath;
  final void Function()? onTap;
  final Widget Function()? onWaiting;
  final BoxFit? fit;
  const DownloadCashedImage({
    super.key,
    required this.imageUrl,
    required this.errorAssetImagePath,
    this.fit = BoxFit.fill,
    this.onTap,
    this.onWaiting,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: loadImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // print("<<<<<<<<<<<Waiting image>>>>>>>>>>>");
          return onWaiting != null ? onWaiting!() : getShimmerForImage();
        } else if (snapshot.hasError || snapshot.data == null) {
          debugPrint('Invalid Image URL: ${snapshot.data}');
          // return Text("HEEEEEEEEEEERe");
          return Image.asset(errorAssetImagePath);
        } else {
          try {
            // debugPrint('Invalid Image but inside get: ${snapshot.data}');
            // Display the cached image.
            // return snapshot.data != null
            return InkWell(
              onTap: onTap,
              child: FadeInImage(
                image: FileImage(File(snapshot.data!)),
                placeholder:
                    const AssetImage("assets/images/post-placeholder.png"),
                placeholderFit: fit,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(errorAssetImagePath, fit: BoxFit.fitWidth);
                },
                fit: fit,
              ),
            );
            // : Image.asset(errorAssetImagePath);
          } catch (e) {
            print("::::::::::::::: Catch Errors in cashe images");
            return Image.asset(errorAssetImagePath);
          }
        }
      },
    );
  }

  Widget getShimmerForImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Future<bool> filterValidImages(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        print(":::::::::::::::::::valid image::::::::::::::::::::::::");
        return true;
      }
      print(":::::::::::::::::in valid image:::::::::::::::::");
      return false;
    } catch (e) {
      print(":::::::::::::::::in valid image in catch:::::::::::::::::");
      return false;
    }
  }

  Future<String?> loadImage(String imageUrl) async {
    try {
      // print("<<<<<<<<<<<<<<<before get cashed image>>>>>>>>>>>>>>>");
      DefaultCacheManager cacheManager = DefaultCacheManager();
      FileInfo? fileInfo = await cacheManager.getFileFromCache(imageUrl);
      // print("<<<<<<<<<<<<<<<after get cashed image>>>>>>>>>>>>>>>");

      if (fileInfo == null && await NetworkInfoImpl().isConnected) {
        if (!(await filterValidImages(imageUrl))) return null;
        // print("<<<<<<<<<<<<<<<inside null image in cashe>>>>>>>>>>>>>>>");
        // Image is not cached, download and store it locally.
        await cacheManager.downloadFile(imageUrl);
        fileInfo = await cacheManager.getFileFromCache(imageUrl);
      }
      return fileInfo?.file.path;
    } catch (e) {
      print("::::::::: Error: $e");
      // AppUtil.showMessage(AppLocalization.thereIsSomethingError, Colors.green);
    }
    return null;
  }
}
