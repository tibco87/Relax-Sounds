import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:volume_controller/volume_controller.dart';
import '../providers/sound_provider.dart';
import '../widgets/timer_dialog.dart';

class SoundPlayerScreen extends StatefulWidget {
  final String soundName;
  final String soundKey;

  const SoundPlayerScreen({
    super.key,
    required this.soundName,
    required this.soundKey,
  });

  @override
  State<SoundPlayerScreen> createState() => _SoundPlayerScreenState();
}

class _SoundPlayerScreenState extends State<SoundPlayerScreen> {
  @override
  void initState() {
    super.initState();
    _initVolumeControl();
  }

  Future<void> _initVolumeControl() async {
    // Initialize volume control
    VolumeController().listener((volume) {
      if (mounted) {
        Provider.of<SoundProvider>(context, listen: false).setVolume(volume);
      }
    });
    
    // Get initial volume
    final volume = await VolumeController().getVolume();
    if (mounted) {
      Provider.of<SoundProvider>(context, listen: false).setVolume(volume);
    }
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final soundProvider = Provider.of<SoundProvider>(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.soundName,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer, color: Colors.white),
            onPressed: () async {
              final duration = await showDialog<Duration>(
                context: context,
                builder: (context) => const TimerDialog(),
              );
              if (duration != null) {
                await soundProvider.setTimer(duration);
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/apka1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 20), // Spacing at the top
                
                // Volume Control Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.volume,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${(soundProvider.volume * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                soundProvider.volume > 0 
                                  ? soundProvider.volume > 0.5
                                    ? Icons.volume_up
                                    : Icons.volume_down
                                  : Icons.volume_off,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                          overlayColor: Colors.white.withOpacity(0.12),
                          trackHeight: 4.0,
                        ),
                        child: Slider(
                          value: soundProvider.volume,
                          onChanged: (value) {
                            soundProvider.setVolume(value);
                            VolumeController().setVolume(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(), // Push controls to the bottom
                
                // Control Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _GlassButton(
                      size: 80,
                      onPressed: () {
                        soundProvider.toggleLoop();
                      },
                      child: Icon(
                        soundProvider.isLooping ? Icons.repeat_one : Icons.waves,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    // Play Button
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        iconSize: 64,
                        icon: Icon(
                          soundProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          soundProvider.togglePlay();
                        },
                      ),
                    ),
                    _GlassButton(
                      size: 80,
                      onPressed: () {
                        soundProvider.toggleFavorite(widget.soundKey);
                      },
                      child: Icon(
                        soundProvider.isFavorite(widget.soundKey) 
                          ? Icons.favorite 
                          : Icons.favorite_border,
                        color: soundProvider.isFavorite(widget.soundKey)
                          ? Colors.red
                          : Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final double size;
  final VoidCallback onPressed;
  final Widget child;

  const _GlassButton({
    required this.size,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(size / 4),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
} 