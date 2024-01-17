import 'package:flutter/material.dart';

final List<BottomNavigationBarItem> _bottomNavBarItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.feedback_sharp),
    label: 'Feed',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.chat_bubble),
    label: 'Message',
  ),

  BottomNavigationBarItem(
    icon: Icon(Icons.add),
    label: 'Post',
  ),
];

class BottomNavigationMenuEdu extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigationMenuEdu({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _BottomNavigationMenuEduState createState() => _BottomNavigationMenuEduState();
}

class _BottomNavigationMenuEduState extends State<BottomNavigationMenuEdu> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      items: _bottomNavBarItems,
      currentIndex: widget.selectedIndex,
      unselectedItemColor: Colors.blueGrey,
      selectedItemColor: Colors.deepOrange,
      onTap: widget.onItemTapped,
    );
  }
}