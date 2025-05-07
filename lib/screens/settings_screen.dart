import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _buildSettingsItem({
    required String title,
    required IconData icon,
    required VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 0.5,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Icon(
                icon,
                color: Colors.white,
                size: 26,
              ),
              trailing: trailing,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                l10n!.settings,
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
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                children: [
                  _buildSettingsItem(
                    title: l10n.premium,
                    icon: Icons.star,
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    title: l10n.restorePurchases,
                    icon: Icons.restore,
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    title: l10n.rateApp,
                    icon: Icons.rate_review,
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    title: l10n.shareApp,
                    icon: Icons.share,
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    title: l10n.feedback,
                    icon: Icons.feedback,
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    title: l10n.privacyPolicy,
                    icon: Icons.privacy_tip,
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    title: l10n.appVersion,
                    icon: Icons.info,
                    onTap: null,
                    trailing: const Text(
                      '1.0.0',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 