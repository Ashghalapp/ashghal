import 'package:any_link_preview/any_link_preview.dart';
import 'package:ashghal_app_frontend/app_library/app_data_types.dart';
import 'package:ashghal_app_frontend/config/chat_theme.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/chat_media_links_screen_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/components.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/file_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMediaLinksDocsScreen extends StatefulWidget {
  const ChatMediaLinksDocsScreen({super.key, required this.userName});
  final String userName;

  @override
  // ignore: library_private_types_in_public_api
  _ChatMediaLinksDocsScreenState createState() =>
      _ChatMediaLinksDocsScreenState();
}

class _ChatMediaLinksDocsScreenState extends State<ChatMediaLinksDocsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final ChatMediaLinksScreenController _screenController =
      Get.put(ChatMediaLinksScreenController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Get.isPlatformDarkMode ? ChatTheme.dark : ChatTheme.light,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(widget.userName),
          bottom: TabBar(
            unselectedLabelColor: Get.isPlatformDarkMode ? null : Colors.black,
            labelColor: Get.isPlatformDarkMode ? null : Colors.blue,
            indicatorColor: Get.isPlatformDarkMode ? null : Colors.blue,
            controller: _tabController,
            tabs: [
              Tab(text: AppLocalization.chatMedia.tr),
              Tab(text: AppLocalization.docs.tr),
              Tab(text: AppLocalization.links.tr),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            MediaTab(
              mediaByDate: _screenController.mediaList,
            ),
            DocsTab(
              docsByDate: _screenController.docsList,
            ),
            LinksTab(
              linksByDate: _screenController.linksList,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}

class MediaTab extends StatelessWidget {
  final Map<String, List<LocalMultimedia>> mediaByDate;

  const MediaTab({super.key, required this.mediaByDate});

  @override
  Widget build(BuildContext context) {
    final dates = mediaByDate.keys.toList();
    return dates.isNotEmpty
        ? GroupListviewWidget<LocalMultimedia>(
            itemsListByDate: mediaByDate,
            itemBuilder: (context, item) {
              return MediaItemWidget(media: item);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
          )
        : Center(
            child: Text(AppLocalization.noMediaFound.tr),
          );
  }
}

class MediaItemWidget extends StatelessWidget {
  final LocalMultimedia media;

  MultimediaTypes get type {
    if (media.type == MultimediaTypes.video.value.toLowerCase()) {
      return MultimediaTypes.video;
    }
    return MultimediaTypes.image;
  }

  const MediaItemWidget({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return ImageVideoWithPlaceholderWidget(
      path: media.path!,
      type: type,
      onPlayVideoPressed: () =>
          Get.find<MultimediaController>().playVideo(media),
    );
  }
}

class DocsTab extends StatelessWidget {
  final Map<String, List<LocalMultimedia>> docsByDate;
  const DocsTab({super.key, required this.docsByDate});

  @override
  Widget build(BuildContext context) {
    final dates = docsByDate.keys.toList();
    return dates.isNotEmpty
        ? GroupListviewWidget<LocalMultimedia>(
            itemsListByDate: docsByDate,
            itemBuilder: (_, item) {
              return DocsItemWidget(docMedia: item);
            },
          )
        : Center(
            child: Text(AppLocalization.noDocsFound.tr),
          );
  }
}

class DocsItemWidget extends StatelessWidget {
  final LocalMultimedia docMedia;

  const DocsItemWidget({super.key, required this.docMedia});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: InkWell(
          onTap: () async {},
          onLongPress: () {},
          child: ReadyFileMessageWidget(
            multimedia: docMedia,
            leftBorderRaduis: 15,
          ),
        ),
      ),
    );
  }
}

class LinksTab extends StatelessWidget {
  final Map<String, List<LocalMessage>> linksByDate;
  const LinksTab({super.key, required this.linksByDate});

  @override
  Widget build(BuildContext context) {
    final dates = linksByDate.keys.toList();
    return dates.isNotEmpty
        ? GroupListviewWidget<LocalMessage>(
            itemsListByDate: linksByDate,
            itemBuilder: (_, item) {
              return LinksItemWidget(linkMessage: item);
            },
          )
        : Center(
            child: Text(AppLocalization.noLinksFound.tr),
          );
  }
}

class LinksItemWidget extends StatelessWidget {
  final LocalMessage linkMessage;

  const LinksItemWidget({super.key, required this.linkMessage});
  String? get link => AppUtil.getURLInText(linkMessage.body!);
  @override
  Widget build(BuildContext context) {
    return link == null
        ? const SizedBox.shrink()
        : Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () async {
                  await launchURL(link!);
                },
                onLongPress: () => showLinkOptionsBottomSheet(context, link!),
                child: Column(
                  children: [
                    AnyLinkPreview(
                      previewHeight: 100,
                      link: link!,
                      displayDirection: UIDirection.uiDirectionHorizontal,
                      showMultimedia: true,
                      bodyMaxLines: 6,
                      bodyTextOverflow: TextOverflow.ellipsis,
                      titleStyle: TextStyle(
                        color: Get.isPlatformDarkMode
                            ? Colors.white70
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      bodyStyle: TextStyle(
                        color: Get.isPlatformDarkMode ? null : Colors.black87,
                      ),
                      errorWidget: const SizedBox.shrink(),
                      cache: const Duration(days: 7),
                      backgroundColor: Get.isPlatformDarkMode
                          ? Colors.black38
                          : const Color.fromARGB(31, 100, 88, 88),
                      borderRadius: 15,
                      removeElevation: true,
                      onTap: () async {
                        await launchURL(link!);
                      }, // This disables tap event
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              link ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                decorationColor: Colors.blue,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 20,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

class GroupListviewWidget<T> extends StatelessWidget {
  const GroupListviewWidget({
    super.key,
    required this.itemsListByDate,
    required this.itemBuilder,
    this.gridDelegate,
  });
  final Widget? Function(BuildContext context, T item) itemBuilder;
  final Map<String, List<T>> itemsListByDate;
  final SliverGridDelegate? gridDelegate;

  @override
  Widget build(BuildContext context) {
    List<String> dates = itemsListByDate.keys.toList();
    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final listItems = itemsListByDate[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              child: Text(
                date,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            gridDelegate != null
                ? GridView.builder(
                    gridDelegate: gridDelegate!,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listItems.length,
                    itemBuilder: (context, itemIndex) {
                      return itemBuilder(context, listItems[itemIndex]);
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listItems.length,
                    itemBuilder: (context, itemIndex) {
                      return itemBuilder(context, listItems[itemIndex]);
                    },
                  ),
          ],
        );
      },
    );
  }
}
