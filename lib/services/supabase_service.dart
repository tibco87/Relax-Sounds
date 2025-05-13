import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

  Future<String> getSoundUrl(String soundName) async {
    try {
      final response = await Supabase.instance.client
          .storage
          .from('sounds')
          .createSignedUrl('$soundName.mp3', 3600);
      return response;
    } catch (e) {
      throw Exception('Failed to get sound URL: $e');
    }
  }

  Future<List<String>> listSounds() async {
    try {
      final response = await Supabase.instance.client
          .storage
          .from('sounds')
          .list();
      
      return response
          .where((file) => file.name.endsWith('.mp3'))
          .map((file) => file.name.replaceAll('.mp3', ''))
          .toList();
    } catch (e) {
      throw Exception('Failed to list sounds: $e');
    }
  }

  Future<void> downloadSound(String soundName, String localPath) async {
    try {
      await Supabase.instance.client
          .storage
          .from('sounds')
          .download('$soundName.mp3');
    } catch (e) {
      throw Exception('Failed to download sound: $e');
    }
  }

  Future<void> clearCache() async {
    // Zatiaľ žiadna implementácia, prázdna metóda pre kompatibilitu
  }
} 