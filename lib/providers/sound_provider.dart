import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/supabase_service.dart';

class SoundProvider with ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final SupabaseService _supabaseService = SupabaseService();
  bool _isPlaying = false;
  bool _isLooping = false;
  bool _isLoading = false;
  String? _error;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _volume = 1.0;
  String? _currentSound;
  Set<String> _favoriteSounds = {};
  SharedPreferences? _prefs;
  List<String> _availableSounds = [];

  bool get isPlaying => _isPlaying;
  bool get isLooping => _isLooping;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Duration get duration => _duration;
  Duration get position => _position;
  double get volume => _volume;
  String? get currentSound => _currentSound;
  Set<String> get favoriteSounds => _favoriteSounds;
  List<String> get availableSounds => _availableSounds;

  SoundProvider() {
    _initPrefs();
    _loadAvailableSounds();
    _setupPlayerListeners();
  }

  void _setupPlayerListeners() {
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

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.loading) {
        _isLoading = true;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> _loadAvailableSounds() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _availableSounds = await _supabaseService.listSounds();
    } catch (e) {
      _error = 'Failed to load sounds: ${e.toString()}';
      if (kDebugMode) {
        print(_error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
      _isLoading = true;
      _error = null;
      notifyListeners();

      final soundUrl = await _supabaseService.getSoundUrl(soundName);
      print('DEBUG: Supabase vrátil URL: ' + soundUrl);
      await _player.setUrl(soundUrl);
      print('DEBUG: AudioPlayer nastavil URL bez chyby');
      _currentSound = soundName;
    } catch (e) {
      _error = 'Failed to load sound: [31m${e.toString()}[0m';
      print('DEBUG: Chyba pri prehrávaní: $_error');
      if (kDebugMode) {
        print(_error);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> togglePlay() async {
    try {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } catch (e) {
      _error = 'Failed to play/pause: ${e.toString()}';
      if (kDebugMode) {
        print(_error);
      }
      notifyListeners();
    }
  }

  Future<void> toggleLoop() async {
    try {
      _isLooping = !_isLooping;
      await _player.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to toggle loop: ${e.toString()}';
      if (kDebugMode) {
        print(_error);
      }
      notifyListeners();
    }
  }

  Future<void> setVolume(double value) async {
    try {
      _volume = value.clamp(0.0, 1.0);
      await _player.setVolume(_volume);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to set volume: ${e.toString()}';
      if (kDebugMode) {
        print(_error);
      }
      notifyListeners();
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      _error = 'Failed to seek: ${e.toString()}';
      if (kDebugMode) {
        print(_error);
      }
      notifyListeners();
    }
  }

  Future<void> setTimer(Duration duration) async {
    try {
      if (duration > Duration.zero) {
        await _player.setClip(
          start: Duration.zero,
          end: duration,
        );
      } else {
        await _player.setClip();
      }
    } catch (e) {
      _error = 'Failed to set timer: ${e.toString()}';
      if (kDebugMode) {
        print(_error);
      }
      notifyListeners();
    }
  }

  Future<void> clearCache() async {
    try {
      await _supabaseService.clearCache();
    } catch (e) {
      _error = 'Failed to clear cache: ${e.toString()}';
      if (kDebugMode) {
        print(_error);
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
} 