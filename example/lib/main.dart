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
    return _buildExampleOne(context);
  }

  Widget _buildExampleOne(BuildContext context) {
    return Scaffold(
      body: SizeHelper.of(context, printScreenInfo: true).helpBuilder(
        mobileNormal: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.greenAccent,
          child: Text('mobileNormal'),
        ),
        mobileLarge: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.green,
          child: Text('mobileLarge'),
        ),
        mobileExtraLarge: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.cyanAccent,
          child: Text('mobileExtraLarge'),
        ),
        tabletSmall: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.teal,
          child: Text('tabletSmall'),
        ),
        tabletNormal: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.blue,
          child: Text('tabletNormal'),
        ),
        tabletLarge: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.deepPurple,
          child: Text('tabletLarge'),
        ),
        tabletExtraLarge: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.pink,
          child: Text('tabletExtraLarge'),
        ),
        desktopSmall: (width, height) => Container(
          alignment: Alignment.center,
          color: Colors.red,
          child: Text('desktopSmall'),
        ),
        desktopNormal: (width, height) => Container(
          alignment: Alignment.center,
          color: height > 850 ? Colors.orange : Colors.yellow,
          child: Text('desktopNormal'),
        ),
      ),
    );
  }
}
