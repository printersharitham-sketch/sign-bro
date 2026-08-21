import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  final AudioPlayer _player = AudioPlayer();
  bool _enabled = true;
  double _volume = 0.7;

  Future<void> _play(String asset) async {
    if (!_enabled) return;
    try {
      await _player.setVolume(_volume);
      await _player.play(AssetSource('sounds/$asset'));
    } catch (_) {}
  }

  void tap() => _play('tap.mp3');
  void scanStart() => _play('scan_start.mp3');
  void lock() => _play('lock.mp3');
  void success() => _play('success.mp3');
  void error() => _play('error.mp3');
  void navigation() => _play('navigation.mp3');
  void quotation() => _play('quote.mp3');

  void setEnabled(bool enabled) => _enabled = enabled;
  void setVolume(double volume) => _volume = volume.clamp(0.0, 1.0);

  bool get isEnabled => _enabled;
  double get volume => _volume;

  void dispose() {
    _player.dispose();
  }
}
