import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';

/// Visual group label for settings and long forms.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    required this.title,
    required this.children,
    super.key,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PremiumSectionHeader(title: title, subtitle: subtitle),
        ...children,
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
