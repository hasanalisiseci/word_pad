class Word {
  int id;
  String word;
  String description;
  int isLearn;

  Word({this.word, this.description, this.isLearn});
  Word.withId({this.id, this.word, this.description, this.isLearn});

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["word"] = word;
    map["description"] = description;
    map["isLearn"] = isLearn;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Word.fromObject(dynamic o) {
    this.id = int.tryParse(o["id"].toString());
    this.word = o["word"];
    this.description = o["description"];
    this.isLearn = int.tryParse(o["isLearn"].toString());
  }
}
