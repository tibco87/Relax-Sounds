import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';
import '../screens/sound_player_screen.dart';

class SoundGrid extends StatelessWidget {
  const SoundGrid({super.key});

  String _getTranslatedName(AppLocalizations l10n, String soundKey) {
    switch (soundKey) {
      case 'ocean': return l10n.ocean;
      case 'rain': return l10n.rain;
      case 'thunder': return l10n.thunderstorm;
      case 'wind': return l10n.wind;
      case 'fire': return l10n.fire;
      case 'birds': return l10n.birds;
      case 'crickets': return l10n.crickets;
      case 'frogs': return l10n.frogs;
      case 'night': return l10n.night;
      case 'waves': return l10n.waves;
      case 'stream': return l10n.stream;
      case 'waterfall': return l10n.waterfall;
      default: return soundKey;
    }
  }

  String _getImagePath(String soundKey) {
    switch (soundKey) {
      case 'ocean': return 'assets/images/ocean.jpg';
      case 'rain': return 'assets/images/dazd.jpg';
      case 'thunder': return 'assets/images/burka.jpg';
      case 'wind': return 'assets/images/vietor.jpg';
      case 'fire': return 'assets/images/ohen.jpg';
      case 'birds': return 'assets/images/vtaky.jpg';
      case 'crickets': return 'assets/images/farma.jpg';
      case 'frogs': return 'assets/images/farma.jpg';
      case 'night': return 'assets/images/night.jpg';
      case 'waves': return 'assets/images/ocean.jpg';
      case 'stream': return 'assets/images/les.jpg';
      case 'waterfall': return 'assets/images/les.jpg';
      default: return 'assets/images/les.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final soundProvider = Provider.of<SoundProvider>(context);
    
    final sounds = [
      'ocean',
      'rain',
      'thunder',
      'wind',
      'fire',
      'birds',
      'crickets',
      'frogs',
      'night',
      'waves',
      'stream',
      'waterfall',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        final soundKey = sounds[index];
        final translatedName = _getTranslatedName(l10n, soundKey);
        final imagePath = _getImagePath(soundKey);
        
        return GestureDetector(
          onTap: () async {
            await soundProvider.loadSound(soundKey);
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SoundPlayerScreen(
                    soundName: translatedName,
                    soundKey: soundKey,
                  ),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    translatedName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 