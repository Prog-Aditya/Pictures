import 'package:flutter/material.dart';
import 'package:pictures/services/firebase_services.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class profilepage extends StatefulWidget {
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  double? _deviceheight, _devicewidth;

  FirebaseServices? _firebaseServices;

  @override
  void initState() {
    super.initState();
    _firebaseServices = GetIt.instance.get<FirebaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: _devicewidth! * 0.05, vertical: _deviceheight! * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _profilepic(),
          _postsGridView(),
        ],
      ),
    );
  }

  Widget _profilepic() {
    return Container(
      margin: EdgeInsets.only(bottom: _deviceheight! * 0.02),
      height: _deviceheight! * 0.15,
      width: _deviceheight! * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(_firebaseServices!.currentuser!["image"]),
        ),
      ),
    );
  }

  Widget _postsGridView() {
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
      stream: _firebaseServices!.getpostforUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _posts = snapshot.data!.docs.map((e) => e.data()).toList();
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: _posts.length,
              itemBuilder: ((context, index) {
                Map _post = _posts[index];
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_post["image"]),
                    ),
                  ),
                );
              }));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
