import 'package:flutter/material.dart';
import 'config.dart' as conf;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'feedback_model.dart';
import 'dart:convert' as convert;
import 'dart:developer';

final form = NumberFormat("#,##0", "en_US");
final form2 = NumberFormat("#,##0.00", "en_US");

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Future getData() async {
    late DateTime last = DateTime(1890);
    var request = await http.get(Uri.parse(conf.link));
    if (request.statusCode == 200) {
      conf.money = 0.0;
      conf.history = [];
      conf.data = [];
      var jsonFeedback = convert.jsonDecode(request.body);
      jsonFeedback.forEach((e) {
        FeedbackModel feedbackModel = FeedbackModel();
        feedbackModel.date = e["date"];
        feedbackModel.type = e["type"];
        feedbackModel.correction = e["correction"];
        feedbackModel.comment = e["comment"];
        feedbackModel.sum = e["sum"];
        conf.money += e["sum"];
        conf.data.add(feedbackModel);
        if (last.day != DateTime.parse(e["date"]).day) {
          conf.history.add(DateTime.parse(e["date"]));
          conf.history.add(feedbackModel);
          last = DateTime.parse(e["date"]);
        } else {
          conf.history.add(feedbackModel);
        }
      });
    }
    setState(() {});
  }

  Widget button(IconData icon, String text, var sum, String add) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 30),
        height: MediaQuery.of(context).size.height / 11,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                shadowColor: Colors.transparent,
                onPrimary: const Color.fromARGB(255, 100, 224, 196),
                primary: const Color.fromARGB(255, 234, 237, 239)),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                  size: 40,
                ),
                add != ""
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                                fontSize: text.length <= 7 ? 25 : 20,
                                color: Colors.black),
                          ),
                          Text(
                            add,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 238, 177, 101)),
                          )
                        ],
                      )
                    : Text(
                        text,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: text.length <= 7 ? 25 : 20),
                      ),
                const SizedBox(
                  width: 35,
                ),
                Text(
                  form.format(sum.toInt()),
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                )
              ],
            )));
  }

  List<Widget> addWidgets() {
    List<Widget> all = [];
    var MONTHS = [
      'янв',
      'фев',
      'март',
      'апр',
      'май',
      'июнь',
      'июль',
      'авг',
      'сен',
      'окт',
      'ноя',
      'дек'
    ];
    final DateFormat m = DateFormat.M();
    final DateFormat d = DateFormat.d();
    final DateFormat y = DateFormat.y();
    for (var i in conf.history) {
      if (i.runtimeType == DateTime) {
        all.add(Text(
          "     " +
              d.format(i).toString() +
              " " +
              MONTHS[int.parse(m.format(i)) - 1] +
              ", " +
              y.format(i),
          style: const TextStyle(fontSize: 20),
        ));
      } else {
        all.add(button(conf.useIcons[i.type]!, i.type, i.sum, i.correction));
      }
    }
    return all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 1.7 / 10,
            ),
            child: RefreshIndicator(
              color: const Color.fromARGB(255, 100, 224, 196),
              onRefresh: getData,
              child: ListView(
                  padding: const EdgeInsets.all(5),
                  children: addWidgets() +
                      [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 1 / 10,
                        )
                      ]),
            ),
          ),
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
                        margin: const EdgeInsets.only(top: 5),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conf.words[conf.language]!["Your Balance"]!,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          form2.format(conf.money),
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
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
