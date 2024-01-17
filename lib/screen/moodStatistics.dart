import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodStats extends StatefulWidget {
  const MoodStats({Key? key}) : super(key: key);

  @override
  State<MoodStats> createState() => _MoodStatsState();
}

class _MoodStatsState extends State<MoodStats> {
  List<String>? triggers;
  List<double>? triggerPercentages;
  List<String>? behaviors;
  List<double>? behaviorPercentages;
  bool isTriggerChart = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    fetchTriggerData();
    fetchBehaviorData();
  }

  Future<void> fetchTriggerData() async {
    try {
      if (_user != null) {
        QuerySnapshot triggerQuery = await FirebaseFirestore.instance
            .collection('mood')
            .where('userId', isEqualTo: _user!.uid)
            .get();

        List<String> allTriggers =
        triggerQuery.docs.map((doc) => doc['trigger'] as String).toList();

        Map<String, int> triggerCount = {};
        allTriggers.forEach((trigger) {
          triggerCount[trigger] = (triggerCount[trigger] ?? 0) + 1;
        });

        List<String> uniqueTriggers = triggerCount.keys.toList();
        List<double> percentages = uniqueTriggers.map((trigger) {
          int count = triggerCount[trigger] ?? 0;
          return count / allTriggers.length * 70.0;
        }).toList();

        setState(() {
          triggers = uniqueTriggers;
          triggerPercentages = percentages;
        });
      }
    } catch (e) {
      print("Error fetching trigger data: $e");
    }
  }

  Future<void> fetchBehaviorData() async {
    try {
      if (_user != null) {
        QuerySnapshot behaviorQuery = await FirebaseFirestore.instance
            .collection('mood')
            .where('userId', isEqualTo: _user!.uid)
            .get();

        List<String> allBehaviors =
        behaviorQuery.docs.map((doc) => doc['behavior'] as String).toList();

        Map<String, int> behaviorCount = {};
        allBehaviors.forEach((behavior) {
          behaviorCount[behavior] = (behaviorCount[behavior] ?? 0) + 1;
        });

        List<String> uniqueBehaviors = behaviorCount.keys.toList();
        List<double> percentages = uniqueBehaviors.map((behavior) {
          int count = behaviorCount[behavior] ?? 0;
          return count / allBehaviors.length * 70.0;
        }).toList();

        setState(() {
          behaviors = uniqueBehaviors;
          behaviorPercentages = percentages;
        });
      }
    } catch (e) {
      print("Error fetching behavior data: $e");
    }
  }

  String generateTriggerSummary() {
    if (triggers == null || triggerPercentages == null) {
      return 'Loading trigger data...';
    } else if (triggers!.isEmpty || triggerPercentages!.isEmpty) {
      return 'No trigger data available for the current user.';
    } else {
      int maxIndex = triggerPercentages!.indexOf(
        triggerPercentages!.reduce((curr, next) => curr > next ? curr : next),
      );
      int minIndex = triggerPercentages!.indexOf(
        triggerPercentages!.reduce((curr, next) => curr < next ? curr : next),
      );

      String mostCommonTrigger = triggers![maxIndex];
      String leastCommonTrigger = triggers![minIndex];

      double averagePercentage =
          triggerPercentages!.reduce((value, element) => value + element) /
              triggerPercentages!.length;

      return '🚀 Let\'s dive into your mood trigger insights! Here\'s a thrilling summary:\n\n' +
          '🌟 Most common trigger: $mostCommonTrigger (${triggerPercentages![maxIndex].toStringAsFixed(2)}%)\n' +
          '📉 Least common trigger: $leastCommonTrigger (${triggerPercentages![minIndex].toStringAsFixed(2)}%)\n' +
          '📊 Average percentage: ${averagePercentage.toStringAsFixed(2)}%\n\n' +
          '🍰 Pie Chart Extravaganza:\n' +
          'Behold the mesmerizing pie chart below, showcasing the distribution of triggers recorded for your mood entries. Each slice represents a trigger, and the size reflects the percentage of times that trigger occurred. Let the data feast begin!';
    }
  }

  String generateBehaviorSummary() {
    if (behaviors == null || behaviorPercentages == null) {
      return 'Loading behavior data...';
    } else if (behaviors!.isEmpty || behaviorPercentages!.isEmpty) {
      return 'No behavior data available for the current user.';
    } else {
      int maxIndex = behaviorPercentages!.indexOf(
        behaviorPercentages!.reduce((curr, next) => curr > next ? curr : next),
      );
      int minIndex = behaviorPercentages!.indexOf(
        behaviorPercentages!.reduce((curr, next) => curr < next ? curr : next),
      );

      String mostCommonBehavior = behaviors![maxIndex];
      String leastCommonBehavior = behaviors![minIndex];

      double averagePercentage =
          behaviorPercentages!.reduce((value, element) => value + element) /
              behaviorPercentages!.length;

      return '🚀 Let\'s dive into your mood behavior insights! Here\'s a thrilling summary:\n\n' +
          '🌟 Most common behavior: $mostCommonBehavior (${behaviorPercentages![maxIndex].toStringAsFixed(2)}%)\n' +
          '📉 Least common behavior: $leastCommonBehavior (${behaviorPercentages![minIndex].toStringAsFixed(2)}%)\n' +
          '📊 Average percentage: ${averagePercentage.toStringAsFixed(2)}%\n\n' +
          '🍰 Pie Chart Extravaganza:\n' +
          'Behold the mesmerizing pie chart below, showcasing the distribution of behaviors recorded for your mood entries. Each slice represents a behavior, and the size reflects the percentage of times that behavior occurred. Let the data feast begin!';
    }
  }

  Widget buildSummaryButtonBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              isTriggerChart = true;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: isTriggerChart ? Colors.blue : Colors.grey,
          ),
          child: Text('Trigger Analysis'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isTriggerChart = false;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: !isTriggerChart ? Colors.blue : Colors.grey,
          ),
          child: Text('Behavior Analysis'),
        ),
      ],
    );
  }

  Widget buildSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.lightGreen[50],
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              isTriggerChart ? 'Exciting Trigger Stats' : 'Exciting Behavior Stats',
              style: GoogleFonts.poppins(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              isTriggerChart ? generateTriggerSummary() : generateBehaviorSummary(),
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget buildPieChart() {
    return isTriggerChart
        ? buildTriggerPieChart()
        : buildBehaviorPieChart();
  }

  Widget buildTriggerPieChart() {
    return triggers == null || triggerPercentages == null
        ? Center(
      child: CircularProgressIndicator(),
    )
        : triggers!.isNotEmpty && triggerPercentages!.isNotEmpty
        ? Container(
      height: 300, // Set a fixed height
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              // Handle touch interactions here
            },
          ),
          sections: showingTriggerSections(),
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 10,
          sectionsSpace: 4,
        ),
      ),
    )
        : Center(
      child: Text(
        'No trigger data available for the current user.',
        style: GoogleFonts.poppins(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildBehaviorPieChart() {
    return behaviors == null || behaviorPercentages == null
        ? Center(
      child: CircularProgressIndicator(),
    )
        : behaviors!.isNotEmpty && behaviorPercentages!.isNotEmpty
        ? Container(
      height: 300, // Set a fixed height
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              // Handle touch interactions here
            },
          ),
          sections: showingBehaviorSections(),
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 10,
          sectionsSpace: 4,
        ),
      ),
    )
        : Center(
      child: Text(
        'No behavior data available for the current user.',
        style: GoogleFonts.poppins(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<PieChartSectionData> showingTriggerSections() {
    return showingSections(triggers, triggerPercentages);
  }

  List<PieChartSectionData> showingBehaviorSections() {
    return showingSections(behaviors, behaviorPercentages);
  }

  List<PieChartSectionData> showingSections(
      List<String>? data, List<double>? percentages) {
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
      Colors.deepOrange,
      Colors.amber,
    ];

    List<PieChartSectionData> sections = [];

    if (data != null && percentages != null) {
      for (int i = 0; i < data.length; i++) {
        List<String> words = data[i].split(" ");
        String title = words.join('\n');

        sections.add(
          PieChartSectionData(
            color: colors[i % colors.length],
            title: '$title:\n${percentages[i].toStringAsFixed(2)}%',
            titleStyle: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black,
            ),
            value: percentages[i],
            radius: 150,
            showTitle: true,
            titlePositionPercentageOffset: 0.5,
          ),
        );
      }
    }
    return sections;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[200],
        title: Center(
          child: Text(
            'Mood Statistics',
            style: GoogleFonts.poppins(
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              buildSummaryButtonBar(),
              buildSummary(),
              buildPieChart(),
            ],
          ),
        ),
      ),
    );
  }
}