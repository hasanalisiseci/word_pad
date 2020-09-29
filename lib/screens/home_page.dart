import 'package:flutter/material.dart';
import 'package:word_pad/data/dbHelper.dart';
import 'package:word_pad/models/word.dart';
import 'package:word_pad/screens/word_add.dart';
import 'package:word_pad/screens/word_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WordsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WordsListState();
  }
}

class _WordsListState extends State {
  var dbHelper = DbHelper();
  List<Word> words;
  int wordCount = 0;

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    getWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          centerTitle: false,
          title: Text(
            "Words",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          )),
      body: buildWordList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          goToWordAdd();
        },
        child: Icon(Icons.add),
        tooltip: "Add Word to Pad",
      ),
    );
  }

  ListView buildWordList() {
    return ListView.builder(
        itemCount: wordCount,
        itemBuilder: (BuildContext context, int position) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: GestureDetector(
              onTap: () {
                showDetail(context, words[position]);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 0,
                      offset: new Offset(0.0, 0.0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 19),
                            child: Container(
                              width: 200,
                              child: Text(
                                this.words[position].word,
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (this.words[position].isLearn == 1) {
                                      this.words[position].isLearn = 0;
                                      updateWord(this.words[position]);

                                      showToastMessage(
                                          "It was removed from\nwhat was learned.");
                                    } else if (this.words[position].isLearn ==
                                        0) {
                                      this.words[position].isLearn = 1;
                                      updateWord(this.words[position]);

                                      showToastMessage(
                                          "Added to what has\nbeen learned.");
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.bookmark,
                                  size: 40,
                                  color: this.words[position].isLearn == 1
                                      ? Colors.deepOrange
                                      : Colors.grey,
                                ),
                              ))
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          height: 50,
                          width: 295,
                          child: SingleChildScrollView(
                            child: Text(this.words[position].description,
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    wordSpacing: 2,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ),
                      ),
                      Divider(color: Colors.black),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                goToDetail(this.words[position]);
                              },
                              child: Icon(Icons.edit, size: 30)),
                          SizedBox(width: 70),
                          Container(
                            height: 30.0,
                            width: 0.5,
                            color: Colors.black,
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          SizedBox(width: 70),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  showToastMessage(
                                      "${this.words[position].word} is deleted");
                                  deleteWord(this.words[position]);
                                  getWords();
                                });
                              },
                              child: Icon(Icons.delete, size: 30))
                        ],
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  } //sayfa sonu

  void goToWordAdd() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WordAdd()));
    if (result != null) {
      if (result) {
        getWords();
      }
    }
  }

  void getWords() async {
    var wordsFuture = dbHelper.getWords();
    wordsFuture.then((data) {
      setState(() {
        this.words = data;
        wordCount = data.length;
      });
    });
  }

  void goToDetail(Word word) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WordDetail(word)));
    if (result != null) {
      if (result) {
        getWords();
      }
    }
  }

  void deleteWord(Word word) async {
    await dbHelper.delete(word.id);
  }

  void allDelete(List<Word> words) async {
    for (int i = 0; i < words.length; i++) {
      await dbHelper.delete(words[i].id);
    }
  }

  void updateWord(Word word) async {
    await dbHelper.update(Word.withId(
        id: word.id,
        word: word.word,
        description: word.description,
        isLearn: word.isLearn));
  }

  void showDetail(BuildContext ctx, Word word) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: Text(word.word,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          content: Text(word.description,
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: <Widget>[],
        );
      },
    );
  }

  void showToastMessage(String str) {
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }
}
