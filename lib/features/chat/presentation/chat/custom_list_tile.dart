import 'package:ashghal_app_frontend/config/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subTitle;
  final String? time;
  final Widget? titleButton;
  final int numOfMessageNotSeen;
  final VoidCallback onTap;
  final VoidCallback? onLeadingTap;

  const CustomListTile({
    super.key,
    this.leading,
    required this.title,
    this.subTitle,
    this.time,
    this.numOfMessageNotSeen = 0,
    this.titleButton,
    required this.onTap,
    this.onLeadingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            // color: Theme.of(context).inputDecorationTheme.fillColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1, // Adjust the width as needed
            ),
          ),
      child: ListTile(
        // style: Get.theme.listTileTheme.style,
        onTap: onTap,
        leading: leading ??
            InkWell(
              onTap: onLeadingTap,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Image.asset(AppImages.avatar),
              ),
            ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                //style: context.headlineSmall,
                style: Get.theme.textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (time != null)
              Text(
                time!,
                style: numOfMessageNotSeen>0
                    ?Get.theme.textTheme.labelMedium!
                    : Get.textTheme.bodyMedium,
              ),
            if (titleButton != null)
              SizedBox(
                height: 40,
                child: titleButton!,
              ),
          ],
        ),
        subtitle: subTitle != null
            ? Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(
                  children: [
                    //Icon(Icons.done_all,size: 20,),
                    Expanded(
                      child: Text(
                        subTitle!,
                        style:Get.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if ( numOfMessageNotSeen >0 )
                      CircleAvatar(
                        minRadius: 12,
                        backgroundColor: Get.theme.colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            numOfMessageNotSeen.toString(),
                            style: Get.textTheme.bodySmall,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : null,
      ),
    );
  }
}
