import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Resposive/responsive.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/guest_button.dart';
import 'package:sosoulize/core/commons/loader.dart';
import 'package:sosoulize/core/commons/sign_in_buttons.dart';
import 'package:sosoulize/core/constants/constants.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return Scaffold(
      backgroundColor: theme == ThemeMode.dark
          ? Pallete.appColorDark
          : Pallete.appColorLight,
      body: Center(
        child: SingleChildScrollView(
          child: Responsive(
            child: Container(
              height: 600,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: isLoading
                  ? const Loader()
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: theme == ThemeMode.dark
                          ? const Color.fromARGB(255, 37, 37, 37)
                          : const Color.fromARGB(255, 240, 230, 230),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Let's Go !",
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'carter',
                              color: theme == ThemeMode.dark
                                  ? Pallete.appColorDark
                                  : Pallete.appColorLight,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            Constants.loginEmotePath,
                            height: 200,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Every soul deserves a community.",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'carter',
                              color: theme == ThemeMode.dark
                                  ? Pallete.appColorDark
                                  : Pallete.appColorLight,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Responsive(child: SignInButtons()),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                              fontFamily: 'carter',
                              fontSize: 18,
                              color: theme == ThemeMode.dark
                                  ? Pallete.appColorDark
                                  : Pallete.appColorLight,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Responsive(child: GuestButton()),
                        ]),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
