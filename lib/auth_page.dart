import 'package:david_final_project/loginpage.dart';
import 'package:david_final_project/signuppage.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoggedin = true;

  @override
  Widget build(BuildContext context) {
    return isLoggedin
        ? LoginPage(
            onClickedSignup: toggle,
          )
        : SignUp(
            onClickedSignIn: toggle,
          );
  }
  void toggle() => setState(() => isLoggedin = !isLoggedin);
}
