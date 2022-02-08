import 'package:flutter/material.dart';
import 'config.dart' as conf;
import 'package:intl/intl.dart';

final form = NumberFormat("#,##0", "en_US");
final form2 = NumberFormat("#,##0.00", "en_US");

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late int money = 600;

  Widget button(IconData icon, String text, var sum) {
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
                Text(
                  text,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
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

  List<Widget> addWidgets(context) {
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
        all.add(Container(
          child: Text(
            "      " +
                d.format(i).toString() +
                " " +
                MONTHS[int.parse(m.format(i)) - 1] +
                ", " +
                y.format(i),
            style: TextStyle(fontSize: 15),
          ),
        ));
      } else {
        all.add(button(conf.useIcons[i.type]!, i.type, i.sum));
      }
    }
    return all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                      margin: const EdgeInsets.only(left: 15, bottom: 15),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 50,
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
                          conf.words[conf.language]!["Your Balance"]!,
                          style: TextStyle(fontSize: 30),
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
