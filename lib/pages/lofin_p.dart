import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pictures/pages/homepage.dart';
import 'package:pictures/services/firebase_services.dart';
import 'package:get_it/get_it.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double? _deviceheight, _devicewidth;

  FirebaseServices? _firebaseServices;
  final GlobalKey<FormState> _loginFormkey = GlobalKey<FormState>();
  late String _email, _password;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _title(),
              _details(),
              _loginbutton(),
              _toregester(),
            ],
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

  Widget _loginbutton() {
    return MaterialButton(
      onPressed: _loginuser,
      minWidth: _devicewidth! * 0.70,
      height: _deviceheight! * 0.069,
      color: Colors.orangeAccent,
      child: const Text(
        "login",
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _details() {
    return Container(
      height: _deviceheight! * 0.20,
      child: Form(
        key: _loginFormkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
          _email = _value as String;
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
            _password = _value as String;
          });
        },
        validator: (value) => value!.length > 6
            ? null
            : "Please enter a password grater than 6 characters");
  }

  void _loginuser() async {
    if (_loginFormkey.currentState!.validate()) {
      _loginFormkey.currentState!.save();
      bool _result = await _firebaseServices!
          .loginuser(email: _email, password: _password);
      if (_result) Navigator.popAndPushNamed(context, 'homepage');
    }
  }

  Widget _toregester() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'register'),
      child: const Text(
        "Don't have a account? Register",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
