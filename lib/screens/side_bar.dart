import 'package:flutter/material.dart';
import 'package:word_pad/screens/home_page.dart';

import 'learned_words.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Word Pad',
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                  colorFilter: ColorFilter.srgbToLinearGamma(),
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/cover.jpg'),
                )),
          ),
          ListTile(
            leading: Icon(
              Icons.list,
              color: Colors.deepOrange,
            ),
            title: Text(
              'Words',
              style: TextStyle(fontSize: 22, color: Colors.grey.shade800),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WordsList()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.collections_bookmark,
              color: Colors.deepOrange,
            ),
            title: Text('Learned Words',
                style: TextStyle(fontSize: 22, color: Colors.grey.shade800)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LearnedWordsList()));
            },
          ),
          SizedBox(height: 320),
          Container(
            height: 50,
            decoration: BoxDecoration(color: Colors.deepOrange),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(
                    "Hasan Ali Şişeci",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  GestureDetector(
                      onTap: () {
                        showMail(context);
                      },
                      child: Icon(Icons.markunread, color: Colors.white))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showMail(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Mail",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          content: Text("h.alisiseci@gmail.com",
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: <Widget>[],
        );
      },
    );
  }
}
