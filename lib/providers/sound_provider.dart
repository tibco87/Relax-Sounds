import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/supabase_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audio_service/audio_service.dart';

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
  late AudioHandler _audioServiceHandler;

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
    _initAudioSession();
    _initAudioService();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers | AVAudioSessionCategoryOptions.allowBluetooth,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  Future<void> _initAudioService() async {
    print('DEBUG: _initAudioService called');
    _audioServiceHandler = await AudioService.init(
      builder: () => MyAudioServiceHandler(_player),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.example.relax_sounds.channel.audio',
        androidNotificationChannelName: 'Relax Sounds',
      ),
    );
    print('DEBUG: _initAudioService completed');
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
      _isLoading = state == ProcessingState.loading;
      notifyListeners();
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
      if (kDebugMode) print(_error);
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

  bool isFavorite(String soundName) => _favoriteSounds.contains(soundName);

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
      print('DEBUG: Supabase vrátil URL: $soundUrl');

      await _player.setAudioSource(AudioSource.uri(Uri.parse(soundUrl)));
      final duration = _player.duration;
      print('DEBUG: Duration: $duration');

      final mediaItem = MediaItem(
        id: soundName,
        album: 'Relax Sounds',
        title: soundName,
        artist: 'Relax App',
        artUri: Uri.parse('https://cdn-icons-png.flaticon.com/512/727/727245.png'),
        displayTitle: soundName,
        displaySubtitle: 'Relax Sounds',
        duration: duration ?? Duration.zero,
        playable: true,
        rating: Rating.newHeartRating(true),
      );

      print('DEBUG: Vytváram MediaItem: $mediaItem');

      final audioSource = AudioSource.uri(
        Uri.parse(soundUrl),
        tag: mediaItem,
      );

      await _player.setAudioSource(audioSource);
      print('DEBUG: AudioPlayer nastavil URL bez chyby');
      _currentSound = soundName;

      if (_audioServiceHandler is MyAudioServiceHandler) {
        final handler = _audioServiceHandler as MyAudioServiceHandler;
        print('DEBUG: Nastavujem queue a mediaItem');
        handler.setQueueAndMediaItem([mediaItem], mediaItem);
      }
    } catch (e) {
      _error = 'Failed to load sound: ${e.toString()}';
      print('DEBUG: Chyba pri prehrávaní: $_error');
      if (kDebugMode) print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> togglePlay() async {
    try {
      _player.playing ? await _player.pause() : await _player.play();
    } catch (e) {
      _error = 'Failed to play/pause: ${e.toString()}';
      if (kDebugMode) print(_error);
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
      if (kDebugMode) print(_error);
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
      if (kDebugMode) print(_error);
      notifyListeners();
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      _error = 'Failed to seek: ${e.toString()}';
      if (kDebugMode) print(_error);
      notifyListeners();
    }
  }

  Future<void> setTimer(Duration duration) async {
    try {
      if (duration > Duration.zero) {
        await _player.setClip(start: Duration.zero, end: duration);
      } else {
        await _player.setClip();
      }
    } catch (e) {
      _error = 'Failed to set timer: ${e.toString()}';
      if (kDebugMode) print(_error);
      notifyListeners();
    }
  }

  Future<void> clearCache() async {
    try {
      await _supabaseService.clearCache();
    } catch (e) {
      _error = 'Failed to clear cache: ${e.toString()}';
      if (kDebugMode) print(_error);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

class MyAudioServiceHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player;

  MyAudioServiceHandler(this._player) {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  void setQueueAndMediaItem(List<MediaItem> items, MediaItem current) {
    queue.add(items);
    mediaItem.add(current);
  }

  void _updateQueueAndMediaItem() {
    final sequenceState = _player.sequenceState;
    if (sequenceState != null) {
      final queueList = sequenceState.effectiveSequence;
      final items = queueList.map((source) => source.tag as MediaItem).toList();
      queue.add(items);
      if (sequenceState.currentIndex != null && items.isNotEmpty) {
        mediaItem.add(items[sequenceState.currentIndex!]);
      }
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      _updateQueueAndMediaItem();
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: [0, 1, 3],
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: _player.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      _updateQueueAndMediaItem();
      var index = _player.currentIndex;
      var newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (_player.shuffleModeEnabled) {
        index = _player.shuffleIndices![index];
      }
      newQueue[index] = newQueue[index].copyWith(duration: duration);
      queue.add(newQueue);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    _player.currentIndexStream.listen((index) {
      _updateQueueAndMediaItem();
      if (index != null && queue.value.isNotEmpty) {
        mediaItem.add(queue.value[index]);
      }
    });
  }

  void _listenForSequenceStateChanges() {
    _player.sequenceStateStream.listen((SequenceState? sequenceState) {
      _updateQueueAndMediaItem();
      if (sequenceState == null) return;
      final queueList = sequenceState.effectiveSequence;
      final items = queueList.map((source) => source.tag as MediaItem).toList();
      queue.add(items);
      if (sequenceState.currentIndex != null && items.isNotEmpty) {
        mediaItem.add(items[sequenceState.currentIndex!]);
      }
    });
  }

  @override
  Future<void> play() async {
    _updateQueueAndMediaItem();
    await _player.play();
  }

  @override
  Future<void> pause() async {
    _updateQueueAndMediaItem();
    await _player.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    _updateQueueAndMediaItem();
    await _player.seek(position);
  }

  @override
  Future<void> stop() async {
    _updateQueueAndMediaItem();
    await _player.stop();
  }
}
