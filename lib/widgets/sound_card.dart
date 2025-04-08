import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';

class SoundCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String soundPath;

  const SoundCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.soundPath,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SoundProvider>(
      builder: (context, soundProvider, child) {
        final isPlaying = soundProvider.currentSound == soundPath && soundProvider.isPlaying;

        return GestureDetector(
          onTap: () {
            if (isPlaying) {
              soundProvider.stopSound();
            } else {
              soundProvider.playSound(soundPath);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    isPlaying ? Icons.stop_circle : Icons.play_circle,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    title,
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