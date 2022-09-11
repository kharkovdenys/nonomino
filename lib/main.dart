import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'sudoku.dart';

bool isStart = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('uk')],
        path: 'assets/locales',
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Widget splash = SplashScreenView(
      navigateRoute: const HomeScreen(),
      duration: 5000,
      imageSize: 130,
      imageSrc: "assets/images/nonomino.png",
      text: "Nonomino Sudoku",
      textType: TextType.TyperAnimatedText,
      textStyle: const TextStyle(
        fontSize: 40.0,
      ),
      backgroundColor: const Color(0xFFFFFFFF),
    );
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Nonomino Sudoku',
      home: splash,
      routes: {'/game': (context) => const GameScreen()},
      theme: ThemeData(fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    getLocale() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String locate = (prefs.getString('locate') ?? 'en');
      WidgetsBinding.instance
          .addPostFrameCallback((_) => context.setLocale(locate.toLocale()));
      setState(() {});
    }

    if (!isStart) {
      getLocale();
      isStart = true;
    }
    getRecords() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int timeEasy = (prefs.getInt('timeEasy') ?? -1);
      String records = '';
      timeEasy != -1
          ? records +=
              '${tr('easy')}\n${tr('time')} ${((timeEasy / 60).truncate()).toString().padLeft(2, '0')}:${(timeEasy % 60).toString().padLeft(2, '0')}\n'
          : records += '${tr('easy')}\n${tr('noRecord')}\n';
      int timeMedium = (prefs.getInt('timeMedium') ?? -1);
      timeMedium != -1
          ? records +=
              '${tr('medium')}\n${tr('time')} ${((timeMedium / 60).truncate()).toString().padLeft(2, '0')}:${(timeMedium % 60).toString().padLeft(2, '0')}\n'
          : records += '${tr('medium')}\n${tr('noRecord')}\n';
      int timeHard = (prefs.getInt('timeHard') ?? -1);
      timeHard != -1
          ? records +=
              '${tr('hard')}\n${tr('time')} ${((timeHard / 60).truncate()).toString().padLeft(2, '0')}:${(timeHard % 60).toString().padLeft(2, '0')}\n'
          : records += '${tr('hard')}\n${tr('noRecord')}\n';
      int timeExpert = (prefs.getInt('timeExpert') ?? -1);
      timeExpert != -1
          ? records +=
              '${tr('expert')}\n${tr('time')} ${((timeExpert / 60).truncate()).toString().padLeft(2, '0')}:${(timeExpert % 60).toString().padLeft(2, '0')}\n'
          : records += '${tr('expert')}\n${tr('noRecord')}\n';
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Center(child: Text(tr('Records'), style: txtstyle)),
              content: Center(child: Text(records, style: txtstyle)),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(tr('Close')),
                ),
              ],
            );
          });
    }

    settingsSudoku() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String locate = (prefs.getString('locate') ?? 'en');
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: Center(child: Text(tr('Settings'), style: txtstyle)),
                content: Center(
                    child: Row(children: [
                  Text(tr('Localization selection')),
                  DropdownButton<String>(
                    value: locate,
                    items: <String>['en', 'uk']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        locate = value!;
                      });
                    },
                  )
                ])),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(tr('Close')),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await prefs.setString('locate', locate);
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => context.setLocale(locate.toLocale()));
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => Navigator.pop(context));
                    },
                    child: Text(tr('Save')),
                  ),
                ],
              );
            });
          });
    }

    return Container(
        color: const Color(0xFFFFFFFF),
        child: SimpleDialog(
          title: Center(child: Text(tr('choice'))),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                typegame = 0;
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Center(child: Text(tr('easy'), style: txtstyle)),
            ),
            SimpleDialogOption(
              onPressed: () {
                typegame = 1;
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Center(child: Text(tr('medium'), style: txtstyle)),
            ),
            SimpleDialogOption(
              onPressed: () {
                typegame = 2;
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Center(child: Text(tr('hard'), style: txtstyle)),
            ),
            SimpleDialogOption(
              onPressed: () {
                typegame = 3;
                Navigator.pushReplacementNamed(context, '/game');
              },
              child: Center(child: Text(tr('expert'), style: txtstyle)),
            ),
            SimpleDialogOption(
              onPressed: () {
                getRecords();
              },
              child: Center(child: Text(tr('Records'), style: txtstyle)),
            ),
            SimpleDialogOption(
              onPressed: () {
                settingsSudoku();
              },
              child: Center(child: Text(tr('Settings'), style: txtstyle)),
            ),
          ],
        ));
  }
}
