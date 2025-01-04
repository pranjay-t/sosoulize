import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Features/auths/controller/auth_controller.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:sosoulize/core/commons/loader.dart';
import 'package:sosoulize/core/constants/error_text.dart';
import 'package:sosoulize/firebase_options.dart';
import 'package:sosoulize/models/user_models.dart';
import 'package:sosoulize/route.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModels? userModels ;

  void getData(WidgetRef ref,User data) async{
    userModels = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.watch(userProvider.notifier).update((state) => userModels);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
      data: (data) => MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SoSoulize',
      theme: ref.watch(themeNotifierProvider),
      themeMode: ref.watch(themeNotifierProvider.notifier).mode,
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        if(data!=null) {
          getData(ref,data);
          if(userModels != null) return loggedInRoute;
        }
        return loggedOutRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    ), error: (error,stackTrace) => ErrorText(error: error.toString()), loading:() => const Loader()) ;
  }
}
