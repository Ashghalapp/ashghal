import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class TestAudio extends StatefulWidget {
  const TestAudio({super.key});

  @override
  State<TestAudio> createState() => _TestAudioState();
}

class _TestAudioState extends State<TestAudio> {
  late final RecorderController recorderController;
  String path = "";
  bool isRecording = false;

  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  void initState() {
    super.initState();
    _initialiseController();
  }

  void _startRecording() async {
    await recorderController.record();
    setState(() {
      isRecording = true;
    });
    // update state here to, for eample, change the button's state
  }

  void _stopRecoding() async {
    path = await recorderController.stop() ?? "";

    setState(() {
      isRecording = false;
    });
    // update state here to, for eample, change the button's state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              getWaves(context),
            ],
          ),
          IconButton(
              icon: const Icon(Icons.mic),
              tooltip: 'Start recording',
              onPressed: () {
                if (isRecording) {
                  _stopRecoding();
                } else {
                  _startRecording();
                }
              })
        ],
      ),
    );
  }

  AudioWaveforms getWaves(BuildContext context) {
    return AudioWaveforms(
      enableGesture: true,
      size: Size(MediaQuery.of(context).size.width / 2, 50),
      recorderController: recorderController,
      waveStyle: const WaveStyle(
        waveColor: Colors.white,
        extendWaveform: true,
        showMiddleLine: false,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xFF1E1B26),
      ),
      padding: const EdgeInsets.only(left: 18),
      margin: const EdgeInsets.symmetric(horizontal: 15),
    );
    // AudioWaveforms(
    //       size: Size(MediaQuery.of(context).size.width, 200.0),
    //       recorderController: recorderController,
    //     );
  }
}
