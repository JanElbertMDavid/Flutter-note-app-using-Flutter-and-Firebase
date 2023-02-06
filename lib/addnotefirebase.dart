import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_final_project/addnote.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNoteFirebase extends StatefulWidget {
  const AddNoteFirebase({super.key});

  @override
  State<AddNoteFirebase> createState() => _AddNoteFirebaseState();
}

class _AddNoteFirebaseState extends State<AddNoteFirebase> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController noteController;
  late TextEditingController titleController;
  @override
  void initState() {
    titleController = TextEditingController();
    noteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a note'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        (value == "") ? 'Field must not be empty' : null,
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Note Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        (value == "") ? 'Field must not be empty' : null,
                    minLines: 1,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Enter your notes here!',
                      border: OutlineInputBorder(),
                    ),
                    controller: noteController,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50.0),
                    ),
                    onPressed: () {
                      encodeNote();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future encodeNote() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userauthid = user.uid;

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – hh:mm').format(now);

      final encodeNotesFB =
          FirebaseFirestore.instance.collection('Notes').doc();
      final newAddNote = AddNote(
        notetitle: titleController.text,
        doc_id: encodeNotesFB.id,
        id: userauthid,
        note: noteController.text,
        dateadded: formattedDate,
      );

      final json = newAddNote.toJson();
      await encodeNotesFB.set(json);

      setState(() {
        noteController.text = "";
        titleController.text = "";
        Navigator.pop(context);
      });

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          alignment: Alignment.center,
          content: const Text('Note added!'),
          title: const Text('Status'),
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
