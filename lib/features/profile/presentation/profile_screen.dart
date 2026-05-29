import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../settings/domain/settings_state.dart';
import '../../settings/presentation/settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myProfile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () =>
                      _showImageSourceSheet(context, ref, l10n),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage:
                            _resolveImage(authState.photoUrl),
                        child: authState.photoUrl == null
                            ? Icon(Icons.person,
                                size: 52,
                                color: colorScheme.onPrimaryContainer)
                            : null,
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: colorScheme.primary,
                        child: Icon(Icons.camera_alt,
                            size: 16, color: colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  authState.displayName ?? 'FoodHub User',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (authState.email != null) ...[
                  const SizedBox(height: 4),
                  Text(authState.email!,
                      style:
                          TextStyle(color: colorScheme.onSurfaceVariant)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),
          _SectionTitle(l10n.settings),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.language),
                  trailing: _LanguageDropdown(
                      settings: settings, ref: ref, l10n: l10n),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: Text(l10n.darkTheme),
                  value: settings.themeMode == ThemeMode.dark,
                  onChanged: (v) {
                    ref.read(settingsProvider.notifier).setThemeMode(
                          v ? ThemeMode.dark : ThemeMode.light,
                        );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => ref.read(authProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
            label: Text(l10n.signOut),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.error,
              side: BorderSide(color: colorScheme.error),
              minimumSize: const Size(double.infinity, 52),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _resolveImage(String? photoUrl) {
    if (photoUrl == null) return null;
    if (photoUrl.startsWith('http')) return NetworkImage(photoUrl);
    try {
      return FileImage(File(photoUrl));
    } catch (_) {
      return null;
    }
  }

  void _showImageSourceSheet(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l10n.takePhoto),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(context, ref, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.chooseFromGallery),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(context, ref, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(
      BuildContext context, WidgetRef ref, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 512,
      );
      if (image != null) {
        await ref.read(authProvider.notifier).updatePhotoUrl(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  final SettingsState settings;
  final WidgetRef ref;
  final AppLocalizations l10n;

  const _LanguageDropdown(
      {required this.settings, required this.ref, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: settings.locale.languageCode,
      underline: const SizedBox(),
      items: [
        DropdownMenuItem(value: 'uk', child: Text(l10n.ukrainian)),
        DropdownMenuItem(value: 'en', child: Text(l10n.english)),
        DropdownMenuItem(value: 'pl', child: Text(l10n.polish)),
      ],
      onChanged: (code) {
        if (code != null) {
          ref.read(settingsProvider.notifier).setLocale(Locale(code));
        }
      },
    );
  }
}
