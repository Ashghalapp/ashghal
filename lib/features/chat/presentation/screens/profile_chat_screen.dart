import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            const CircleAvatar(
              radius: 65,
              // backgroundImage: ),
            ),
            SizedBox(height: 20),
            Text(
              user.username,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              user.phoneNumber,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Last seen ${lastSeenMessage(user.lastSeen)} ago",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                iconWithText(icon: Icons.call, text: 'Call'),
                iconWithText(icon: Icons.video_call, text: 'Video'),
                iconWithText(icon: Icons.search, text: 'Search'),
              ],
            ),
            SizedBox(height: 20),
            const ListTile(
              title: Text('Hey there! I am using WhatsApp'),
              subtitle: Text(
                '17th February',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Mute notification'),
              leading: Icon(Icons.notifications),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            const ListTile(
              title: Text('Custom notification'),
              leading: Icon(Icons.music_note),
            ),
            ListTile(
              title: Text('Media visibility'),
              leading: Icon(Icons.photo),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 20),
            const ListTile(
              title: Text('Encryption'),
              subtitle: Text(
                'Messages and calls are end-to-end encrypted, Tap to verify.',
              ),
              leading: Icon(Icons.lock),
            ),
            const ListTile(
              title: Text('Disappearing messages'),
              subtitle: Text('Off'),
              leading: Icon(Icons.timer),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.group,
                color: Colors.green,
              ),
              title: Text('Create group with ${user.username}'),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.block,
                color: Colors.red,
              ),
              title: Text(
                'Block ${user.username}',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.thumb_down,
                color: Colors.red,
              ),
              title: Text(
                'Report ${user.username}',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget iconWithText({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.green,
          ),
          SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class UserModel {
  final String username;
  final String phoneNumber;
  final String lastSeen;
  final String profileImageUrl;

  UserModel({
    required this.username,
    required this.phoneNumber,
    required this.lastSeen,
    required this.profileImageUrl,
  });
}

String lastSeenMessage(String lastSeen) {
  // Implement your logic to calculate the last seen message here
  return "2 hours";
}
