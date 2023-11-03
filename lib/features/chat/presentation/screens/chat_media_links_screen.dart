import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMediaLinksDocsScreen extends StatefulWidget {
  @override
  _ChatMediaLinksDocsScreenState createState() =>
      _ChatMediaLinksDocsScreenState();
}

class _ChatMediaLinksDocsScreenState extends State<ChatMediaLinksDocsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  ConversationController conversationController = Get.find();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Media, Links & Docs"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Media"),
            Tab(text: "Links"),
            Tab(text: "Docs"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Media Tab
          MediaTab(
              mediaList: conversationController.messages
                  .where((m) => m.multimedia != null)
                  .map((e) => e.multimedia!)
                  .toList()),

          // Links Tab
          LinksTab(),

          // Docs Tab
          DocsTab(),
        ],
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
  final List<LocalMultimedia> mediaList;

  MediaTab({required this.mediaList});

  @override
  Widget build(BuildContext context) {
    // Organize the media by date
    Map<String, List<LocalMultimedia>> mediaByDate = {};

    for (var media in mediaList) {
      final date = DateTime(
              media.createdAt.year, media.createdAt.month, media.createdAt.day)
          .toString();

      if (!mediaByDate.containsKey(date)) {
        mediaByDate[date] = [];
      }

      mediaByDate[date]!.add(media);
    }

    // Create a list of dates
    final dates = mediaByDate.keys.toList();

    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final mediaItems = mediaByDate[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(date),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Adjust as needed
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: mediaItems.length,
              itemBuilder: (context, itemIndex) {
                final media = mediaItems[itemIndex];

                return MediaItemWidget(media: media);
              },
            ),
          ],
        );
      },
    );
  }
}

class MediaItemWidget extends StatelessWidget {
  final LocalMultimedia media;

  MediaItemWidget({required this.media});

  @override
  Widget build(BuildContext context) {
    // Implement the UI for displaying media items here
    return Container(
      padding: const EdgeInsets.all(8.0),
      // height: 50,
      // width: 50,
      color: Colors.amber,
      // child: Image.network(media.url), // You can adjust this based on your media type
    );
  }
}

class LinksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your Links tab content here
    return Center(
      child: Text("Links Tab Content"),
    );
  }
}

class DocsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement your Docs tab content here
    return Center(
      child: Text("Docs Tab Content"),
    );
  }
}

void main() => runApp(MaterialApp(home: ChatMediaLinksDocsScreen()));
