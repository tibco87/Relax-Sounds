import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLooping = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _volume = 1.0;
  String? _currentSound;
  Set<String> _favoriteSounds = {};
  SharedPreferences? _prefs;

  bool get isPlaying => _isPlaying;
  bool get isLooping => _isLooping;
  Duration get duration => _duration;
  Duration get position => _position;
  double get volume => _volume;
  String? get currentSound => _currentSound;
  Set<String> get favoriteSounds => _favoriteSounds;

  SoundProvider() {
    _initPrefs();
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _player.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFavoriteSounds();
  }

  void _loadFavoriteSounds() {
    final favorites = _prefs?.getStringList('favoriteSounds') ?? [];
    _favoriteSounds = favorites.toSet();
    notifyListeners();
  }

  Future<void> _saveFavoriteSounds() async {
    if (_prefs != null) {
      await _prefs!.setStringList('favoriteSounds', _favoriteSounds.toList());
    }
  }

  bool isFavorite(String soundName) {
    return _favoriteSounds.contains(soundName);
  }

  Future<void> toggleFavorite(String soundName) async {
    if (_favoriteSounds.contains(soundName)) {
      _favoriteSounds.remove(soundName);
    } else {
      _favoriteSounds.add(soundName);
    }
    await _saveFavoriteSounds();
    notifyListeners();
  }

  Future<void> loadSound(String soundName) async {
    try {
      await _player.setAsset('assets/sounds/$soundName.mp3');
      _currentSound = soundName;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading sound: $e');
      }
    }
  }

  Future<void> togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> toggleLoop() async {
    _isLooping = !_isLooping;
    await _player.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setTimer(Duration duration) async {
    if (duration > Duration.zero) {
      await _player.setClip(
        start: Duration.zero,
        end: duration,
      );
    } else {
      await _player.setClip();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
} 