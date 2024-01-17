import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter_new/flutter.dart' as charts;

import '../bottomNavigationMenu.dart';
import '../constants/constants.dart';

class ThingSpeakGraph extends StatefulWidget {
  @override
  _ThingSpeakGraphState createState() => _ThingSpeakGraphState();
}

class _ThingSpeakGraphState extends State<ThingSpeakGraph> {
  List<int> _dataPoints = [];
  int _selectedField = 1; // Default to field1

  // Map to store field number to corresponding label
  final Map<int, String> fieldLabels = {
    1: 'Light Level',
    2: 'Temperature',
    3: 'Sound Level' ,
    4: 'Movement Trigger',
    5: 'Distance Trigger',
    // Add more field labels as needed
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String apiUrl =
        'https://api.thingspeak.com/channels/2376453/feeds.json?results=10';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> feeds = data['feeds'];

      setState(() {
        _dataPoints = feeds
            .map<int>((feed) => int.parse(feed['field$_selectedField']))
            .toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series<int, int>(
        id: 'ThingSpeakData',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (value, index) => index ?? 0,
        measureFn: (value, _) => value ?? 0,
        data: _dataPoints,
      ),
    ];

    var chart = charts.LineChart(
      series,
      animate: true,
      behaviors: [
        charts.ChartTitle(
          'Date',
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
        charts.ChartTitle(
          fieldLabels[_selectedField] ?? 'Y-Axis Label',
          behaviorPosition: charts.BehaviorPosition.start,
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('Graph'),
        backgroundColor: AutiTrackColor2, // Change background color
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 2), // Adjust the top padding as needed
            alignment: Alignment.center,
            child: DropdownButton<int>(
              value: _selectedField,
              onChanged: (value) {
                setState(() {
                  _selectedField = value!;
                  fetchData();
                });
              },
              items: List.generate(5, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${fieldLabels[index + 1]} Graph'),
                );
              }),
            ),
          ),

          Center(

            child: Container(
              padding: EdgeInsets.only(top: 40),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
              child: chart,
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationMenu(
        selectedIndex: 2,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/mainScreen');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/message');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/activity');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/feedParent');
          }
        },
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: ThingSpeakGraph(),
    ),
  );
}