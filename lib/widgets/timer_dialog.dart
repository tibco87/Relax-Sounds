import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimerDialog extends StatelessWidget {
  const TimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a237e), // Deep blue
              Color(0xFF000051), // Darker blue
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Stars background
            Positioned.fill(
              child: CustomPaint(
                painter: StarryBackgroundPainter(),
              ),
            ),
            // Content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    l10n.setTimer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _TimerOption(
                          title: l10n.noTimer,
                          onTap: () => Navigator.pop(context, Duration.zero),
                        ),
                        _TimerOption(
                          title: l10n.custom,
                          onTap: () {
                            // TODO: Implement custom timer
                            Navigator.pop(context);
                          },
                        ),
                        _TimerOption(
                          title: '10 ${l10n.minutes}',
                          onTap: () => Navigator.pop(
                            context,
                            const Duration(minutes: 10),
                          ),
                        ),
                        _TimerOption(
                          title: '15 ${l10n.minutes}',
                          onTap: () => Navigator.pop(
                            context,
                            const Duration(minutes: 15),
                          ),
                        ),
                        _TimerOption(
                          title: '20 ${l10n.minutes}',
                          onTap: () => Navigator.pop(
                            context,
                            const Duration(minutes: 20),
                          ),
                        ),
                        _TimerOption(
                          title: '30 ${l10n.minutes}',
                          onTap: () => Navigator.pop(
                            context,
                            const Duration(minutes: 30),
                          ),
                        ),
                        _TimerOption(
                          title: '40 ${l10n.minutes}',
                          onTap: () => Navigator.pop(
                            context,
                            const Duration(minutes: 40),
                          ),
                        ),
                        _TimerOption(
                          title: '1 ${l10n.hours}',
                          onTap: () => Navigator.pop(
                            context,
                            const Duration(hours: 1),
                          ),
                        ),
                        _TimerOption(
                          title: '2 ${l10n.hours}',
                          onTap: () => Navigator.pop(
                            context,
                            const Duration(hours: 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _TimerOption({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StarryBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final random = DateTime.now().millisecondsSinceEpoch;
    
    // Create stars
    for (var i = 0; i < 50; i++) {
      final x = (random + i * 7) % size.width;
      final y = (random + i * 11) % size.height;
      final radius = ((random + i * 13) % 3 + 1).toDouble();
      
      // Star
      canvas.drawCircle(Offset(x, y), radius, paint);
      
      // Optional: Add glow effect
      final glowPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(x, y), radius * 2, glowPaint);
    }
    
    // Add some shooting stars
    for (var i = 0; i < 3; i++) {
      final startX = (random + i * 19) % size.width;
      final startY = (random + i * 23) % (size.height / 2);
      final path = Path()
        ..moveTo(startX, startY)
        ..lineTo(startX + 20, startY + 20);
      
      final shootingStarPaint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, shootingStarPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 