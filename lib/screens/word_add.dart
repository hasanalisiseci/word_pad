import 'package:flutter/material.dart';
import 'package:word_pad/data/dbHelper.dart';
import 'package:word_pad/models/word.dart';
import 'package:word_pad/screens/toast_message.dart';

class WordAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WordAddState();
  }
}

class WordAddState extends State {
  var dbHelper = DbHelper();
  List<Word> words;
  var wordName = TextEditingController();
  var txtDescription = TextEditingController();
  int isLearn = 0;
  var wordCount;

  @override
  void initState() {
    getWords();
    debugPrint(isLearn.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          centerTitle: false,
          title: Text(
            "Add Word",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
          )),
      body: Padding(
        padding: EdgeInsets.only(top: 40),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              buildTextField("Word", wordName),
              buildTextField("Description", txtDescription),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isLearn == 0) {
                                isLearn = 1;
                                debugPrint(isLearn.toString());
                              } else if (isLearn == 1) {
                                isLearn = 0;
                                debugPrint(isLearn.toString());
                              }
                            });
                          },
                          child: Icon(
                            Icons.bookmark,
                            size: 60,
                            color:
                                isLearn == 1 ? Colors.deepOrange : Colors.grey,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                            "Is learned? Comes as no by default. \nClick to change"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              buildSaveButton(),
              SizedBox(height: 140),
              buildTotalWords()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String feature, TextEditingController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: new Offset(0.0, 0.0),
                    blurRadius: 1)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: feature,
                labelStyle: TextStyle(fontSize: 22, color: Colors.blue),
              ),
              controller: controller,
              style: TextStyle(color: Colors.deepOrange, fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }

  buildSaveButton() {
    return Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepOrange,
            boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  offset: new Offset(0.0, 0.0),
                  blurRadius: 1)
            ]),
        child: FlatButton(
          child: Text(
            "Save",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            addWord();
          },
        ));
  }

  Widget buildTotalWords() {
    return Container(
      height: 30,
      width: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepOrange,
          boxShadow: [
            BoxShadow(
                color: Colors.white,
                offset: new Offset(0.0, 0.0),
                blurRadius: 1)
          ]),
      child: Center(
        child: Text(
          "Total number of saved words: ${wordCount.toString()}",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void addWord() async {
    var result = await dbHelper.insert(Word(
        word: wordName.text,
        description: txtDescription.text,
        isLearn: isLearn));
    Navigator.pop(context, true);
    ToastMessage("New word added to list");
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
}
