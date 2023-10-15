import 'dart:io';

import 'package:ashghal_app_frontend/features/chat/presentation/getx/inserting_message_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/screens/chat_screen.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/widgets/conversation/message/image_message_widget.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:video_player/video_player.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  // InsertingMessageController _controller =
  //     Get.put(InsertingMessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [],
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class VideoPlayerWithDownloader extends StatefulWidget {
  final String videoUrl;
  VideoPlayerWithDownloader({required this.videoUrl});

  @override
  _VideoPlayerWithDownloaderState createState() =>
      _VideoPlayerWithDownloaderState();
}

class _VideoPlayerWithDownloaderState extends State<VideoPlayerWithDownloader> {
  late VideoPlayerController _controller;
  bool _downloading = false;
  CancelToken _cancelToken = CancelToken();
  late Dio _dio;
  String _filePath = 'path_to_save_video.mp4';

  @override
  void initState() {
    super.initState();
    _dio = Dio();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _startDownload() async {
    setState(() {
      _downloading = true;
    });

    try {
      final response = await _dio.get(
        widget.videoUrl,
        options: Options(
          responseType: ResponseType.stream,
          followRedirects: false,
        ),
        cancelToken: _cancelToken,
      );

      if (response.statusCode == 200) {
        final file = File(_filePath);
        final sink = file.openWrite();

        // await _controller.setDataSource(file.uri);
        await _controller.initialize();

        await _controller.play();

        await for (var data in response.data.stream) {
          sink.add(data);
          // await _controller.sendBuffer(data);
        }

        await sink.flush();
        await sink.close();

        // Video is downloaded and saved locally
      } else {
        // Handle HTTP error
      }
    } catch (e) {
      // Handle download errors
    } finally {
      setState(() {
        _downloading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
        _downloading
            ? CircularProgressIndicator() // Display downloading indicator
            : ElevatedButton(
                onPressed: _startDownload,
                child: Text('Download and Play Video'),
              ),
      ],
    );
  }
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Text("dsa"),
    );
  }
}

/// Example for EmojiPickerFlutter
class TestEmoji extends StatefulWidget {
  @override
  _TestEmojiState createState() => _TestEmojiState();
}

class _TestEmojiState extends State<TestEmoji> {
  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Emoji Picker Example App'),
          ),
          body: ListView(
            children: [],
          )),
    );
  }
}
