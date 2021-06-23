import 'package:flutter/material.dart';
import 'package:notesqflite/database_pro.dart';
import 'package:notesqflite/modelclass.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// Run this commands in Terminal
// flutter pub add top_snackbar_flutter

class Addnote extends StatefulWidget {
  const Addnote({Key? key}) : super(key: key);

  @override
  _AddnoteState createState() => _AddnoteState();
}

class _AddnoteState extends State<Addnote> {
  String? title;
  String? body;
  DateTime? date;

  TextEditingController titlec = TextEditingController();
  TextEditingController bodyc = TextEditingController();

  addNote(NoteModel note) {
    DatabaseProvider.db.addNewNote(note);
    print("Note Added");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titlec,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
              ),
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: TextField(
              controller: bodyc,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "Content"),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        splashColor: Colors.pink,
        onPressed: () {
          setState(() {
            title = titlec.text;
            body = bodyc.text;
            date = DateTime.now();
          });
          if (titlec.text == "" && bodyc.text == "") {
            showTopSnackBar(
                context, CustomSnackBar.error(message: "Enter Some Notes"));
          } else {
            NoteModel note =
                NoteModel(title: title!, body: body!, creationdate: date!);
            addNote(note);
            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
            showTopSnackBar(
                context, CustomSnackBar.success(message: "Note Added"));
          }
        },
        label: Text("Save"),
        icon: Icon(Icons.save),
      ),
    );
  }
}
