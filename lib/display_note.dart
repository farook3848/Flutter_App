import 'package:flutter/material.dart';
import 'package:notesqflite/database_pro.dart';
import 'database_pro.dart';
import 'modelclass.dart';
import 'package:notesqflite/modelclass.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ShowNote extends StatefulWidget {
  const ShowNote({Key? key}) : super(key: key);

  @override
  _ShowNoteState createState() => _ShowNoteState();
}

class _ShowNoteState extends State<ShowNote> {
  String? title;
  String? body;
  DateTime? date;

  TextEditingController titlec = TextEditingController();
  TextEditingController bodyc = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      Future.delayed(Duration.zero, () {
        setState(() {
          final NoteModel note =
              ModalRoute.of(context)?.settings.arguments as NoteModel;
          titlec = TextEditingController(text: note.title);
          bodyc = TextEditingController(text: note.body);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final NoteModel note =
        ModalRoute.of(context)?.settings.arguments as NoteModel;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Note"),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
              onPressed: () {
                DatabaseProvider.db.deleteNote(note.id!);
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
                showTopSnackBar(
                    context, CustomSnackBar.info(message: "Note Deleted"));
              },
              icon: Icon(Icons.delete)),
          IconButton(
              onPressed: () {
                setState(() {
                  title = titlec.text;
                  body = bodyc.text;
                  date = DateTime.now();
                });

                DatabaseProvider.db.updateNote(note.id!, title!, body!, date!);
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
                showTopSnackBar(
                    context, CustomSnackBar.info(message: "Note Updated"));
              },
              icon: Icon(Icons.edit)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titlec,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: TextField(
                    controller: bodyc,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    )))
          ],
        ),
      ),
    );
  }
}
