import 'package:flutter/material.dart';
import '../bottomNavigationMenu.dart';
import '../util/my_tab.dart';
import '../Tab/angerTab.dart';
import '../Tab/anxietyTab.dart';
import '../Tab/irritabilityTab.dart';
import '../Tab/sadTab.dart';




class MoodPage extends StatefulWidget {
  final String? currentUserId;


  const MoodPage({required this.currentUserId});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {

  //my tabs
  List<Widget> myTabs = [

    //angry tab
    MyTab(iconPath: 'lib/icons/anger.png'),
    //sad tab
    MyTab(iconPath: 'lib/icons/sad.png'),

    //anxiety tab
    MyTab(iconPath: 'lib/icons/anxietyy.png'),

    //irritability tab
    MyTab(iconPath: 'lib/icons/aggressive.png')
  ];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: Colors.lightGreen[100],
        appBar: AppBar(
          backgroundColor: Colors.lightGreen[200],
          title: Center(
            child: Text(
              'Autism Mood',
              style: TextStyle(fontSize: 32, color: Colors.black),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 50.0, vertical: 18.0),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      "The Autism's Child Possible Mood Might Trigger Their Tantrum",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            //tab bar
            TabBar(tabs: myTabs),
            Expanded(
              child: TabBarView(
                children: [
                  //anger page
                  AngerTab(),
                  //Sad Page
                  SadTab(),
                  //anxiety Page
                  AnxietyTab(),
                  //irritability Page
                  IrritabilityTab(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationMenu(
          selectedIndex: 3, // Set the index to the appropriate position for "Message"
          onItemTapped: (index) {
            // Handle tapping on bottom navigation items if needed
            if (index == 0) {
              // Navigate to MainFeedPage
              Navigator.pushReplacementNamed(context, '/mainScreen');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/message');
            }
            else if (index == 2) {
              // Navigate to the Graph page
              Navigator.pushReplacementNamed(context, '/graph');
            } else if (index == 4) {
              Navigator.pushReplacementNamed(context, '/feedParent');
            }
          },
        ),
      ),
    );
  }
}