import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sellerproof/l10n/gen/app_localizations.dart';
import 'package:sellerproof/domain/entities/app_settings.dart';
import 'package:sellerproof/presentation/providers/auth_provider.dart';
import 'package:sellerproof/providers/settings_provider.dart';
import 'package:sellerproof/presentation/theme/app_colors.dart';
import 'package:sellerproof/presentation/screens/auth/login_screen.dart';
import 'package:sellerproof/presentation/screens/settings_screen/tts_settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final l = AppLocalizations.of(context)!;
    final user = authProvider.user;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _DrawerHeader(user: user),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Language
                _DrawerExpansionItem(
                  icon: LucideIcons.globe,
                  label: l.languageSection,
                  children: [
                    _DrawerSubItem(
                      label: l.languageEnglish,
                      isActive: settingsProvider.settings.languageCode == 'en',
                      onTap: () => settingsProvider.setLanguageCode('en'),
                    ),
                    _DrawerSubItem(
                      label: l.languageRussian,
                      isActive: settingsProvider.settings.languageCode == 'ru',
                      onTap: () => settingsProvider.setLanguageCode('ru'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Communication Method
                _DrawerExpansionItem(
                  icon: LucideIcons.smartphone,
                  label: l.communicationMethod,
                  children: [
                    _DrawerSubItem(
                      label: l.voiceControlTitle,
                      isActive:
                          settingsProvider.settings.communicationMethod ==
                          CommunicationMethod.voice,
                      onTap: () => settingsProvider.setCommunicationMethod(
                        CommunicationMethod.voice,
                      ),
                    ),
                    _DrawerSubItem(
                      label: l.bluetoothButtonTitle,
                      isActive:
                          settingsProvider.settings.communicationMethod ==
                          CommunicationMethod.bluetoothButton,
                      onTap: () => settingsProvider.setCommunicationMethod(
                        CommunicationMethod.bluetoothButton,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Voice & TTS Settings
                _DrawerItem(
                  icon: LucideIcons.mic,
                  label: l.voiceSettingsTitle,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TtsSettingsScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                // Video Storage
                _DrawerItem(
                  icon: LucideIcons.video,
                  label: l.videoStorageSection,
                  onTap: () async {
                    String? selectedDirectory = await FilePicker.platform
                        .getDirectoryPath();
                    if (selectedDirectory != null && context.mounted) {
                      await context
                          .read<SettingsProvider>()
                          .setVideoStoragePath(selectedDirectory);
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: AppColors.slate100),
                ),
                // Organization Actions
                _DrawerItem(
                  icon: LucideIcons.building,
                  label: l.createOrganization,
                  onTap: () {},
                ),
                const SizedBox(height: 4),
                _DrawerItem(
                  icon: LucideIcons.userPlus,
                  label: l.inviteUser,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.slate100)),
            ),
            child: _DrawerItem(
              icon: LucideIcons.logOut,
              label: l.logout,
              isDestructive: true,
              onTap: () {
                context.read<AuthProvider>().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (r) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final dynamic user;
  const _DrawerHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      decoration: BoxDecoration(
        color: AppColors.slate50.withOpacity(0.5),
        border: const Border(bottom: BorderSide(color: AppColors.slate100)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/elephant.svg',
                    width: 32,
                    height: 32,
                    colorFilter: const ColorFilter.mode(
                      AppColors.sky600,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'SellerProof',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate900,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  LucideIcons.x,
                  size: 20,
                  color: AppColors.slate500,
                ),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.slate200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.sky600,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (user?.fullName ?? 'G').substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.fullName ?? 'Guest',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate900,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(
                          color: AppColors.slate500,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.red500 : AppColors.slate600;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDestructive ? AppColors.red500 : AppColors.slate400,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerExpansionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Widget> children;

  const _DrawerExpansionItem({
    required this.icon,
    required this.label,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        listTileTheme: const ListTileThemeData(
          dense: true,
          horizontalTitleGap: 12,
          minLeadingWidth: 0,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        leading: Icon(icon, size: 20, color: AppColors.slate400),
        title: Text(
          label,
          style: const TextStyle(
            color: AppColors.slate600,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          LucideIcons.chevronRight,
          size: 16,
          color: AppColors.slate300,
        ),
        shape: const Border(),
        collapsedShape: const Border(),
        children: children,
      ),
    );
  }
}

class _DrawerSubItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DrawerSubItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(left: 44, bottom: 2),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.sky50.withOpacity(0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.sky500 : AppColors.slate300,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.sky700 : AppColors.slate500,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
