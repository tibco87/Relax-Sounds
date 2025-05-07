import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/sound_category.dart';
import '../models/sound.dart';
import '../providers/sound_provider.dart';
import 'sound_player_screen.dart';

class CategorySoundsScreen extends StatelessWidget {
  final SoundCategory category;

  const CategorySoundsScreen({
    super.key,
    required this.category,
  });

  List<Sound> _getSoundsForCategory(String categoryKey, AppLocalizations l10n) {
    switch (categoryKey) {
      case 'nature':
        return [
          Sound(key: 'ocean', name: l10n.ocean, icon: 'assets/images/ocean.jpg'),
          Sound(key: 'lake', name: l10n.lake, icon: 'assets/images/jazero.jpg'),
          Sound(key: 'bay', name: l10n.bay, icon: 'assets/images/zatoka.jpg'),
          Sound(key: 'forest', name: l10n.forest, icon: 'assets/images/les.jpg'),
          Sound(key: 'wind', name: l10n.wind, icon: 'assets/images/vietor.jpg'),
          Sound(key: 'leaves', name: l10n.leaves, icon: 'assets/images/listy.jpg'),
          Sound(key: 'waterfall', name: l10n.waterfall, icon: 'assets/images/vodopad.jpg'),
          Sound(key: 'underwater', name: l10n.underwater, icon: 'assets/images/podvodou.jpg'),
          Sound(key: 'meadow', name: l10n.meadow, icon: 'assets/images/luka.jpg'),
          Sound(key: 'dripping', name: l10n.dripping, icon: 'assets/images/kvapka.jpg'),
        ];
      case 'animals':
        return [
          Sound(key: 'birds', name: l10n.birds, icon: 'assets/images/vtaky.jpg'),
          Sound(key: 'frogs', name: l10n.frogs, icon: 'assets/images/zaby.jpg'),
          Sound(key: 'crickets', name: l10n.crickets, icon: 'assets/images/cvrcek.jpg'),
          Sound(key: 'cicada', name: l10n.cicada, icon: 'assets/images/cikada.jpg'),
          Sound(key: 'wolf', name: l10n.wolf, icon: 'assets/images/vlk.jpg'),
          Sound(key: 'cat', name: l10n.cat, icon: 'assets/images/macky.jpg'),
          Sound(key: 'owl', name: l10n.owl, icon: 'assets/images/sova.jpg'),
          Sound(key: 'whale', name: l10n.whale, icon: 'assets/images/velryba.jpg'),
          Sound(key: 'dolphin', name: l10n.dolphin, icon: 'assets/images/delfiny.jpg'),
        ];
      case 'transport':
        return [
          Sound(key: 'train', name: l10n.train, icon: 'assets/images/vlak.jpg'),
          Sound(key: 'airplane', name: l10n.airplane, icon: 'assets/images/lietadlo.jpg'),
          Sound(key: 'car', name: l10n.car, icon: 'assets/images/auto.jpg'),
          Sound(key: 'metro', name: l10n.metro, icon: 'assets/images/metro.jpg'),
        ];
      case 'city':
        return [
          Sound(key: 'crowd', name: l10n.crowd, icon: 'assets/images/dav.jpg'),
          Sound(key: 'cafe', name: l10n.cafe, icon: 'assets/images/kaviaren.jpg'),
          Sound(key: 'construction', name: l10n.construction, icon: 'assets/images/stavba.jpg'),
          Sound(key: 'churchBells', name: l10n.churchBells, icon: 'assets/images/zvony.jpg'),
        ];
      case 'meditation':
        return [
          Sound(key: 'guitar', name: l10n.guitar, icon: 'assets/images/gitara.jpg'),
          Sound(key: 'piano', name: l10n.piano, icon: 'assets/images/klavir.jpg'),
          Sound(key: 'flute', name: l10n.flute, icon: 'assets/images/flauta.jpg'),
          Sound(key: 'meditationMusic', name: l10n.meditationMusic, icon: 'assets/images/meditation.jpg'),
        ];
      case 'romance':
        return [
          Sound(key: 'romanticMusic', name: l10n.romanticMusic, icon: 'assets/images/romantics.jpg'),
        ];
      case 'weather':
        return [
          Sound(key: 'wind', name: l10n.wind, icon: 'assets/images/vietor.jpg'),
          Sound(key: 'thunderstorm', name: l10n.thunderstorm, icon: 'assets/images/burka1.jpg'),
          Sound(key: 'rain', name: l10n.rain, icon: 'assets/images/dazd.jpg'),
          Sound(key: 'windWindow', name: l10n.windWindow, icon: 'assets/images/vietorzaoknom.jpg'),
        ];
      case 'colors':
      case 'noise':
        return [
          Sound(key: 'whiteNoise', name: l10n.whiteNoise, icon: 'assets/images/bielyzvuk.png'),
          Sound(key: 'pinkNoise', name: l10n.pinkNoise, icon: 'assets/images/ruzovyzvuk.jpg'),
          Sound(key: 'brownNoise', name: l10n.brownNoise, icon: 'assets/images/hnedyzvuk.jpg'),
          Sound(key: 'clearNoise', name: l10n.clearNoise, icon: 'assets/images/clearnoise.avif'),
        ];
      case 'home':
        return [
          Sound(key: 'hairDryer', name: l10n.hairDryer, icon: 'assets/images/fen.jpg'),
          Sound(key: 'vacuum', name: l10n.vacuum, icon: 'assets/images/vysavac.jpg'),
          Sound(key: 'fan', name: l10n.fan, icon: 'assets/images/ventilator.jpg'),
          Sound(key: 'dryer', name: l10n.dryer, icon: 'assets/images/susicka.jpg'),
          Sound(key: 'fireplace', name: l10n.fireplace, icon: 'assets/images/ohen.jpg'),
          Sound(key: 'keyboard', name: l10n.keyboard, icon: 'assets/images/klavesnica.jpg'),
        ];
      case 'motivation':
        return [
          Sound(key: 'morningBirds', name: l10n.morningBirds, icon: 'assets/images/rannevtaky.jpg'),
          Sound(key: 'sunrise', name: l10n.sunrise, icon: 'assets/images/usvit.jpg'),
          Sound(key: 'waterfall', name: l10n.waterfall, icon: 'assets/images/vodopad.jpg'),
          Sound(key: 'oceanWaves', name: l10n.oceanWaves, icon: 'assets/images/vlny.jpg'),
          Sound(key: 'rainforest', name: l10n.rainforest, icon: 'assets/images/prales.jpg'),
          Sound(key: 'mountainWind', name: l10n.mountainWind, icon: 'assets/images/horskyvietor.jpg'),
          Sound(key: 'morningForest', name: l10n.morningForest, icon: 'assets/images/rannyles.jpg'),
          Sound(key: 'river', name: l10n.river, icon: 'assets/images/rieka.jpg'),
        ];
      case 'instruments':
        return [
          Sound(key: 'cello', name: l10n.cello, icon: 'assets/images/violoncelo.jpg'),
          Sound(key: 'harp', name: l10n.harp, icon: 'assets/images/harfa.jpg'),
          Sound(key: 'drums', name: l10n.drums, icon: 'assets/images/bicie.jpg'),
          Sound(key: 'saxophone', name: l10n.saxophone, icon: 'assets/images/saxofon.jpg'),
          Sound(key: 'trumpet', name: l10n.trumpet, icon: 'assets/images/trubka.jpg'),
          Sound(key: 'accordion', name: l10n.accordion, icon: 'assets/images/akordeon.jpg'),
          Sound(key: 'dulcimer', name: l10n.dulcimer, icon: 'assets/images/cimbal.jpg'),
          Sound(key: 'kalimba', name: l10n.kalimba, icon: 'assets/images/kalimba.jpg'),
        ];
      case 'focus':
        return [
          Sound(key: 'whiteNoise', name: l10n.whiteNoise, icon: 'assets/images/bielyzvuk.png'),
          Sound(key: 'keyboard', name: l10n.keyboard, icon: 'assets/images/klavesnica.jpg'),
          Sound(key: 'fan', name: l10n.fan, icon: 'assets/images/ventilator.jpg'),
          Sound(key: 'rain', name: l10n.rain, icon: 'assets/images/dazd.jpg'),
          Sound(key: 'wind', name: l10n.wind, icon: 'assets/images/vietor.jpg'),
        ];
      default:
        return [];
    }
  }

