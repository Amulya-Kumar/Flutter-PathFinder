import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pathfinding_app/algorithms/a_star.dart';
import 'package:pathfinding_app/algorithms/dijkstra.dart';
import 'package:pathfinding_app/common/pair.dart';
import 'package:pathfinding_app/common/pixel.dart';
import 'package:pathfinding_app/utils/restart_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestartWidget(
      child: MaterialApp(
        title: 'Flutter Path Finder',
        home: MyHomePage(title: 'Flutter Path Finder'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

int _width = 37 * 30;
int _height = 18 * 30 - 50;
var grid = new List.generate(
    (_height ~/ 30).toInt(),
    (_) =>
        new List<bool>.filled((_width ~/ 30).toInt(), false, growable: true));
var gridState = new List.generate((_height ~/ 30).toInt(),
    (_) => new List<int>.filled((_width ~/ 30).toInt(), 0, growable: true));
var pixelGrid = new List<List<Pixel>>.generate(
    (_height ~/ 30).toInt(), (_) => new List<Pixel>((_width ~/ 30).toInt()));

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < (_height ~/ 30).toInt(); i++) {
      for (int j = 0; j < (_width ~/ 30).toInt(); j++) {
        Pixel tempPixel = new Pixel(
          isStart: (i == 4 && j == 4) ? true : false,
          isSelected:
              (i == 4 && j == 4) || (i == 4 && j == 30) ? true : grid[i][j],
          isEnd: (i == 4 && j == 30) ? true : false,
          isFlag: false,
          stateValue: gridState[i][j],
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

    void drawReachedNodes(List<List<int>> orderedClosedList) {
      for (int i = 0; i < (_height ~/ 30).toInt(); i++) {
        for (int j = 0; j < (_width ~/ 30).toInt(); j++) {
          if (gridState[i][j] == 2) {
            setState(() {
              gridState[i][j] = 0;
            });
          }
        }
      }
      for(int counter = 1; counter < ((_height ~/ 30).toInt()*(_width ~/ 30).toInt()); counter++){
        for (int i = 0; i < (_height ~/ 30).toInt(); i++) {
          for (int j = 0; j < (_width ~/ 30).toInt(); j++) {
            if(orderedClosedList[i][j] == counter){
              Timer(const Duration(milliseconds: 300), () {
                setState(() {
                  gridState[i][j] = 2;
                });
              });
            }
          }
        }
      }      
    }

    void drawPathOnGrid(List<Pair> path) {
      for (int i = 0; i < (_height ~/ 30).toInt(); i++) {
        for (int j = 0; j < (_width ~/ 30).toInt(); j++) {
          if (gridState[i][j] == 1) {
            setState(() {
              gridState[i][j] = 0;
            });
          }
        }
      }
      for (var p in path) {
        Timer(const Duration(milliseconds: 300), () {
          setState(() {
            gridState[p.xCord][p.yCord] = 1;
          });
        });
      }
    }

    void doAStarSearch() {
      var src = new Pair(); // Creating Object
      src.setValue(4, 4);

      var dest = new Pair(); // Creating Object
      dest.setValue(4, 30);
      Pair resultPair = new Pair();
      resultPair = aStarSearch(grid, src, dest);
      drawReachedNodes(resultPair.yCord);
      drawPathOnGrid(resultPair.xCord);
    }

    void refreshState() {
      for (int i = 0; i < (_height ~/ 30).toInt(); i++) {
        for (int j = 0; j < (_width ~/ 30).toInt(); j++) {
          setState(() {
            gridState[i][j] = 0;
          });
        }
      }
      for (int i = 0; i < (_height ~/ 30).toInt(); i++) {
        for (int j = 0; j < (_width ~/ 30).toInt(); j++) {
          setState(() {
            grid[i][j] = false;
          });
        }
      }
      RestartWidget.restartApp(context);
    }

    void doDijkstraSearch() {
      var src = new Pair(); // Creating Object
      src.setValue(4, 4);

      var dest = new Pair(); // Creating Object
      dest.setValue(4, 30);
      Pair resultPair = new Pair();
      resultPair = dijkstraSearch(grid, src, dest);
      drawReachedNodes(resultPair.yCord);
      drawPathOnGrid(resultPair.xCord);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text("Flutter Pathfinder".toUpperCase()),
        titleSpacing: 10.0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: refreshState),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.white,
              onPressed: () {
                doAStarSearch();
              },
              child: Text("Visualise A*"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.white,
              onPressed: () {
                doDijkstraSearch();
              },
              child: Text("Visualise Dijkstra"),
            ),
          ),
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
