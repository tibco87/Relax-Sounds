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

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Text(
            l10n.settings,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 8),
            _buildSettingsItem(
              title: l10n.premium,
              icon: Icons.star,
              onTap: () {
                // TODO: Implement premium purchase
              },
            ),
            _buildSettingsItem(
              title: l10n.restorePurchases,
              icon: Icons.restore,
              onTap: () {
                // TODO: Implement restore purchases
              },
            ),
            _buildSettingsItem(
              title: l10n.rateApp,
              icon: Icons.rate_review,
              onTap: () {
                // TODO: Open app store rating
              },
            ),
            _buildSettingsItem(
              title: l10n.shareApp,
              icon: Icons.share,
              onTap: () {
                // TODO: Implement share functionality
              },
            ),
            _buildSettingsItem(
              title: l10n.feedback,
              icon: Icons.feedback,
              onTap: () {
                // TODO: Open feedback form
              },
            ),
            _buildSettingsItem(
              title: l10n.privacyPolicy,
              icon: Icons.privacy_tip,
              onTap: () {
                // TODO: Open privacy policy
              },
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
            const SizedBox(height: 24),
          ]),
        ),
      ],
    );
  }
} 