  String _getBackgroundImage(String categoryKey) {
    return 'assets/images/apka1.jpg';
  }

  String _getSoundImage(String soundKey) {
    switch (soundKey) {
      // Nature sounds
      case 'ocean':
      case 'lake':
      case 'bay':
      case 'forest':
      case 'wind':
      case 'leaves':
      case 'waterfall':
      case 'underwater':
      case 'meadow':
      case 'dripping':
        return 'assets/images/priroda.jpg';
      // Animal sounds
      case 'birds':
      case 'frogs':
      case 'crickets':
      case 'cicada':
      case 'wolf':
      case 'cat':
      case 'owl':
      case 'whale':
      case 'dolphin':
        return 'assets/images/zvierata.jpg';
      // Transport sounds
      case 'train':
      case 'airplane':
      case 'car':
      case 'metro':
        return 'assets/images/doprava.jpg';
      // City sounds
      case 'crowd':
      case 'cafe':
      case 'construction':
      case 'churchBells':
        return 'assets/images/mesto.jpg';
      // Meditation sounds
      case 'guitar':
      case 'piano':
      case 'flute':
      case 'meditationMusic':
        return 'assets/images/meditacia.jpg';
      // Romance sounds
      case 'romanticMusic':
        return 'assets/images/romantika.jpg';
      // Weather sounds
      case 'wind':
      case 'thunderstorm':
      case 'rain':
      case 'windWindow':
        return 'assets/images/pocasie.jpg';
      // Noise sounds
      case 'whiteNoise':
      case 'pinkNoise':
      case 'brownNoise':
      case 'clearNoise':
        return 'assets/images/farby.jpg';
      // Home sounds
      case 'hairDryer':
      case 'vacuum':
      case 'fan':
      case 'dryer':
      case 'fireplace':
      case 'keyboard':
        return 'assets/images/domov.jpg';
      // Motivation sounds
      case 'morningBirds':
      case 'sunrise':
      case 'waterfall':
      case 'oceanWaves':
      case 'rainforest':
      case 'mountainWind':
      case 'morningForest':
      case 'river':
        return 'assets/images/motivacia.jpg';
      // Instrument sounds
      case 'cello':
      case 'harp':
      case 'drums':
      case 'saxophone':
      case 'trumpet':
      case 'accordion':
      case 'dulcimer':
      case 'kalimba':
        return 'assets/images/nastroje.jpg';
      default:
        return 'assets/images/priroda.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final soundProvider = Provider.of<SoundProvider>(context);
    final sounds = _getSoundsForCategory(category.key, l10n);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_getBackgroundImage(category.key)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            category.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: sounds.isEmpty
                      ? Center(
                          child: Text(
                            'No sounds available in this category yet',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: sounds.length,
                          itemBuilder: (context, index) {
                            final sound = sounds[index];
                            return GestureDetector(
                              onTap: () async {
                                await soundProvider.loadSound(sound.key);
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SoundPlayerScreen(
                                        soundName: sound.name,
                                        soundKey: sound.key,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: sound.icon.startsWith('assets/')
                                      ? null
                                      : Colors.white.withOpacity(0.1),
                                  image: sound.icon.startsWith('assets/')
                                      ? DecorationImage(
                                          image: AssetImage(sound.icon),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
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
                                    // Ikona alebo emoji v strede
                                    if (!sound.icon.startsWith('assets/'))
                                      Center(
                                        child: Text(
                                          sound.icon,
                                          style: const TextStyle(fontSize: 48),
                                        ),
                                      ),
                                    // Názov zvuku na spodku
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7),
                                            ],
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Text(
                                          sound.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black,
                                                blurRadius: 16,
                                                offset: Offset(0, 4),
                                              ),
                                              Shadow(
                                                color: Colors.black54,
                                                blurRadius: 24,
                                                offset: Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 