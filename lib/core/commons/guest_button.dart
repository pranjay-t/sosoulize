import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';

class GuestButton extends ConsumerWidget {
  const GuestButton({super.key});

  void signInWithGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGuest(context);
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
      onPressed: () => signInWithGuest(ref, context),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Guest",
              style: TextStyle(
                  color: theme == ThemeMode.dark ? Colors.black : Colors.white,
                  fontSize: 20,
                  fontFamily: 'carter'),
            ),
            const SizedBox(width: 10,),
            Icon(
              Icons.arrow_forward_ios,
              color: theme == ThemeMode.dark
                  ? Pallete.appColorDark
                  : Pallete.appColorLight,
              size: 22,
            )
          ],
        ),
      ),
    );
  }
}
