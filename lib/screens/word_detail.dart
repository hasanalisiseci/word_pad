import 'package:flutter/material.dart';
import 'package:word_pad/data/dbHelper.dart';
import 'package:word_pad/models/word.dart';

class WordDetail extends StatefulWidget {
  Word word;
  WordDetail(this.word);
  @override
  State<StatefulWidget> createState() {
    return _WordDetailState(word);
  }
}

class _WordDetailState extends State {
  Word word;
  _WordDetailState(this.word);
  var dbHelper = DbHelper();

  var wordName = TextEditingController();
  var txtDescription = TextEditingController();
  int isLearn;

  @override
  void initState() {
    wordName.text = word.word;
    txtDescription.text = word.description;
    isLearn = word.isLearn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.deepOrange,
        title: Text("Now Editing : ${word.word}"),
      ),
      body: buildWordDetail(),
    );
  }

  buildWordDetail() {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildTextField("Word", wordName),
            buildTextField("Description", txtDescription),
            SizedBox(height: 20),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        word.isLearn = isLearn;
                      });
                    },
                    child: Icon(
                      Icons.bookmark,
                      size: 60,
                      color: isLearn == 1 ? Colors.deepOrange : Colors.grey,
                    ),
                  ),
                  SizedBox(width: 5),
                  buildUpdateButton(word),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
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

  buildUpdateButton(Word word) {
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
            "Update",
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            updateWord(word);
          },
        ));
  }

  void updateWord(Word word) async {
    await dbHelper.update(Word.withId(
        id: word.id,
        word: wordName.text,
        description: txtDescription.text,
        isLearn: word.isLearn));
    Navigator.pop(context, true);
  }
}
