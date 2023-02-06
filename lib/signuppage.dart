import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_final_project/appusers.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUp({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController usernameController;
  PlatformFile? pickedUserImage;
  UploadTask? uploadUserImage;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedUserImage = result.files.first;
    });
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  Future uploadImage() async {
    if (pickedUserImage == null) {
      encodeUser(
          'https://firebasestorage.googleapis.com/v0/b/finalprojectdavid.appspot.com/o/images%2Fno%20profile.png?alt=media&token=0152962f-2919-44c4-9e00-8ddf15acdb31');
    } else {
      final path = 'files/${generateRandomString(5)}';
      final file = File(pickedUserImage!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);

      setState(() {
        uploadUserImage = ref.putFile(file);
      });

      final snapshot = await uploadUserImage!.whenComplete(() {});
      var urlDownload = await snapshot.ref.getDownloadURL();

      encodeUser(urlDownload);

      setState(() {
        uploadUserImage = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Sign Up'),
      ),
      body: ListView(
        children: [
          Container(
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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(142, 158, 158, 158),
                        ),
                      ),
                      child: Center(
                        child:
                            (pickedUserImage == null) ? noImage() : hasImage(),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    ElevatedButton.icon(
                        onPressed: () {
                          selectFile();
                        },
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('Add a profile picture')),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('E-mail'),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Please enter a valid email address.'
                              : null,
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Password'),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value != null && value.length < 8
                          ? 'Password must be a minimum of 9 characters'
                          : null,
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Username'),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value == "" ? 'Field must not be empty!' : null,
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Full Name'),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value == "" ? 'Field must not be empty!' : null,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50.0),
                      ),
                      onPressed: () {
                        signedUp();
                      },
                      icon: const Icon(Icons.arrow_forward_outlined),
                      label: const Text('Sign-up'),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Already have one? ",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 14.0),
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.onClickedSignIn,
                            text: 'Sign in!',
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
        ],
      ),
    );
  }

  Widget noImage() => Image.network(
        'https://firebasestorage.googleapis.com/v0/b/finalprojectdavid.appspot.com/o/images%2Fno%20profile.png?alt=media&token=0152962f-2919-44c4-9e00-8ddf15acdb31',
        fit: BoxFit.cover,
      );

  Widget hasImage() => Image.file(
        File(pickedUserImage!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Future signedUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      uploadImage();
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Successfully Registered!'),
          title: const Text('Registration Status'),
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

  Future encodeUser(urlDownload) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userauthid = user.uid;
    final encodeUserApps =
        FirebaseFirestore.instance.collection('AppUsers').doc(userauthid);

    final newAppUsers = AppUsers(
      userimage: urlDownload,
      id: userauthid,
      email: emailController.text,
      name: nameController.text,
      password: passwordController.text,
      username: usernameController.text,
    );

    final json = newAppUsers.toJson();

    await encodeUserApps.set(json);
  }
}
