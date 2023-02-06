import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_final_project/addnote.dart';
import 'package:david_final_project/addnotefirebase.dart';
import 'package:david_final_project/updatenote.dart';
import 'package:david_final_project/userprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

int pageIndex = 0;

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Notes'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddNoteFirebase(),
                    ));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: NavigationDrawer(),
      body: StreamBuilder<List<AddNote>>(
          stream: fetchNotes(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final notes = snapshot.data!;

              return ListView(
                children: notes.map(buildNotes2).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget buildNotes2(AddNote addnote) => Card(
        color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        margin: const EdgeInsets.all(10.0),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              border: Border.all(style: BorderStyle.solid, color: Colors.black),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      addnote.notetitle,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 30.0,
                        children: [Text(addnote.note)],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(addnote.dateadded),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateNote(notes: addnote),
                                ),
                              );
                            },
                            icon: const Icon(Icons.update_rounded)),
                        IconButton(
                            onPressed: () {
                              showModalConfirmation(context, addnote.doc_id);
                            },
                            icon: const Icon(Icons.delete_forever_rounded))
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  void showModalConfirmation(BuildContext context, String doc_id) => showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you wish to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                deleteNote(doc_id);
              },
              child: const Text('Ok'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            )
          ],
        ),
      );

  Widget buildNotes(AddNote addnote) => ListTile(
        dense: true,
        title: Text(addnote.dateadded),
        subtitle: Text(addnote.note),
      );

  final user = FirebaseAuth.instance.currentUser!;

  Stream<List<AddNote>> fetchNotes() => FirebaseFirestore.instance
      .collection('Notes')
      .where('id', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => AddNote.fromJson(doc.data())).toList());

  deleteNote(String doc_id) {
    final docNotes = FirebaseFirestore.instance.collection('Notes').doc(doc_id);
    docNotes.delete();
    Navigator.pop(context);
  }
}

class NavigationDrawer extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser!;
  NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      );
  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          ListTile(
            leading: const SizedBox(
                height: double.infinity, child: Icon(Icons.person)),
            title: const Text('Signed In As: '),
            subtitle: Text(currentUser.email!),
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.home)],
            ),
            title: const Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.person)],
            ),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfile(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirmation'),
                content: const Text('Do you wish to logout?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: const Text('Successfully logged out!'),
                          title: const Text('Login Status'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Ok'),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text('Ok'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

var txtStyle = const TextStyle(fontSize: 16.0);
