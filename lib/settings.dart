import 'package:flutter/material.dart';
import "package:url_launcher/url_launcher.dart";
import 'config.dart' as conf;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  _launchURL() async {
    const url =
        "https://docs.google.com/spreadsheets/d/1SxlEH2F_5mRHfmQs5FEgf5Vv6YIzbiaK833-AIx95NY/edit#gid=0";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _changeLang() {
    conf.language = conf.language == "ru" ? "en" : "ru";
    setState(() {});
  }

  List<Widget> addWidgets(context) {
    late List<Widget> all = [];

    late List<List> text = [
      [Icons.table_rows, "Data sheet", _launchURL],
      [Icons.send, "Data export", () {}],
      [Icons.translate, "Change language", _changeLang],
      [Icons.delete, "Delete data", () {}]
    ];

    for (var i in text) {
      all.add(
        Container(
          margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
          width: MediaQuery.of(context).size.width * 10 / 10,
          height: MediaQuery.of(context).size.height * 1 / 10,
          child: ElevatedButton(
            onPressed: i[2],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  i[0],
                  color: Colors.black,
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${conf.words[conf.language]![i[1]]}",
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const Spacer(),
                const Text(
                  "❯",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
              onPrimary: const Color.fromARGB(255, 100, 224, 196),
              primary: const Color.fromARGB(255, 233, 237, 239),
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
          ),
        ),
      );
    }
    return all;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 197, 188, 212),
      body: Stack(
        children: <Widget>[
          ListView(
              padding: const EdgeInsets.all(5),
              children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 1.7 / 10,
                    ),
                  ] +
                  addWidgets(context) +
                  [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 1 / 10,
                    )
                  ]),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 208, 241, 235),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 55,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conf.words[conf.language]!["Settings"]!,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          conf.words[conf.language]!["Creat"]!,
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: const Icon(
                        Icons.menu,
                        size: 40,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
