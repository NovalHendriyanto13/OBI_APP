import 'package:chewie_audio/chewie_audio.dart';
import 'package:video_player/video_player.dart';

class Sound {
  VideoPlayerController _bidPlayer;
  VideoPlayerController _openPlayer;
  VideoPlayerController _winPlayer;
  VideoPlayerController _closePlayer;

  ChewieAudioController _bidController;
  ChewieAudioController _openController;
  ChewieAudioController _winController;
  ChewieAudioController _closeController;
  ChewieAudioController _controller;

  Future<void> bidPlayerInit() async{
    _bidPlayer = VideoPlayerController.network(
        'https://otobid.co.id/eventually.mp3');
    await Future.wait([
      _bidPlayer.initialize(),
    ]);
    _bidController = setController(_bidPlayer);
  }

  ChewieAudioController getBidController() {
    _controller = _bidController;
    return _controller;
  }

  Future<void> openPlayerInit() async{
    _openPlayer = VideoPlayerController.network(
        'https://otobid.co.id/assets/media/open.mp3');
    await Future.wait([
      _openPlayer.initialize(),
    ]);
    _openController = setController(_openPlayer);
  }

  ChewieAudioController getOpenController() {
    _controller = _openController;
    return _controller;
  }

  Future<void> winPlayerInit() async{
    _winPlayer = VideoPlayerController.network(
        'https://otobid.co.id/assets/media/win.mp3');
    await Future.wait([
      _winPlayer.initialize(),
    ]);
    _winController = setController(_winPlayer);
  }

  ChewieAudioController getWinController() {
    _controller = _winController;
    return _controller;
  }

  Future<void> closePlayerInit() async{
    _closePlayer = VideoPlayerController.network(
        'https://otobid.co.id/assets/media/close.mp3');
    await Future.wait([
      _closePlayer.initialize(),
    ]);
    _closeController = setController(_closePlayer);
  }

  ChewieAudioController getCloseController() {
    _controller = _closeController;
    return _controller;
  }

  ChewieAudioController setController(VideoPlayerController player) {
    return ChewieAudioController(
      videoPlayerController: player,
      autoPlay: true,
      looping: false
    );
  }

  void play(){
    _controller.play();
  }

  void pause(){
    _controller.pause();
  }

  void dispose(){
    if (_bidPlayer != null) _bidPlayer.dispose();
    if (_openPlayer != null) _openPlayer.dispose();
    if (_bidController != null) _bidController.dispose();
    if (_openController != null) _openController.dispose();
    if (_closeController != null) _closeController.dispose();
    if (_winController != null) _winController.dispose();
    if (_controller != null) _controller.dispose();
  }
}