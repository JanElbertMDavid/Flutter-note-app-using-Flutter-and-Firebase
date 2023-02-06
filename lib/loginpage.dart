import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignup;

  const LoginPage({
    Key? key,
    required this.onClickedSignup,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('images/anya.png'),
                  ),
                  const SizedBox(height: 40.0),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      label: Text('E-mail'),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    obscureText: _obscureText,
                    controller: passwordController,
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              _obscureText = !_obscureText;
                            },
                          );
                        },
                        child: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50.0),
                    ),
                    onPressed: () {
                      signIn();
                    },
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Sign-in'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Don't have one? ",
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).colorScheme.primary),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignup,
                          text: 'Sign Up!',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.secondary),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Successfully logged in!'),
          title: const Text('Login Status'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Firebase Error'),
          content: Text(e.message.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }
}
