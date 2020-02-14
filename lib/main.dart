import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Path Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Path Finder'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    int _width = MediaQuery.of(context).size.width.round();
    int _height = MediaQuery.of(context).size.height.round() - 50;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: (_width/30).round(),
          padding: const EdgeInsets.only(left: 2, right: 2, top: 4),
          children: List.generate(
            (_width/30).round() * (_height/30).round(),
            (i) => InkWell(
              onTap: (){},
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: i == 100 ? Colors.red : i == 130 ? Colors.green : Colors.white24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
