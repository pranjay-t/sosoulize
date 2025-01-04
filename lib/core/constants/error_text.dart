import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Theme/pallete.dart';

class ErrorText extends ConsumerWidget {
  final String error;
  const ErrorText({super.key, required this.error});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currTheme = ref.watch(themeNotifierProvider);
    return Center(
      child: Text(
        error,
        style: TextStyle(
          fontFamily: 'carter',
          fontSize: 20,
          color: currTheme == Pallete.darkModeAppTheme
              ? Pallete.appColorDark
              : Pallete.appColorLight,
        ),
      ),
    );
  }
}
