import 'package:ashghal_app_frontend/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:nb_utils/nb_utils.dart';

class AppScaffold extends StatelessWidget {
  final String? appBarTitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  final Widget child;
  final Color? scaffoldBackgroundColor;
  final Widget? bottomNavigationBar;

  const AppScaffold({super.key, this.appBarTitle, required this.child, this.actions, this.scaffoldBackgroundColor, this.bottomNavigationBar, this.onBack});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (onBack != null) {
          onBack?.call();
        } else {
        Get.back();
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle?? "", style:Theme.of(context).textTheme.titleMedium),
          elevation: 1,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.icongray),
            onPressed: () {
              if (onBack != null) {
                onBack?.call();
              } else {
                Get.back();
              }
            },
          ),
          actions: actions,
        ),
        backgroundColor: scaffoldBackgroundColor ,
        body: child,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
