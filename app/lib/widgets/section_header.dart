import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailingText});

  final String title;
  final String? trailingText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Text(title, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const Spacer(),
          if (trailingText != null)
            Text(
              trailingText!,
              style: textTheme.labelLarge?.copyWith(color: colorScheme.primary),
            ),
        ],
      ),
    );
  }
}


