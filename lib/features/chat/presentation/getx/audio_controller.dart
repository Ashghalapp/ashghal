import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/services/directory_path.dart';
import 'package:ashghal_app_frontend/core/util/app_util.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_screen_controller.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioController extends GetxController {
  RxBool isRecording = false.obs;
  RxBool isRecordingCompleted = false.obs;
  RxString recordPath = "".obs;
  RxBool isRecordPlaying = false.obs;
  RxBool isPlayerPrepared = false.obs;

  ///the id of the current audio i am dealing with
  RxInt currentId = (-1).obs;
  final start = DateTime.now().obs;
  final end = DateTime.now().obs;

  late String recordFilePath;

  PlayerController currentPlayer = PlayerController();
  RecorderController recorderController = RecorderController();
  RxInt recordingDurationInSeconds = 0.obs;

  var getPathFile = DirectoryPath();

  @override
  void onInit() {
    recorderController.onCurrentDuration.listen((event) {
      recordingDurationInSeconds.value = event.inSeconds;
    });
    recorderController.onRecordingEnded.listen((event) {
      recordingDurationInSeconds.value = event.inSeconds;
    });
    super.onInit();
  }

  @override
  void onClose() {
    currentPlayer.dispose();
    recorderController.dispose();
    super.onClose();
  }

  /// a function to kepp tracking of audios plaing
  /// so that only one audio is played at a time
  Future<void> onNewAudioPlayed(
      int id, PlayerController newPlayerController) async {
    AppPrint.printInfo("onNewAudioPlayed ");
    if (currentId.value != id || currentId.value == -1) {
      currentPlayer.pausePlayer();
      AppPrint.printInfo("onNewAudioPlayed ");
      currentId.value = id;
      currentPlayer = newPlayerController;
    }
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
      isRecording.value = true;
      await recorderController.record(path: recordFilePath);
    } else {
      AppUtil.buildErrorDialog(
        AppLocalization.recordingFailureCouldNotGrantPermision.tr,
      );
    }
  }

  _preparePlayer() async {
    if (recordPath.value != "") {
      currentId.value = -1;
      currentPlayer.pausePlayer();
      currentPlayer = PlayerController();
      await currentPlayer.preparePlayer(path: recordPath.value).then(
        (value) {
          isPlayerPrepared.value = true;
        },
      );
    }
  }

  void cancelRecord() {
    isRecording.value = false;
    isPlayerPrepared.value = false;
    isRecordingCompleted.value = false;
    isRecordPlaying.value = false;
    currentPlayer.stopPlayer();
    currentPlayer = PlayerController();
    recordingDurationInSeconds.value = 0;
  }

  void stopRecord() async {
    if (isRecording.value) {
      recorderController.reset();
      recordPath.value = await recorderController.stop(false) ?? "";

      if (recordPath.value != "") {
        isRecordingCompleted.value = true;
        isRecording.value = false;
        await _preparePlayer();
      }
    }
  }

  Future<void> playPauseRecord() async {
    if (isRecordPlaying.value) {
      AppPrint.printInfo("Record stoped playing");
      currentPlayer.stopPlayer();
      isRecordPlaying.value = false;
    } else {
      AppPrint.printInfo("Record started playing");

      currentPlayer.startPlayer(finishMode: FinishMode.loop);
      isRecordPlaying.value = true;
    }
  }

  uploadAudio() async {
    try {
      cancelRecord();
      await Get.find<ConversationScreenController>()
          .sendMultimediaMessage(recordPath.value);
    } catch (e) {
      AppUtil.buildErrorDialog(AppLocalization.couldNotSendTheSound.tr);
    }
  }
}
