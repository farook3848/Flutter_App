class NoteModel {
  int? id;
  String title;
  String body;
  DateTime creationdate;

  NoteModel(
      {this.id,
      required this.title,
      required this.body,
      required this.creationdate});

  Map<String, dynamic> toMap() {
    return ({
      "id": id,
      "title": title,
      "body": body,
      "creation_date": creationdate.toString().substring(0, 10)
    });
  }
}
