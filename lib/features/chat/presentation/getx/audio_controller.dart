import 'package:ashghal_app_frontend/config/app_souds.dart';
import 'package:ashghal_app_frontend/core/services/directory_path.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/multimedia_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

class AudioController extends GetxController {
  final _isRecordPlaying = false.obs,
      isRecording = false.obs,
      isSending = false.obs,
      isUploading = false.obs;

  ///the id of the current audio i am dealing with
  final _currentId = 999999.obs;
  final start = DateTime.now().obs;
  final end = DateTime.now().obs;
  String _total = "";
  String get total => _total;
  var completedPercentage = 0.0.obs;
  var currentDuration = 0.obs;
  var totalDuration = 0.obs;

  // Rx<Duration> duration =  Duration().obs;
  // Rx<Duration> position = const Duration();

  bool get isRecordPlaying => _isRecordPlaying.value;
  bool get isRecordingValue => isRecording.value;
  late final AudioPlayerService _audioPlayerService;
  int get currentId => _currentId.value;
  late String recordFilePath;
  MultimediaController _multimediaController = Get.find();
  ConversationController _conversationController = Get.find();

  RxDouble playSpeed = 1.0.obs;

  // RxBool isLoading = false.obs;
  // int increasingDuration = 0;

  var getPathFile = DirectoryPath();

  @override
  void onInit() {
    _audioPlayerService = AudioPlayerAdapter();

    //An event is going to be sent as soon as the audio duration is available
    //(it might take a while to download or buffer it).
    //set the audio total duration
    _audioPlayerService.getAudioPlayer.onDurationChanged.listen((d) {
      // print("first Listener");
      // print(d.inSeconds);
      // _duration = duration;
      totalDuration.value = d.inSeconds;
    });
//Roughly fires every 200 milliseconds. Will continuously update the
//position of the playback if the status is [PlayerState.playing].
    //get the current duration of the played audio, and update the percentage
    _audioPlayerService.getAudioPlayer.onPositionChanged.listen((d) {
      // print("second Listener");
      currentDuration.value = d.inSeconds;
      // print(d.inSeconds);

      // print("currentDuration: ${currentDuration.value}");
      completedPercentage.value =
          currentDuration.value.toDouble() / totalDuration.value.toDouble();
      // if (d.inSeconds == 5) {
      //     increasingDuration = 5;
      //   }
      // print("completedPercentage: ${completedPercentage.value}");
    });

    //Events are sent every time an audio is finished, therefore no event is sent
    //when an audio is paused or stopped.
    _audioPlayerService.getAudioPlayer.onPlayerComplete.listen((event) async {
      // print("Third Listener");
      //Moves the cursor to zero
      await _audioPlayerService.getAudioPlayer.seek(Duration.zero);
      // completedPercentage.value = 0.0;

      _isRecordPlaying.value = false;
      currentDuration.value = 0;
      completedPercentage.value = 0;
    });

    super.onInit();
  }

  //total duration=25
  //current duration = 4
  //percent=0.16
  void increasePlayingSpeed() {
    if (playSpeed == 2.0) {
      playSpeed.value = 1.0;
    } else {
      playSpeed.value += 0.5;
    }
    _audioPlayerService.getAudioPlayer.setPlaybackRate(playSpeed.value);
  }

  void seekTo(double secondDuration) {
    _audioPlayerService.getAudioPlayer
        .seek(Duration(seconds: secondDuration.toInt()));
  }

  @override
  void onClose() {
    _audioPlayerService.dispose();
    super.onClose();
  }

  // Future<void> changeProg() async {
  //   if (isRecordPlaying) {
  //     _audioPlayerService.getAudioPlayer.onDurationChanged.listen((duration) {
  //       totalDuration.value = duration.inMicroseconds;
  //     });

  //     _audioPlayerService.getAudioPlayer.onPositionChanged.listen((duration) {
  //       currentDuration.value = duration.inMicroseconds;
  //       completedPercentage.value =
  //           currentDuration.value.toDouble() / totalDuration.value.toDouble();
  //     });
  //   }
  // }

