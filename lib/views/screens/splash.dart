import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget navigateRoute;
  const SplashScreen({Key? key, required this.navigateRoute}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/images/nonomino.png", height: 130),
            const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Nonomino Sudoku",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => widget.navigateRoute)));
  }
}
