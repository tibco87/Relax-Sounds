import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/sound_category.dart';
import '../screens/category_sounds_screen.dart';

class SoundGrid extends StatelessWidget {
  const SoundGrid({super.key});

  String _getImagePath(String categoryKey) {
    switch (categoryKey) {
      case 'nature':
        return 'assets/images/priroda.jpg';
      case 'animals':
        return 'assets/images/zvierata.jpg';
      case 'transport':
        return 'assets/images/doprava.jpg';
      case 'city':
        return 'assets/images/mesto.jpg';
      case 'meditation':
        return 'assets/images/meditacia.jpg';
      case 'romance':
        return 'assets/images/romantika.jpg';
      case 'weather':
        return 'assets/images/pocasie.jpg';
      case 'noise':
        return 'assets/images/farby.jpg';
      case 'home':
        return 'assets/images/domov.jpg';
      case 'motivation':
        return 'assets/images/motivacia.jpg';
      case 'instruments':
        return 'assets/images/nastroje.jpg';
      case 'focus':
        return 'assets/images/sustredenie.jpg';
      case 'colors':
        return 'assets/images/farby.jpg';
      default:
        return 'assets/images/priroda.jpg';
    }
  }

  List<SoundCategory> _getCategories(AppLocalizations l10n) {
    return [
      SoundCategory(
        key: 'nature',
        name: l10n.nature,
        icon: '🌿',
      ),
      SoundCategory(
        key: 'animals',
        name: l10n.animals,
        icon: '🐾',
      ),
      SoundCategory(
        key: 'romance',
        name: l10n.romance,
        icon: '💕',
      ),
      SoundCategory(
        key: 'home',
        name: l10n.home,
        icon: '🏠',
      ),
      SoundCategory(
        key: 'city',
        name: l10n.city,
        icon: '🏙️',
      ),
      SoundCategory(
        key: 'weather',
        name: l10n.weather,
        icon: '⛅',
      ),
      SoundCategory(
        key: 'motivation',
        name: l10n.motivation,
        icon: '💪',
      ),
      SoundCategory(
        key: 'focus',
        name: l10n.focus,
        icon: '🎯',
      ),
      SoundCategory(
        key: 'transport',
        name: l10n.transport,
        icon: '🚗',
      ),
      SoundCategory(
        key: 'instruments',
        name: l10n.instruments,
        icon: '🎵',
      ),
      SoundCategory(
        key: 'colors',
        name: l10n.colors,
        icon: '🎨',
      ),
      SoundCategory(
        key: 'meditation',
        name: l10n.meditation,
        icon: '🧘',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = _getCategories(l10n);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategorySoundsScreen(
                  category: category,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withOpacity(0.1),
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
              image: DecorationImage(
                image: AssetImage(_getImagePath(category.key)),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 