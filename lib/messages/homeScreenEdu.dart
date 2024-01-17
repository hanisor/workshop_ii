/*
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled2/model/parentModel.dart';

import '../bottomNavigationMenuEdu.dart';
import '../constants/constants.dart';
import 'apis.dart';
import 'chatScreen.dart';
import 'dialogs.dart';

import 'chatUser.dart';
import 'chatUserCard.dart';

class HomeScreenEdu extends StatefulWidget {
  final String? currentUserId;

  const HomeScreenEdu({Key? key,  this.currentUserId}) : super(key: key);
  @override
  State<HomeScreenEdu> createState() => _HomeScreenEduState();
}

class _HomeScreenEduState extends State<HomeScreenEdu> {
  List<ChatUser> _list = [];
  List<ChatUser> _searchList = [];
  List<ParentModel> _parentList = [];

  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  Size? mq;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mq = MediaQuery.of(context).size;
  }

  @override
  void initState() {
    super.initState();
    APIs apiInstance = APIs();
    apiInstance.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
              _searchController.clear();
              _searchList.clear();
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.green[50],
          appBar: AppBar(
            backgroundColor: AutiTrackColor2,

            title: _isSearching
                ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by Name or Email...',
                hintStyle: TextStyle(color: Colors.black),
              ),
              autofocus: true,
              style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
              onChanged: (val) {
                _searchList.clear();
                for (var user in _list) {
                  if (user.name.toLowerCase().contains(val.toLowerCase()) ||
                      user.email.toLowerCase().contains(val.toLowerCase())) {
                    _searchList.add(user);
                    setState(() {
                      _searchList;
                    });
                  }
                }
              },
            )
                : const Text('Message'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (_isSearching) {
                      _searchController.clear();
                    }
                  });
                },
                icon: Icon(
                  _isSearching ? CupertinoIcons.clear_circled_solid : Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {
                _addChatUserDialog();
              },
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _parentList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _navigateToChatScreen(_parentList[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0), // Adjust this value as needed
                    child: Container(
                      height: 80.0,
                      child: Card(
                        elevation: 2.0,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              _parentList[index].parentProfilePicture ?? "",
                            ),
                            radius: 30,
                          ),
                          title: Text(
                            _parentList[index].parentName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            _navigateToChatScreen(_parentList[index]);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ],
        ),
          bottomNavigationBar: BottomNavigationMenuEdu(
            selectedIndex: 1, // Set the index to the appropriate position for "Message"
            onItemTapped: (index) {
              // Handle tapping on bottom navigation items if needed
              if (index == 0) {
                // Navigate to MainFeedPage
                Navigator.pushReplacementNamed(context, '/mainScreenEdu');
              }

              else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/feedEdu');
              }
            },
          ),
        ),
      ),
    );
  }

  void _addChatUserDialog() {
    String email = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.only(
            left: 24, right: 24, top: 20, bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(
              Icons.person_add,
              color: Colors.blue,
              size: 28,
            ),
            Text('  Add User')
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
            hintText: 'Email Id',
            prefixIcon: const Icon(Icons.email, color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel',
                style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
          MaterialButton(
            onPressed: () async {
              Navigator.pop(context);
              if (email.isNotEmpty) {
                await APIs.addChatUser(email).then((value) {
                  if (!value) {
                    Dialogs.showSnackbar(context, 'User does not Exist!');
                  }
                });
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
  void _navigateToChatScreen(ParentModel parent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          user: ChatUser(
            id: parent.id ?? '',
            name: parent.parentName,
            image: parent.parentProfilePicture,
            // Add other properties you need
            createdAt: DateTime.now().toIso8601String(),
            email: '',  // Provide a default value for email
            isOnline: false,  // Provide a default value for isOnline
            lastActive: DateTime.now().toIso8601String(),  // Provide a default value for lastActive
            pushToken: '', lastMessage: '',  // Provide a default value for pushToken
          ),

        ),
      ),
    );
  }

}*/
// home_screen.dart
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bottomNavigationMenu.dart';
import '../bottomNavigationMenuEdu.dart';
import '../constants/constants.dart';
import '../model/parentModel.dart';
import 'apis.dart';
import 'chatScreen.dart';
import 'chatUserCard.dart';
import 'chatUser.dart';
import '../model/educatorModel.dart';

class HomeScreenEdu extends StatefulWidget {
  final String? currentUserId;

  const HomeScreenEdu({Key? key,  this.currentUserId}) : super(key: key);

  @override
  _HomeScreenEduState createState() => _HomeScreenEduState();
}

class _HomeScreenEduState extends State<HomeScreenEdu> {
  List<ChatUser> _list = [];
  List<ChatUser> _searchList = [];
  List<ParentModel> _parentsList = [];
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  Size? mq;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mq = MediaQuery.of(context).size;
  }

  @override
  void initState() {
    super.initState();
    _fetchEducatorsList();
    APIs apiInstance = APIs();
    apiInstance.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  void _fetchEducatorsList() async {
    try {
      List<ParentModel> parents = await APIs.getParentsList();
      setState(() {
        _parentsList = parents;
      });
    } catch (e) {
      print('Error fetching educators: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
              _searchController.clear();
              _searchList.clear();
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.green[50],
          appBar: AppBar(
            backgroundColor: AutiTrackColor2,
            title: _isSearching
                ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by Name or Email...',
                hintStyle: TextStyle(color: Colors.black),
              ),
              autofocus: true,
              style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
              onChanged: (val) {
                _searchList.clear();
                for (var user in _list) {
                  if (user.name
                      .toLowerCase()
                      .contains(val.toLowerCase()) ||
                      user.email
                          .toLowerCase()
                          .contains(val.toLowerCase())) {
                    _searchList.add(user);
                  }
                }
                setState(() {});
              },
            )
                : const Text('Message'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (_isSearching) {
                      _searchController.clear();
                    }
                  });
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _parentsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _navigateToChatScreen(_parentsList[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                _parentsList[index].parentProfilePicture ?? "",
                              ),
                              radius: 30,
                            ),
                            SizedBox(height: 2),
                            Text(
                              _parentsList[index].parentName,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _parentsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _navigateToChatScreen(_parentsList[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0), // Adjust this value as needed
                        child: Container(
                          height: 80.0,
                          child: Card(
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  _parentsList[index].parentProfilePicture ?? "",
                                ),
                                radius: 30,
                              ),
                              title: Text(
                                _parentsList[index].parentName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                _navigateToChatScreen(_parentsList[index]);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationMenuEdu(
            selectedIndex: 0,
            onItemTapped: (index) {
              if (index == 1) {
                Navigator.pushNamed(context, '/messages');
              }  else if (index == 2) {
                Navigator.pushNamed(context, '/feedEdu');
              }
              else if (index == 0) {
                Navigator.pushNamed(context, '/mainScreenEdu');
              }
            },
          ),
        ),
      ),
    );
  }




  void _navigateToChatScreen(ParentModel parent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          user: ChatUser(
            id: parent.id ?? '',
            name: parent.parentName,
            image: parent.parentProfilePicture,
            // Add other properties you need
            createdAt: DateTime.now().toIso8601String(),
            email: '',  // Provide a default value for email
            isOnline: false,  // Provide a default value for isOnline
            lastActive: DateTime.now().toIso8601String(),  // Provide a default value for lastActive
            pushToken: '', lastMessage: '',  // Provide a default value for pushToken
          ),

        ),
      ),
    );
  }


}


