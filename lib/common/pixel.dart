import 'package:flutter/material.dart';

class Pixel extends StatefulWidget {
  bool isSelected;
  final bool isStart;
  final bool isEnd;
  final bool isFlag;

  Pixel({this.isSelected, this.isStart, this.isEnd, this.isFlag});

  @override
  _PixelState createState() => _PixelState();
}

class _PixelState extends State<Pixel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: widget.isStart
            ? Colors.red
            : widget.isEnd
                ? Colors.green
                : widget.isSelected ? Colors.black54 : Colors.white24,
      ),
    );
  }
}
