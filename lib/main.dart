import 'package:flutter/material.dart';
import 'package:notesqflite/adddnote.dart';
import 'package:notesqflite/database_pro.dart';
import 'package:notesqflite/display_note.dart';
import 'package:notesqflite/modelclass.dart';

// Run this commands in Terminal
// flutter pub add sqflite
// flutter pub add path

void main() {
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => Homepage(),
        "/second": (context) => ShowNote()
      },
      debugShowCheckedModeBanner: false,
      title: "Note",
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  getNotes() async {
    final notes = await DatabaseProvider.db.getNotes();
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Notes"),
      ),
      body: FutureBuilder<dynamic>(
          future: getNotes(),
          builder: (context, noteData) {
            switch (noteData.connectionState) {
              case ConnectionState.waiting:
                {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              case ConnectionState.done:
                {
                  if (noteData.data == Null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.announcement_outlined,
                            size: 60,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "No data",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 8, left: 4, right: 4, bottom: 8),
                      child: ListView.builder(
                          itemCount: noteData.data?.length,
                          itemBuilder: (context, index) {
                            String title = noteData.data[index]['title'];
                            String body = noteData.data[index]['body'];
                            String creationdate =
                                noteData.data[index]['creation_date'];
                            int id = noteData.data[index]['id'];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              shadowColor: Colors.purpleAccent,
                              elevation: 5,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/second",
                                    arguments: NoteModel(
                                        title: title,
                                        body: body,
                                        creationdate:
                                            DateTime.parse(creationdate),
                                        id: id),
                                  );
                                },
                                title: Text(title),
                                subtitle: Text(body),
                                trailing: Text(creationdate),
                              ),
                            );
                          }),
                    );
                  }
                }
              default:
                {
                  return Container();
                }
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        splashColor: Colors.pink,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Addnote()));
        },
        label: Text(
          "Add Note",
          style: TextStyle(fontSize: 15),
        ),
        icon: Icon(Icons.add),
      ),
    );
  }
}
