import 'package:flutter/material.dart';
import 'package:pathfinding_app/algorithms/a_star.dart';
import 'package:pathfinding_app/common/pair.dart';
import 'package:pathfinding_app/common/pixel.dart';
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

void _djikstraAlgorithm(Pixel start) {}

int _width = 37*30;
int _height = 25*30 - 50;
var grid = new List.generate((_height~/30).toInt(), (_) => new List<bool>.filled((_width~/ 30).toInt(), false, growable: true));
var pixelGrid = new List<List<Pixel>>.generate((_height ~/ 30).toInt(), (_) => new List<Pixel>((_width ~/ 30).toInt()));

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < (_height~/ 30).toInt(); i++) {
      for (int j = 0; j < (_width~/ 30).toInt(); j++) {
        Pixel tempPixel = new Pixel(
          isStart: (i == 4 && j == 4) ? true : false,
          isSelected: (i == 4 && j == 4) || (i == 4 && j == 30) ? true : grid[i][j],
          isEnd: (i == 4 && j == 30) ? true : false,
          isFlag: false,
        );
        pixelGrid[i][j] = tempPixel;
      }
    }

    Widget _buildPixelGridItems(BuildContext context, int index) {
      int x, y = 0;
      x = (index / (_width ~/ 30).toInt()).floor();
      y = (index % (_width ~/ 30).toInt()).floor();
      return GestureDetector(
        onTap: () {
          setState(() {
            grid[x][y] = !grid[x][y];
          });
        },
        child: GridTile(child: pixelGrid[x][y]),
      );
    }

    void drawPathOnGrid(List<Pair> path){
      for(var p in path){
        setState(() {
          grid[p.xCord][p.yCord] = true;
        });
      }
    }

    void doAStarSearch(){
      var src = new Pair(); // Creating Object
      src.setValue(4, 4);

      var dest = new Pair(); // Creating Object
      dest.setValue(4, 30);
      List<Pair> path = new List<Pair>();
      path = aStarSearch(grid, src, dest);
      drawPathOnGrid(path);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,   
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
              color: Colors.white, onPressed: () {
                doAStarSearch();
              }, child: Text("Visualise"))
        ],
      ),
      body: Center(
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (_width ~/ 30).toInt(),
          ),
          padding: const EdgeInsets.only(left: 2, right: 2, top: 4),
          itemBuilder: _buildPixelGridItems,
          itemCount: (_width ~/ 30).toInt() * (_height ~/ 30).toInt(),
        ),
      ),
    );
  }
}
