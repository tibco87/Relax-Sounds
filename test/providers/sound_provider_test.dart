import 'package:flutter_test/flutter_test.dart';
import 'package:relax_sounds/providers/sound_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SoundProvider soundProvider;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    soundProvider = SoundProvider();
  });

  group('SoundProvider Tests', () {
    test('should initialize with default values', () {
      expect(soundProvider.isPlaying, false);
      expect(soundProvider.isLooping, false);
      expect(soundProvider.isLoading, false);
      expect(soundProvider.error, null);
      expect(soundProvider.volume, 1.0);
      expect(soundProvider.currentSound, null);
      expect(soundProvider.favoriteSounds, isEmpty);
      expect(soundProvider.availableSounds, isEmpty);
    });

    test('should update volume', () async {
      const testVolume = 0.5;
      await soundProvider.setVolume(testVolume);
      expect(soundProvider.volume, testVolume);
    });

    test('should toggle loop mode', () async {
      expect(soundProvider.isLooping, false);
      await soundProvider.toggleLoop();
      expect(soundProvider.isLooping, true);
      await soundProvider.toggleLoop();
      expect(soundProvider.isLooping, false);
    });

    test('should handle favorites', () async {
      const soundName = 'test_sound';
      expect(soundProvider.isFavorite(soundName), false);
      
      await soundProvider.toggleFavorite(soundName);
      expect(soundProvider.isFavorite(soundName), true);
      
      await soundProvider.toggleFavorite(soundName);
      expect(soundProvider.isFavorite(soundName), false);
    });

    test('should handle loading states', () async {
      expect(soundProvider.isLoading, false);
      
      // Simulujeme načítavanie zvuku
      soundProvider.loadSound('test_sound');
      expect(soundProvider.isLoading, true);
      
      // Počkáme na dokončenie
      await Future.delayed(const Duration(milliseconds: 100));
      expect(soundProvider.isLoading, false);
    });
  });
} 