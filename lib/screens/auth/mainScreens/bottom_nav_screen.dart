import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lekhk/screens/auth/mainScreens/home_screen.dart';
import 'package:lekhk/screens/auth/upload_screen.dart';
import 'package:lekhk/screens/auth/profile_screen.dart';
import 'package:lekhk/screens/auth/wallet_screen.dart';

class BottomNavBarExample extends StatefulWidget {
  @override
  _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeScreen(),
    UploadScreen(isEditable: false,),
    ProfileScreen(isMyProfile: true,userId: '123'
    // FirebaseAuth.instance.currentUser!.uid,
    ),
    WalletScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Wallet',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Dummy screens for each ga 6
