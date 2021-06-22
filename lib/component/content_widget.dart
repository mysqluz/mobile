import 'package:flutter/material.dart';


class ContentWidget extends StatelessWidget {
  final Widget myWidget;
  final Color color;
  ContentWidget({@required this.myWidget, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 1000.0,
      color: color,
      child: myWidget
    );
  }
}