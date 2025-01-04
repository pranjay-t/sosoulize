import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Theme/pallete.dart';

class ProfileButtons extends ConsumerWidget {
  final String label;
  final void Function() onPressed;
  const ProfileButtons({super.key,required this.label,required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 16),
      child: OutlinedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme == ThemeMode.dark
              ? Pallete.appColorDark
              : Pallete.appColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'carter',
            color: theme == ThemeMode.dark ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
