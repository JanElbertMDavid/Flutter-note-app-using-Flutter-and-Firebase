import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_final_project/appusers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

int pageIndex = 1;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: readCurrentUser(currentUser.uid),
    );
  }

  Widget buildUserData(AppUsers users) => Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 150.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 7.0,
                            blurStyle: BlurStyle.outer)
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 25.0),
                        Container(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Text(
                                'Name: ${users.name}',
                                style: txtStyle,
                              ),
                              const Divider(
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                color: Colors.black,
                                height: 8.0,
                              ),
                              Text(
                                'Email Address: ${users.email}',
                                style: txtStyle,
                              ),
                              const Divider(
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                                color: Colors.black,
                                height: 8.0,
                              ),
                              Text(
                                'Username: ${users.username}',
                                style: txtStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: CircleAvatar(
                      radius: 105.0,
                      backgroundColor: Colors.grey.shade400,
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(users.userimage),
                        radius: 100.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget readCurrentUser(uid) {
    var collection = FirebaseFirestore.instance.collection('AppUsers');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: collection.doc(uid).snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Snapshot Error'),
                    content: Text(snapshot.error.toString()),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Ok'))
                    ],
                  );
                },
              );
            }

            if (snapshot.hasData) {
              final appUsers = snapshot.data!.data();
              final newAppUser = AppUsers(
                userimage: appUsers!['userimage'],
                email: appUsers['email'],
                name: appUsers['name'],
                password: appUsers['password'],
                username: appUsers['username'],
                id: appUsers['id'],
              );

              return buildUserData(newAppUser);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}

var txtStyle = const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
