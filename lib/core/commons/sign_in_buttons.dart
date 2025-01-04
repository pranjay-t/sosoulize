import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/constants/constants.dart';

class SignInButtons extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButtons({super.key, this.isFromLogin = true});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme == ThemeMode.dark
                                ? Pallete.appColorDark
                                : Pallete.appColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => signInWithGoogle(context, ref),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Constants.googlePath,
              height: 40,
            ),
            const SizedBox(width: 10,),
            Text(
              "Continue with Google",
              style: TextStyle(
                  color:theme == ThemeMode.dark ? Colors.black : Colors.white,
                  fontSize: 18,
                  fontFamily: 'carter'),
            ),
          ],
        ),
      ),
    );
  }
}
