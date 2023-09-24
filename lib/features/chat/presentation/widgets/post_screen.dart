import 'package:flutter/material.dart';

class Post {
  final String username;
  final String text;
  final String imageUrl;

  Post({
    required this.username,
    required this.text,
    required this.imageUrl,
  });
}

class poopst extends StatelessWidget {
  final List<Post> posts = [
    Post(
      username: "John Doe",
      text: "This is my first post on Flutterbook!",
      imageUrl: "assets/images/11111.jpg",
    ),
    Post(
      username: "Jane Smith",
      text: "Having a great time learning Flutter.",
      imageUrl: "assets/images/11111.jpg",
    ),
    Post(
      username: "Jane Smith",
      text: "Having a great time learning Flutter.",
      imageUrl: "assets/images/11111.jpg",
    ),
    Post(
      username: "Jane Smith",
      text: "Having a great time learning Flutter.",
      imageUrl: "assets/images/11111.jpg",
    ),
    // Add more posts here
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutterbook"),
        ),
        body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return buildPostCard(posts[index]);
          },
        ),
      ),
    );
  }

  Widget buildPostCard(Post post) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/11111.jpg",
              ),
            ),
            title: Text(post.username),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(post.text),
          ),
          post.imageUrl.isNotEmpty
              ? Image.asset(
                  post.imageUrl,
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                )
              : SizedBox.shrink(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: () {
                      // Handle liking the post
                    },
                  ),
                  Text("Like"),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      // Handle commenting on the post
                    },
                  ),
                  Text("Comment"),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      // Handle favoriting the post
                    },
                  ),
                  Text("Favorite"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