  void onPressedPlayButton(int id, String path) async {
    if (_currentId.value != id) {
      print("New audio");
      _currentId.value = id;
      // await _audioPlayerService.getAudioPlayer.setSourceDeviceFile(path);
      // totalDuration.value =
      //     (await _audioPlayerService.getAudioPlayer.getDuration())!
      //         .inMilliseconds;
      currentDuration.value = 0;
      completedPercentage.value = 0;
      await _playRecord(path);
    } else if (isRecordPlaying) {
      await _pauseRecord();
      print("puase audio");
    } else if (_audioPlayerService.getAudioPlayer.state ==
        PlayerState.completed) {
      await _playRecord(path);
      print("replay adio");
    } else {
      await _resumeRecord();
      print("resume audio");
    }

    // if (isRecordPlaying) {
    //   await _pauseRecord();
    // } else {
    //   await _playRecord(path);
    // }
  }

  calcDuration() {
    var a = end.value.difference(start.value).inSeconds;
    format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
    _total = format(Duration(seconds: a));
  }

  Future<void> _pauseRecord() async {
    _isRecordPlaying.value = false;
    await _audioPlayerService.pause();
  }

  Future<void> _playRecord(String path) async {
    // isLoading.value = true;
    _isRecordPlaying.value = true;
    await _audioPlayerService.play(path);

    // isLoading.value = false;
  }

  Future<void> _resumeRecord() async {
    _isRecordPlaying.value = true;
    await _audioPlayerService.resume();

    // isLoading.value = false;
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord(String userName) async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getPathFile.getPath("record");
      recordFilePath =
          "$recordFilePath/$userName${DateTime.now().microsecondsSinceEpoch}.mp3";
      start.value = DateTime.now();
      RecordMp3.instance.start(recordFilePath, (type) {
        print("**********Error************$type");
        // setState(() {});
      });
    } else {}
    // setState(() {});
  }

  void stopRecord() async {
    bool stop = RecordMp3.instance.stop();
    end.value = DateTime.now();
    calcDuration();
    var ap = AudioPlayer();
    await ap.play(AssetSource(AppSounds.startRecording));
    ap.onPlayerComplete.listen((a) {});
    if (stop) {
      isRecording.value = false;
      isSending.value = true;
      await uploadAudio();
    }
  }

  uploadAudio() async {
    try {
      await _conversationController.sendMultimediaMessage(recordFilePath);
      // _multimediaController.sendMultiMedia([recordFilePath], []);
      // _multimediaController.uploadFile(filePath: filePath, fileType: fileType, messageLocalId: messageLocalId)
      isSending.value = false;
    } catch (e) {
      isSending.value = false;
    }
  }
}

abstract class AudioPlayerService {
  void dispose();
  Future<void> play(String url);
  Future<void> resume();
  Future<void> pause();
  Future<void> release();

  AudioPlayer get getAudioPlayer;
}

class AudioPlayerAdapter implements AudioPlayerService {
  late AudioPlayer _audioPlayer;

  @override
  AudioPlayer get getAudioPlayer => _audioPlayer;

  AudioPlayerAdapter() {
    _audioPlayer = AudioPlayer();
    // _audioPlayer.s
  }

  @override
  void dispose() async {
    await _audioPlayer.dispose();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> play(String url) async {
    await _audioPlayer.play(DeviceFileSource(url));
  }

  @override
  Future<void> release() async {
    await _audioPlayer.release();
  }

  @override
  Future<void> resume() async {
    await _audioPlayer.resume();
  }
}

// class AudioDuration {
//   static double calculate(Duration soundDuration) {
//     if (soundDuration.inSeconds > 60) {
//       return 70;
//     } else if (soundDuration.inSeconds > 50) {
//       return 65;
//     } else if (soundDuration.inSeconds > 40) {
//       return 60;
//     } else if (soundDuration.inSeconds > 30) {
//       return 55;
//     } else if (soundDuration.inSeconds > 20) {
//       return 50;
//     } else if (soundDuration.inSeconds > 10) {
//       return 45;
//     } else {
//       return 40;
//     }
//   }
// }
