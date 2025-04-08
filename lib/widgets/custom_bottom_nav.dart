import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.music_note),
                activeIcon: const Icon(Icons.music_note, color: Colors.white),
                label: l10n.sounds,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.tune),
                activeIcon: const Icon(Icons.tune, color: Colors.white),
                label: l10n.custom,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                activeIcon: const Icon(Icons.settings, color: Colors.white),
                label: l10n.settings,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 