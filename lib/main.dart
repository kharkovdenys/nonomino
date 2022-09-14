import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nonomino/views/screens/game.dart';
import 'package:nonomino/views/screens/splash.dart';
import 'package:nonomino/views/widgets/menu.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  await EasyLocalization.ensureInitialized();
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setFullScreen(true);
    });
  }
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('uk')],
        path: 'assets/locales',
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Nonomino Sudoku',
      home: const SplashScreen(navigateRoute: Menu()),
      routes: {'/game': (context) => const GameScreen()},
      theme: ThemeData(fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
    );
  }
}
