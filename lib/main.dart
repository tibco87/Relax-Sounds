import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'services/supabase_config.dart';
import 'screens/home_screen.dart';
import 'providers/sound_provider.dart';
import 'providers/settings_provider.dart';
import 'theme/app_theme.dart';
import 'services/supabase_service.dart';

void main() async {
  print('--- [DEBUG] main() started ---');
  print('--- [DEBUG] Start app initialization ---');
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  print('--- [DEBUG] WidgetsFlutterBinding initialized ---');
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  print('--- [DEBUG] Splash preserved ---');
  
  try {
    print('--- [DEBUG] Loading environment variables... ---');
    await dotenv.load();
    print('--- [DEBUG] Environment variables loaded ---');

    print('--- [DEBUG] Setting preferred orientations... ---');
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    print('--- [DEBUG] Orientations set ---');

    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      print('--- [DEBUG] Initializing MobileAds... ---');
      await MobileAds.instance.initialize();
      print('--- [DEBUG] MobileAds initialized ---');
    } else {
      print('--- [DEBUG] Skipping MobileAds initialization (not mobile) ---');
    }

    print('--- [DEBUG] Initializing Supabase... ---');
    await SupabaseService.initialize();
    print('--- [DEBUG] Supabase initialized ---');
    
    print('--- [DEBUG] Removing splash screen... ---');
    FlutterNativeSplash.remove();
    print('--- [DEBUG] Splash screen removed ---');
    
    print('--- [DEBUG] Starting app... ---');
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SoundProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: const MyApp(),
      ),
    );
    print('--- [DEBUG] App started ---');
  } catch (e, stackTrace) {
    print('--- [ERROR] Error during initialization: $e ---');
    print('--- [ERROR] Stack trace: $stackTrace ---');
    FlutterNativeSplash.remove();
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building MyApp widget...');
    return MaterialApp(
      title: 'Sleep Sounds',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('de'), // German
        Locale('fr'), // French
        Locale('es'), // Spanish
        Locale('it'), // Italian
        Locale('pt'), // Portuguese
        Locale('da'), // Danish
        Locale('nl'), // Dutch
        Locale('sv'), // Swedish
        Locale('fi'), // Finnish
        Locale('no'), // Norwegian
        Locale('pl'), // Polish
        Locale('hu'), // Hungarian
        Locale('cs'), // Czech
        Locale('sk'), // Slovak
        Locale('uk'), // Ukrainian
        Locale('ru'), // Russian
        Locale('zh'), // Chinese
        Locale('hi'), // Hindi
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
        Locale('ar'), // Arabic
      ],
      home: const AppBackground(child: HomeScreen()),
    );
  }
}

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    print('Building AppBackground widget...');
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/apka1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
