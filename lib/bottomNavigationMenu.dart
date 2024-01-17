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
    icon: Icon(Icons.graphic_eq_rounded),
    label: 'Graph',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.directions_walk_outlined),
    label: 'Activity',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.add),
    label: 'Post',
  ),
];

class BottomNavigationMenu extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavigationMenu({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _BottomNavigationMenuState createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.lightGreen[200],
      items: _bottomNavBarItems,
      currentIndex: widget.selectedIndex,
      unselectedItemColor: Colors.blueGrey,
      selectedItemColor: Colors.deepOrange,
      onTap: widget.onItemTapped,
    );
  }
}