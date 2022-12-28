import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pictures/pages/feed_page.dart';
import 'package:pictures/pages/profile_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pictures/services/firebase_services.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseServices? _firebaseServices;
  int _currentstate = 0;

  @override
  void initState() {
    super.initState();
    _firebaseServices = GetIt.instance.get<FirebaseServices>();
  }

  final List<Widget> _pages = [
    const Feedpage(),
    const profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          'Pictures',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Square Peg',
              fontSize: 50,
              fontWeight: FontWeight.w900),
        ),
        actions: [
          GestureDetector(
            onTap: _postImage,
            child: const Icon(Icons.add_a_photo),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: GestureDetector(
              onTap: () async {
                await _firebaseServices!.logout();
                Navigator.popAndPushNamed(context, 'login');
              },
              child: const Icon(Icons.logout),
            ),
          )
        ],
      ),
      bottomNavigationBar: _bottomNav(),
      body: _pages[_currentstate],
    );
  }

  void _postImage() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    File _image = File(_result!.files.first.path!);
    await _firebaseServices!.postImage(_image);
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentstate,
      onTap: (_index) {
        setState(() {
          _currentstate = _index;
        });
      },
      backgroundColor: Colors.amber,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          label: 'Feed',
          icon: Icon(Icons.feed),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.account_box),
        ),
      ],
    );
  }
}
