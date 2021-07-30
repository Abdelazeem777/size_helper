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
    return _buildExample2(context);
    //_buildExample1(context);
  }

  Widget _buildExample1(BuildContext context) {
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

  Widget _buildExample2(BuildContext context) {
    final dataList = List.generate(15, (index) => 'Card ${index + 1}');
    final cardsList = dataList.map((e) => CardWidget(text: e)).toList();
    return Scaffold(
      body: context.sizeHelperBuilder(
        mobileExtraLarge: (_, __) => SingleChildScrollView(
            child: Column(
          children: cardsList,
        )),
        tabletLarge: (_, __) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: cardsList,
            )),
        desktopSmall: (_, __) => Wrap(
          children: cardsList,
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 200,
      margin: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0, color: Colors.green),
      ),
    );
  }
}
