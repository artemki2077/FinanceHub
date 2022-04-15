import 'package:flutter/material.dart';
import 'config.dart' as conf;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'feedback_model.dart';
import 'dart:convert' as convert;
import 'dart:developer';

final form = NumberFormat("#,##0", "en_US");
final form2 = NumberFormat("#,##0.00", "en_US");
final dataformat = DateFormat('yyyy/MM/dd');

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool _inf = false;
  DateTime now = DateTime.now();
  Future getData() async {
    late DateTime last = DateTime(1890);
    var request = await http.get(conf.link);
    if (request.statusCode == 200) {
      conf.money = 0.0;
      conf.history = [];
      conf.infHistory = [];
      conf.data = [];
      var jsonFeedback = convert.jsonDecode(request.body);
      jsonFeedback.forEach((e) async {
        FeedbackModel feedbackModel = FeedbackModel();
        feedbackModel.date = e["date"];
        feedbackModel.type = e["type"];
        feedbackModel.correction = e["correction"];
        feedbackModel.comment = e["comment"];
        feedbackModel.sum = e["sum"];
        // conf.money += e["sum"];
        conf.data.add(feedbackModel);
        var date = DateTime.parse(e["date"]);
        if (now.month == date.month) {
          conf.money += e["sum"];
        }
        late String mon = conf.MONTHS[date.month - 1];
        if (e["sum"] > 0) {
          if (conf.chartPlus.containsKey(mon)) {
            conf.chartPlus[mon].add(feedbackModel);
          } else {
            conf.chartPlus[mon] = [feedbackModel];
          }
          if (conf.dataPlus.containsKey(mon)) {
            if (conf.dataPlus[mon]!.containsKey(e["type"])) {
              conf.dataPlus[mon]![e["type"]] =
                  conf.dataPlus[mon]![e["type"]]! + e["sum"].toDouble();
            } else {
              conf.dataPlus[mon]![e["type"]] = e["sum"].toDouble()!;
            }
          } else {
            conf.dataPlus[mon] = {e["type"]: e["sum"].toDouble()};
          }
        } else {
          if (conf.chartMinus.containsKey(mon)) {
            conf.chartMinus[mon].add(feedbackModel);
          } else {
            conf.chartMinus[mon] = [feedbackModel];
          }
          if (conf.dataMinus.containsKey(mon)) {
            if (conf.dataMinus[mon]!.containsKey(e["type"])) {
              conf.dataMinus[mon]![e["type"]] =
                  conf.dataMinus[mon]![e["type"]]! - e["sum"].toDouble();
            } else {
              conf.dataMinus[mon]![e["type"]] = -e["sum"].toDouble()!;
            }
          } else {
            conf.dataMinus[mon] = {e["type"]: -e["sum"].toDouble()};
          }
        }
        if (last.day != date.day) {
          conf.history.add(date);
          conf.history.add(feedbackModel);
          conf.infHistory.add(date);
          conf.infHistory.add(FeedbackModel(
            comment: feedbackModel.comment,
            date: feedbackModel.date,
            type: feedbackModel.type,
            correction: feedbackModel.correction,
            sum: feedbackModel.sum,
          ));
          last = date;
        } else {
          conf.history.add(feedbackModel);
          conf.infHistory.add(FeedbackModel(
            comment: feedbackModel.comment,
            date: feedbackModel.date,
            type: feedbackModel.type,
            correction: feedbackModel.correction,
            sum: feedbackModel.sum,
          ));
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
    final nowStr = dataformat.format(now);
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

    for (var i in (_inf ? conf.infHistory : conf.history)) {
      if (i.runtimeType == DateTime) {
        all.add(Text(
          "    " +
              d.format(i).toString() +
              " " +
              MONTHS[int.parse(m.format(i)) - 1] +
              ", " +
              y.format(i),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ));
      } else {
        all.add(button(conf.useIcons[i.type]!, i.type, i.sum, i.correction));
      }
    }
    setState(() {});
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
                  children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 30, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _inf
                                      ? Icons.square_rounded
                                      : Icons.crop_square,
                                  color: Color.fromRGBO(183, 191, 255, 1),
                                  size: 35,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _inf = !_inf;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: const Flexible(
                                    child: Text(
                                  "показать суммы с учетом инфляции",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20),
                                )),
                              )
                            ],
                          ),
                        )
                      ] +
                      addWidgets()),
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
