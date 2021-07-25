import 'package:flutter/material.dart';
import 'package:size_helper/size_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileExtraLarge: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.blue,
          child: Text('mobileExtraLarge'),
        ),
        tabletLarge: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.green,
          child: Text('tabletLarge'),
        ),
        desktopSmall: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.red,
          child: Text('desktopSmall'),
        ),
        desktopNormal: (width, height) => Container(
          alignment: Alignment.center,
          color: width > 850 ? Colors.orange : Colors.yellow,
          child: Text('desktopNormal'),
        ),
      ),
    );
  }
}
