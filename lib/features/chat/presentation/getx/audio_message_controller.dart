import 'package:ashghal_app_frontend/core/helper/app_print_class.dart';
import 'package:ashghal_app_frontend/core/localization/app_localization.dart';
import 'package:ashghal_app_frontend/core/util/dialog_util.dart';
import 'package:ashghal_app_frontend/features/chat/data/local_db/db/chat_local_db.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/audio_controller.dart';
import 'package:ashghal_app_frontend/features/chat/presentation/getx/conversation_controller.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:get/get.dart';

class AudioMessageController extends GetxController {
  AudioController audioGeneralController = Get.find();
  late PlayerController playerController;
  RxBool isPlayerPrepared = false.obs;
  RxBool isPlaying = false.obs;
  RxInt currentDuration = 0.obs;
  RxInt totalDuration = 0.obs;
  final ConversationController? _conversationController;
  final LocalMultimedia multimedia;
  final bool isReady;
  AudioMessageController({required this.multimedia, this.isReady = false})
      : _conversationController =
            isReady ? null : Get.find<ConversationController>();
  @override
  void onInit() {
    super.onInit();
    playerController = PlayerController();
    playerController.onCurrentDurationChanged.listen(
      (event) {
        currentDuration.value = event;
      },
    );
  }

  Future<void> playPuaseButtonPressed() async {
    if (!isPlayerPrepared.value) {
      _preparePlayer().then(
        (value) async {
          if (value) {
            await _checkPlayerAndPlayIt();
          } else {
            DialogUtil.showErrorDialog(
              AppLocalization.couldNotPlayRecord.tr,
            );
          }
        },
      );
    } else {
      await _checkPlayerAndPlayIt();
    }
  }

  Future<void> _checkPlayerAndPlayIt() async {
    if (audioGeneralController.currentId.value == multimedia.localId) {
      await _playPuaseAudio();
    } else {
      await audioGeneralController.onNewAudioPlayed(
        multimedia.localId,
        playerController,
      );
      await _playPuaseAudio();
    }
  }

  Future<void> _playPuaseAudio() async {
    if (isPlaying.value) {
      isPlaying.value = false;
      await playerController.pausePlayer();
    } else {
      isPlaying.value = true;
      await playerController.startPlayer(finishMode: FinishMode.loop);
    }
  }

  Future<bool> _preparePlayer() async {
    // get the multimedia from the main messages list,
    // becuase if its data is refreshed the controller will not be built again
    // and the data of the multimedia inside it doesn't got the refresh
    LocalMultimedia? newMultimedia;
    if (isReady) {
      newMultimedia = multimedia;
    } else {
      newMultimedia = _conversationController!.messages
          .firstWhereOrNull(
              (element) => element.message.localId == multimedia.messageId)
          ?.multimedia;
    }

    if (newMultimedia != null && newMultimedia.path != null) {
      try {
        await playerController.preparePlayer(
          path: newMultimedia.path!,
          shouldExtractWaveform: true,
        );
        totalDuration.value = playerController.maxDuration;
        currentDuration.value = 0;
        isPlayerPrepared.value = true;
        return true;
      } catch (e) {
        AppPrint.printError("Something went wrong, Couldn't play the record");
        isPlayerPrepared.value = false;
        return false;
      }
    } else {
      isPlayerPrepared.value = false;
      return false;
    }
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }
}
