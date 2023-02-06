import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:david_final_project/addnote.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateNote extends StatefulWidget {
  const UpdateNote({super.key, required this.notes});

  final AddNote notes;

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  late TextEditingController noteController;
  late TextEditingController titleController;

  @override
  void initState() {
    noteController = TextEditingController(text: widget.notes.note);
    titleController = TextEditingController(text: widget.notes.notetitle);
    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    titleController.dispose();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40.0),
                TextField(
                  controller: titleController,
                ),
                TextFormField(
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: noteController,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0),
                  ),
                  onPressed: () {
                    updateNote(widget.notes.doc_id);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Update'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  updateNote(String doc_id) {
    final docNote = FirebaseFirestore.instance.collection('Notes').doc(doc_id);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – hh:mm').format(now);
    docNote.update({
      'note': noteController.text,
      'notetitle': titleController.text,
      'dateadded': formattedDate
    });
    Navigator.pop(context);
  }
}
