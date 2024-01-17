// parentGraph.dart
import 'package:flutter/material.dart';
import 'graph.dart';

class ParentGraphPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Parent Graph Page'),
        ),
        body: Center(
          child: ThingSpeakGraph(),
        ),
      ),
    );
  }
}

void main() {
  runApp(ParentGraphPage());
}