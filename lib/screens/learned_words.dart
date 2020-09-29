import 'package:flutter/material.dart';
import 'package:word_pad/data/dbHelper.dart';
import 'package:word_pad/models/word.dart';
import 'package:word_pad/screens/side_bar.dart';
import 'package:word_pad/screens/toast_message.dart';
import 'package:word_pad/screens/word_detail.dart';

class LearnedWordsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LearnedWordsListState();
  }
}

class _LearnedWordsListState extends State {
  var dbHelper = DbHelper();
  List<Word> words;
  List<Word> learnedWords = new List<Word>();
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
      drawer: NavDrawer(),
      appBar: buildAppBar(),
      body: buildWordList(),
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
                showDetail(context, learnedWords[position]);
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
                                this.learnedWords[position].word,
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
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          height: 50,
                          width: 295,
                          child: SingleChildScrollView(
                            child: Text(this.learnedWords[position].description,
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
                              setState(() {
                                if (this.learnedWords[position].isLearn == 1) {
                                  this.learnedWords[position].isLearn = 0;
                                  updateWord(this.learnedWords[position]);

                                  ToastMessage(
                                      "It was removed from\nwhat was learned.");
                                } else if (this
                                        .learnedWords[position]
                                        .isLearn ==
                                    0) {
                                  this.learnedWords[position].isLearn = 1;
                                  updateWord(this.learnedWords[position]);

                                  ToastMessage(
                                      "Added to what has\nbeen learned.");
                                }
                              });
                            },
                            child: Icon(
                              Icons.bookmark,
                              size: 40,
                              color: this.learnedWords[position].isLearn == 1
                                  ? Colors.deepOrange
                                  : Colors.grey,
                            ),
                          ),
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
                                  ToastMessage(
                                      "${this.learnedWords[position].word} is deleted");
                                  deleteWord(this.learnedWords[position]);
                                  deleteLearnedWord(
                                      this.learnedWords[position]);
                                  getWords();
                                });
                              },
                              child: Icon(Icons.delete, size: 40))
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

  void getWords() async {
    var wordsFuture = dbHelper.getWords();
    wordsFuture.then((data) {
      setState(() {
        this.words = data;
        for (Word word in words) {
          if (word.isLearn == 1) {
            this.learnedWords.add(word);
          }
        }
        wordCount = learnedWords.length;
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

  void deleteLearnedWord(Word word) async {
    learnedWords.remove(word);
    wordCount = learnedWords.length;
  }

  void allDelete(List<Word> words) {
    for (int i = 0; i < words.length; i++) {
      learnedWords.remove(words[i]);
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

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.deepOrange,
      centerTitle: false,
      title: Text(
        "Learned Words",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      actions: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Container(
              width: 70,
              decoration: BoxDecoration(
                  color: Colors.deepOrange.shade400,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatedBox(
                    quarterTurns: -1,
                    child: Text(
                      "TOTAL",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${wordCount}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
