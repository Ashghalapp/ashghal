import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class TestDownloading extends StatefulWidget {
  const TestDownloading({super.key});

  @override
  State<TestDownloading> createState() => _TestDownloadingState();
}

class _TestDownloadingState extends State<TestDownloading> {
  String imageUrl =
      // "https://th.bing.com/th/id/OIP.xMHLjeYwNHdCbxnIsvOnSQHaGP?pid=ImgDet&rs=1";
      "https://youtu.be/6tfBflFUO7s?si=AlRE1y68DWFqfmAE";
  bool isDownloading = false;
  Dio dio = Dio();
  String progressString = "";
  bool complete = false;
  String path = "";
  int counter = 0;

  Future<void> downloadFile() async {
    try {
      isDownloading = true;
      progressString = "";
      complete = false;
      var dir = await getApplicationDocumentsDirectory();
      path = dir.path + "/image${counter}.mp4";
      await dio.download(
        imageUrl,
        path,
        onReceiveProgress: (count, total) {
          print("count: $count, total: $total");
          setState(() {
            progressString = ((count / total) * 100).toStringAsFixed(0) + "%";
          });
        },
      );
    } catch (e) {
      print("Error: ${e.toString()}");
    }
    setState(() {
      isDownloading = false;
      progressString = "Download Completed";
      complete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            IconButton(onPressed: downloadFile, icon: Icon(Icons.download)),
            isDownloading
                ? Container(
                    height: 120,
                    width: 200,
                    color: Colors.black,
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          progressString,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  )
                : Text("No data"),
            if (complete) Text("Downloaded Success")
            // Image.file(File(path)),
            // FileDownloadWidget(
            //   onProgress: (p0) {
            //     print(p0.toString());
            //   },
            //   url: imageUrl,
            // ),
          ],
        ),
      ),
    );
  }
}

class FileDownloadWidget extends StatefulWidget {
  final String url;
  final Function(double) onProgress;

  FileDownloadWidget({required this.url, required this.onProgress});

  @override
  _FileDownloadWidgetState createState() => _FileDownloadWidgetState();
}

class _FileDownloadWidgetState extends State<FileDownloadWidget> {
  late Dio dio;
  double progress = 0.0;
  late CancelToken cancelToken;
  String path = "";
  int counter = 0;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    cancelToken = CancelToken();
    downloadFile();
  }

  void downloadFile() async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      path = dir.path + "/image${counter}.mp4";
      print("Started 55");
      await dio.download(
        widget.url,
        path, // Provide the path where you want to save the file
        onReceiveProgress: (received, total) {
          print("Started");
          if (total != -1) {
            double percent = (received / total) * 100;
            widget.onProgress(percent);
            setState(() {
              progress = percent;
            });
          }
        },
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        // Download was canceled
        print('Download canceled');
      } else {
        // Handle other errors
        print('Download error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: progress / 100, // Set the progress value between 0 and 1
          ),
          const SizedBox(height: 20),
          Text(
            '${progress.toStringAsFixed(1)}%', // Display progress as a percentage
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cancelToken.cancel(); // Cancel the download when the widget is disposed
    super.dispose();
  }
}
