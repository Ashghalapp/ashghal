import 'package:ashghal_app_frontend/core/widget/app_scaffold_widget.dart';
import 'package:flutter/material.dart';

import 'custom_list_tile.dart';

class ChatsScreen extends StatelessWidget {
  ChatsScreen({super.key});
  final List<CustomListTileData> dataList = [
    CustomListTileData(
      title: 'John Doe',
      subTitle: 'Hello, how are you?',
      time: '2:30 PM',
      numOfMessageNotSeen: 2,
    ),
    CustomListTileData(
      title: 'Alice Smith',
      subTitle: 'Hi there!',
      time: '3:45 PM',
      numOfMessageNotSeen: 0,
    ),
    CustomListTileData(
      title: 'Bob Johnson',
      subTitle: 'Good morning!',
      time: '8:15 AM',
      numOfMessageNotSeen: 5,
    ),
    CustomListTileData(
      title: 'Eve Anderson',
      subTitle: 'Hey, how\'s it going?',
      time: '10:00 AM',
      numOfMessageNotSeen: 0,
    ),
    CustomListTileData(
      title: 'Michael Brown',
      subTitle: 'See you later!',
      time: '6:20 PM',
      numOfMessageNotSeen: 1,
    ),
    CustomListTileData(
      title: 'Olivia Wilson',
      subTitle: 'What\'s up?',
      time: '1:10 PM',
      numOfMessageNotSeen: 0,
    ),
    CustomListTileData(
      title: 'Sophia Lee',
      subTitle: 'I\'ll be there soon.',
      time: '4:50 PM',
      numOfMessageNotSeen: 3,
    ),
    CustomListTileData(
      title: 'William Davis',
      subTitle: 'Can we meet tomorrow?',
      time: '9:30 AM',
      numOfMessageNotSeen: 0,
    ),
    CustomListTileData(
      title: 'Liam Martinez',
      subTitle: 'Sure, let\'s do it!',
      time: '11:05 AM',
      numOfMessageNotSeen: 0,
    ),
    CustomListTileData(
      title: 'Ava Johnson',
      subTitle: 'I have exciting news!',
      time: '5:55 PM',
      numOfMessageNotSeen: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        thickness: 1,
        height: 1,
      ),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final data = dataList[index];
        return CustomListTile(
          title: data.title,
          subTitle: data.subTitle,
          time: data.time,
          numOfMessageNotSeen: data.numOfMessageNotSeen,
          onTap: () {
            // Handle onTap event
            print('Tapped on the custom list tile: ${data.title}');
          },
          onLeadingTap: () {
            // Handle onTap event on leading (avatar)
            print('Tapped on the leading avatar: ${data.title}');
          },
        );
      },
    );
  }
}

class CustomListTileData {
  final String title;
  final String? subTitle;
  final String? time;
  final int numOfMessageNotSeen;

  CustomListTileData({
    required this.title,
    this.subTitle,
    this.time,
    this.numOfMessageNotSeen = 0,
  });
}
