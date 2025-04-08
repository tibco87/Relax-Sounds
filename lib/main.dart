import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'screens/home_screen.dart';
import 'providers/sound_provider.dart';
import 'providers/settings_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
    await MobileAds.instance.initialize();
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SoundProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SoundProvider(),
      child: MaterialApp(
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
      ),
    );
  }
}

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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
