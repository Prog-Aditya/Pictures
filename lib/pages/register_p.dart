import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pictures/services/firebase_services.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  double? _deviceheight, _devicewidth;

  String? _email, _password, _rname;

  File? _image;

  FirebaseServices? _firebaseServices;
  final GlobalKey<FormState> _RegisterFormkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firebaseServices = GetIt.instance.get<FirebaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceheight = MediaQuery.of(context).size.height;
    _devicewidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _devicewidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _title(),
                _profilepicture(),
                _registerdetails(),
                _registerbutton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Center(
      child: Text(
        "Pictures",
        style: TextStyle(
          color: Colors.orangeAccent,
          fontFamily: 'Square Peg',
          fontSize: 75,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _registerbutton() {
    return MaterialButton(
      onPressed: _rigesteruser,
      minWidth: _devicewidth! * 0.70,
      height: _deviceheight! * 0.069,
      color: Colors.orangeAccent,
      child: const Text(
        "Register",
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _rigesteruser() async {
    if (_RegisterFormkey.currentState!.validate() && _image != null) {
      _RegisterFormkey.currentState!.save();
      bool result = await _firebaseServices!.registerUser(
          name: _rname!, email: _email!, password: _password!, image: _image!);
      if (result) Navigator.pop(context);
    }
  }

  Widget _registerdetails() {
    return Container(
      height: _deviceheight! * 0.29,
      child: Form(
        key: _RegisterFormkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nametextfield(),
            _emailtextfield(),
            _passwordtextfield(),
          ],
        ),
      ),
    );
  }

  Widget _emailtextfield() {
    return TextFormField(
      style: const TextStyle(
        color: Colors.amberAccent,
        decorationColor: Colors.amber,
      ),
      decoration: const InputDecoration(
        hintText: "Email...",
        hintStyle: TextStyle(
          color: Colors.amber,
        ),
      ),
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      validator: (value) {
        bool result = value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return result ? null : "Please enter a valid email";
      },
    );
  }

  Widget _profilepicture() {
    var _imageprovider = _image != null
        ? FileImage(_image!)
        : const NetworkImage("https://i.pravatar.cc/300");
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((_result) {
          setState(() {
            _image = File(_result!.files.first.path!);
          });
        });
      },
      child: Container(
        height: _deviceheight! * 0.15,
        width: _deviceheight! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _imageprovider as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget _passwordtextfield() {
    return TextFormField(
        obscureText: true,
        style: const TextStyle(
          color: Colors.amberAccent,
          decorationColor: Colors.amber,
        ),
        decoration: const InputDecoration(
          hintText: "Password...",
          hintStyle: TextStyle(
            color: Colors.amber,
          ),
        ),
        onSaved: (_value) {
          setState(() {
            _password = _value;
          });
        },
        validator: (value) => value!.length > 6
            ? null
            : "Please enter a password grater than 6 characters");
  }

  Widget _nametextfield() {
    return TextFormField(
      style: const TextStyle(
        color: Colors.amberAccent,
        decorationColor: Colors.amber,
      ),
      decoration: const InputDecoration(
        hintText: "Name...",
        hintStyle: TextStyle(
          color: Colors.amber,
        ),
      ),
      onSaved: (_value) {
        setState(
          () {
            _rname = _value;
          },
        );
      },
      validator: (value) => value!.length > 0 ? null : "Please enter a Name",
    );
  }
}
