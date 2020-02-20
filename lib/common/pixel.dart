import 'package:flutter/material.dart';

class Pixel extends StatefulWidget {
  final bool isSelected;
  final bool isStart;
  final bool isEnd;
  final bool isFlag;
  final int stateValue;

  Pixel({this.isSelected, this.isStart, this.isEnd, this.isFlag, this.stateValue});

  @override
  _PixelState createState() => _PixelState();
}

class _PixelState extends State<Pixel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87,),
        color: widget.isStart
            ? Colors.blue
            : widget.isEnd
                ? Colors.green
                : widget.isSelected ? Colors.black54 : widget.stateValue == 1 ? Colors.deepOrange : widget.stateValue == 2 ? Colors.orangeAccent : Colors.white24,
      ),
    );
  }
}
