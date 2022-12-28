import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pictures/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feedpage extends StatefulWidget {
  const Feedpage({super.key});

  @override
  State<Feedpage> createState() => _FeedpageState();
}

class _FeedpageState extends State<Feedpage> {
  FirebaseServices? _firebaseServices;

  @override
  void initState() {
    super.initState();
    _firebaseServices = GetIt.instance.get<FirebaseServices>();
  }

  double? _deviceheight, _devicewidth;

  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    return Container(
      height: _deviceheight,
      width: _devicewidth,
      child: _postlistview(),
    );
  }

  Widget _postlistview() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseServices!.latestPost(),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          print(_snapshot.data.docs);
          List _posts = _snapshot.data.docs.map((e) => e.data()).toList();
          print(_posts);
          return ListView.builder(
            itemCount: _posts.length,
            itemBuilder: ((BuildContext context, int index) {
              Map _post = _posts[index];
              return Container(
                margin: EdgeInsets.symmetric(
                    vertical: _deviceheight! * 0.01,
                    horizontal: _devicewidth! * 0.03),
                height: _deviceheight! * 0.30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(_post["image"]),
                  ),
                ),
              );
            }),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
